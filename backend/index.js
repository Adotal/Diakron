// index.js
import express, { raw } from "express";
import crypto from "crypto";
// To send raw JPEG files to HugginFace:
import { Client } from "@gradio/client";
// ED25519 signatures
import * as ed from "@noble/ed25519";
import { sha512 } from "@noble/hashes/sha2.js";
import dotenv from "dotenv";
import { createClient, processLock } from '@supabase/supabase-js';
import { time } from "console";
import { stringify } from "uuid"
import WebSocket, { WebSocketServer } from 'ws';
import admin from "firebase-admin";
import { createRequire } from "module";
const require = createRequire(import.meta.url);
const serviceAccount = require("./diakron-mx-firebase-adminsdk.json");

// SDK de Mercado Pago
import { MercadoPagoConfig, Preference, Payment, OAuth } from 'mercadopago';

// Agrega credenciales
// Config dotenv
dotenv.config();

// Create a single supabase client for interacting with your database
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
// Single MercadoPago client
const clientMP = new MercadoPagoConfig({ accessToken: process.env.MP_ACCESS_TOKEN });

// Configurar el hash para las operaciones síncronas de ed25519
ed.hashes.sha512 = sha512;


//---------------------------------CONSTANTES------------------
const QR_FAILURE = 'QR_FAILURE';
const QR_SUCCESS = 'QR_SUCCESS';

// Diccionario para guardar: ID_ESP32 -> Socket_Activo
const espConnections = new Map();


const app = express();
app.use(express.json());

// This what fetching table waste_types should give
const waste_types = {
  1: 'PLÁSTICO',
  2: 'METAL',
  3: 'VIDRIO',
  4: 'PAPEL/CARTÓN',
}
// Mapeo de los campos del ESP32 a los IDs de BD
const MATERIAL_MAP = {
  plastic: 1, // PLÁSTICO
  metal: 2,   // METAL
  glass: 3,   // VIDRIO
  paper: 4    // PAPEL/CARTÓN
};
//------------------------GLOBAL VARIABLES----------------------------//

const rawPublicKeyHex = process.env.PUBLIC_KEY;
const publicKeyHex = new Uint8Array(Buffer.from(rawPublicKeyHex, 'base64'));

const rawPrivateKeyHex = process.env.PRIVATE_KEY;
const privateKeyHex = new Uint8Array(Buffer.from(rawPrivateKeyHex, 'base64'));
//-----------------------RAW IMAGE TO HUGGINFACE----------------------//

const imageParser = express.raw({ type: "image/jpeg", limit: "5mb" });

const clientHF = await Client.connect("Adotal/TrashNet");

// When gets an image
app.post("/analyze", imageParser, async (req, res) => {
  try {
    // Check existence
    if (!req.body || !req.body.length) {
      return res.status(400).json({ error: "No image received" });
    }

    // Create raw image
    const imageBlob = new Blob([req.body], { type: "image/jpeg" });

    // Send raw image and receive result
    const result = await clientHF.predict("/predict", {
      img: imageBlob,
    });

    // Add format to reiceverd JSON
    res.json({
      success: true,
      predicted: result.data[0].label,
      confidences: result.data[0].confidences.map((c) => ({
        label: c.label,
        confidence: Math.round(c.confidence * 100),
      })),
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Inference failed" });
  }
});


//-----------------------MIDDLEWARE SUPABASE AUTH-------------------//

const requireSupabaseAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: "Token no proporcionado o mal formado" });
    }

    const token = authHeader.split(' ')[1];

    // getUser valida el token y devuelve el usuario si es legítimo
    const { data, error } = await supabase.auth.getUser(token);

    if (error || !data.user) {
      return res.status(401).json({ error: "Token inválido o expirado" });
    }

    // Inyectamos el usuario de Supabase en la request para la siguiente función
    req.user = data.user;
    next();
  } catch (err) {
    return res.status(500).json({ error: "Error validando autenticación" });
  }
};

//-----------------------QR VERIFY SIGNATURE--------------------------//
// Parser for QR payload
const qrParser = express.raw({
  type: "application/octet-stream",
  limit: "128b",    // Only 88b needed, but allows tiny variations
});


//-------------------------------QR VERIFICATION--------------------

// Prices in MXN to calculate points
const priceMetalPerKg = 18;
const pricePlasticPerKg = 5;
const priceGlassPerKg = 1.4;
const pricePaperPerKg = 0.8;

// Verify QR as a participant to get points with a segregator
app.post("/verify-qr", requireSupabaseAuth, qrParser, async (req, res) => {

  // Variable para guardar el socket y el ID una vez parseado
  let targetWs = null;
  let segregatorIdInt = null;

  // Función auxiliar para notificar a la ESP32 sin repetir código
  const notifyEsp = (status) => {
    if (targetWs && targetWs.readyState === 1) { // 1 = OPEN
      targetWs.send(status);
      console.log(`[WS] Notificado ${status} a ESP32 ID: ${segregatorIdInt}`);
    }
  };

  try {

    // From supabase auth
    const userIdUuid = req.user.id;
    // req.body is automatically fully populated as a Buffer by express.raw()
    const data = req.body;

    // Separa mensaje y firma
    const message = new Uint8Array(data.subarray(0, data.length - 64));
    const signature = new Uint8Array(data.subarray(data.length - 64));


    // Extraer ID del segregador (necesario para saber a cual segregador (websocket) notificar el error)
    // Big endian 2B int    
    const segregatorId = Buffer.from(new Uint8Array(message.subarray(0, 2)));
    segregatorIdInt = segregatorId.readUIntBE(0, segregatorId.length);

    // Buscar la conexión activa en el Map global
    targetWs = espConnections.get(segregatorIdInt);

    //  Verifica firma (Ed25519)
    const isValid = ed.verify(signature, message, publicKeyHex);
    if (!isValid) {
      notifyEsp(QR_FAILURE);
      return res.status(401).json({ valid: false, error: "Firma inválida" })
    };

    // Como se sabe que es verídico, decodifica payload
    // Big endian 1B int
    const countMetal = message[2]
    // Big endian 2B int
    const weightMetal = Buffer.from(new Uint8Array(message.subarray(3, 5)));
    const weightMetalInt = weightMetal.readUIntBE(0, weightMetal.length);

    // Big endian 1B int
    const countPlastic = message[5];
    // Big endian 2B int
    const weightPlastic = Buffer.from(new Uint8Array(message.subarray(6, 8)));
    const weightPlasticInt = weightPlastic.readUIntBE(0, weightPlastic.length);

    // Big endian 1B int
    const countPaper = message[8];
    // Big endian 2B int
    const weightPaper = Buffer.from(new Uint8Array(message.subarray(9, 11)));
    const weightPaperInt = weightPaper.readUIntBE(0, weightPaper.length);

    // Big endian 1B int
    const countGlass = message[11];
    // Big endian 2B int
    const weightGlass = Buffer.from(new Uint8Array(message.subarray(12, 14)));
    const weightGlassInt = weightGlass.readUIntBE(0, weightGlass.length);

    // Timestamp 4B
    const timestamp = Buffer.from(new Uint8Array(message.subarray(14, 18)));
    const timestampInt = timestamp.readUIntBE(0, timestamp.length);

    const nonce = new Uint8Array(message.subarray(18, 26));
    const nonceHex = Buffer.from(nonce).toString("hex")

    // TESTING
    console.log(message + '\n' + ' - ' +
      segregatorIdInt + '\n' +
      countMetal + ' ' + weightMetalInt + '\n' +
      countPlastic + ' ' + weightPlasticInt + '\n' +
      countGlass + ' ' + weightGlassInt + '\n' +
      countPaper + ' ' + weightPaperInt + '\n' +
      ' - ' + timestampInt + '\n' +
      nonce + ' - ' + nonceHex);

    // Validación de Tiempo (15 minutos de vigencia QR)
    const currentTimestamp = Math.floor(Date.now() / 1000);

    console.log({ CurrentTimestamp: currentTimestamp })
    // 15 minutos son 900 segundos
    if (Math.abs(currentTimestamp - timestampInt) > 900) {
      notifyEsp(QR_FAILURE);
      return res.status(403).json({ valid: false, error: "QR expirado" });
    }

    // Verificar no repeticiones
    // Inserta en tabla de nocne Si ya existe retornará error porque el campo es UNIQUE    
    const { error: errorNonce } = await supabase
      .from('qr_check')
      .insert([
        {
          nonce: nonceHex,
        }
      ]);

    if (errorNonce) {
      notifyEsp(QR_FAILURE);
      // Violación de unicidad (Duplicate Key)
      if (errorNonce.code === '23505') {
        return res.status(409).json({ valid: false, error: "Este QR ya fue utilizado" });
      }
      // Si es otro error de base de datos, lo lanzamos al catch global de la ruta
      throw errorNonce;
    }


    let finalWeight = 0;
    // Identificar material y calcular puntos
    let points = 0;
    let materialType = '';

    // Como sólo 1 variable count es distinta de 0, points sólo recibirá el peso (weight) que necesita
    points =
      countMetal * weightMetalInt * priceMetalPerKg +
      countPlastic * weightPlasticInt * pricePlasticPerKg +
      countGlass * weightGlassInt * priceGlassPerKg +
      countPaper * weightPaperInt * pricePaperPerKg;

    // Los puntos siempre son un valor entero
    points *= 10;

    if (countMetal > 0) {
      materialType = 'METAL';
      finalWeight = weightMetalInt;
    } else if (countPlastic > 0) {
      materialType = 'PLÁSTICO';
      finalWeight = weightPlasticInt;
    } else if (countGlass > 0) {
      materialType = 'VIDRIO';
      finalWeight = weightGlassInt;
    } else if (countPaper > 0) {
      materialType = 'PAPEL/CARTÓN';
      finalWeight = weightPaperInt;
    }

    console.log(materialType);
    // Get material ID in database
    const { data: dataMaterial, error: errorMaterial } =
      await supabase
        .from('waste_types')
        .select('id')
        .eq('waste_type', materialType)
        .single();

    if (errorMaterial || !dataMaterial) {
      notifyEsp(QR_FAILURE);
      console.error('Material not found or error occurred:', errorMaterial);
      throw errorMaterial;
    }
    console.log(dataMaterial);
    const materialId = dataMaterial.id;


    // TESTING
    console.log('MaterialID: ', materialId, ' ', materialType);
    console.log('Points: ', points);
    console.log('User: ', userIdUuid);

    // Formatea timestamp
    // Convierte segundos a milisegundos y luego a ISO string
    const dateToSave = new Date(timestampInt * 1000).toISOString();

    // Si el programa llegó aquí es válido, vigente y no duplicado
    // Registramos en la tabla de historial.
    const { error: errorExchange } = await supabase
      .from('drop_waste')
      .insert([
        {
          id_segregator: segregatorIdInt,
          id_participant: userIdUuid,
          id_waste_type: materialId,
          timestamp: dateToSave,
          weight_grams: finalWeight,
        }
      ]);

    if (errorExchange) {
      notifyEsp(QR_FAILURE);
      throw errorExchange;
    };

    // Llama RPC para sumar puntos al usuario
    const { data: success, error: errorSum } = await supabase.rpc('add_points', {
      p_user_id: userIdUuid,
      p_points: points
    });

    if (errorSum || !success) {
      notifyEsp("QR_FAILURE");
      return res.status(400).json({ error: "Error al sumar puntos o usuario no encontrado" });
    }

    // Si el programa llegó aquí, TODA LA TRANSACCIÓN FUE CORRECTA    
    notifyEsp("QR_SUCCESS");

    // Send a structured JSON response
    return res.status(200).json({
      valid: true,
      points: points,
    });

  } catch (err) {
    console.error("[SERVER ERROR]:", err);
    notifyEsp("QR_FAILURE");
    res.status(500).json({ valid: false, error: "Internal Server Error" });
  }
});
// Verify QR to redeem coupon
app.post("/verify-qr-participant", requireSupabaseAuth, qrParser, async (req, res) => {
  try {
    // This ID came signed by supabase, a client could not fake it
    const storeIdUUID = req.user.id;

    const data = req.body;

    // Separa mensaje y firma
    const message = new Uint8Array(data.subarray(0, data.length - 64));
    const signature = new Uint8Array(data.subarray(data.length - 64));

    //  Verifica firma (Ed25519)
    const isValid = ed.verify(signature, message, publicKeyHex);
    if (!isValid) return res.status(401).json({ valid: false, error: "Firma inválida" });

    // Decodifica el Payload
    // Decodificamos el payload que ya sabemos que es verídico
    // const { userId, couponId, timestamp, nonce } = JSON.parse(Buffer.from(message).toString());

    // 16 bytes to uuid
    const userId = new Uint8Array(message.subarray(0, 16));
    const userIdUUID = stringify(userId);
    // Big endian 2B int
    const couponId = Buffer.from(new Uint8Array(message.subarray(16, 18)));
    const couponIdInt = couponId.readUIntBE(0, couponId.length);
    // Timestamp 4B
    const timestamp = Buffer.from(new Uint8Array(message.subarray(18, 22)));
    const timestampInt = timestamp.readUIntBE(0, timestamp.length);

    const nonce = new Uint8Array(message.subarray(22, 30));
    const nonceHex = Buffer.from(nonce).toString("hex")

    // TESTING
    console.log(message + '\n' + userId + ' - ' + userIdUUID + '\n' + couponId + ' - ' + couponIdInt + '\n' + timestamp + ' - ' + timestampInt + '\n' + nonce + ' - ' + nonceHex);
    // Validación de Tiempo (15 minutos de vigencia QR)
    const currentTimestamp = Math.floor(Date.now() / 1000);

    console.log({ CurrentTimestamp: currentTimestamp })
    // 15 minutos son 900 segundos
    if (Math.abs(currentTimestamp - timestampInt) > 900) {
      return res.status(403).json({ valid: false, error: "QR expirado" });
    }

    // VERIFICACIÓN EN BASE DE DATOS (Nonce Check)
    // Intentamos buscar si este nonce ya existe en nuestra tabla de canjes
    // Si ya existe retornará error porque el campo es UNIQUE    
    const { error: errorNonce } = await supabase
      .from('qr_check')
      .insert([
        {
          nonce: nonceHex,
        }
      ]);

    if (errorNonce) {
      // Violación de unicidad (Duplicate Key)
      if (errorNonce.code === '23505') {
        return res.status(409).json({ valid: false, error: "Este QR ya fue utilizado" });
      }
      // Si es otro error de base de datos, lo lanzamos al catch global de la ruta
      throw errorNonce;
    }

    // Llama RPC para restar puntos y hacer registro en exchanges
    const { data: success, error } = await supabase.rpc('deduct_points', {
      p_user_id: userIdUUID,
      p_coupon_id: couponIdInt,
      p_store_id: storeIdUUID,
    });

    if (error) throw error;

    if (!success) {
      return res.status(400).json({ valid: false, error: "Puntos insuficientes o cupón inválido para esta tienda" });
    }

    // Si el programa aquí, el canje es válido y único
    return res.status(200).json({
      valid: true,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ valid: false });
  }
});

// Verify QR to authenticate collector and open bins in a segregator
app.post("/verify-qr-collector", requireSupabaseAuth, qrParser, async (req, res) => {

  // Variable para guardar el socket y el ID una vez parseado
  let targetWs = null;
  let segregatorIdInt = null;

  // Función auxiliar para notificar a la ESP32 sin repetir código
  const notifyEsp = (status) => {
    if (targetWs && targetWs.readyState === 1) { // 1 = OPEN
      targetWs.send(status);
      console.log(`[WS] Notificado ${status} a ESP32 ID: ${segregatorIdInt}`);
    }
  };

  try {
    // This ID came signed by supabase, a client could not fake it
    const collectorIdUUID = req.user.id;
    const rawBuffer = req.body;

    // Separa primer byte, tiene tipos de materiales
    // Extraer el primer byte
    const materialsByte = rawBuffer[0];

    // Extraer el resto del payload (solo QR)
    const data = rawBuffer.subarray(1);

    // Separa mensaje y firma
    const message = new Uint8Array(data.subarray(0, data.length - 64));
    const signature = new Uint8Array(data.subarray(data.length - 64));

    // Extraer ID del segregador (necesario para saber a cual segregador (websocket) notificar el error)
    // Big endian 2B int    
    const segregatorId = Buffer.from(new Uint8Array(message.subarray(0, 2)));
    segregatorIdInt = segregatorId.readUIntBE(0, segregatorId.length);

    // Buscar la conexión activa en el Map global
    targetWs = espConnections.get(segregatorIdInt);

    //  Verifica firma (Ed25519)
    const isValid = ed.verify(signature, message, publicKeyHex);
    if (!isValid) return res.status(401).json({ valid: false, error: "Firma inválida" });

    // Decodifica el Payload
    // Decodificamos el payload que ya sabemos que es verídico

    // Reconstruir la lista de materiales usando operadores Bitwise AND
    const selectedMaterials = [];
    if ((materialsByte & 1) !== 0) {
      // Metal
      selectedMaterials.push(waste_types[2]);

      // Genera payload QR
    }
    if ((materialsByte & 2) !== 0) {
      // Plastic
      selectedMaterials.push(waste_types[1]);
    }
    if ((materialsByte & 4) !== 0) {
      // Paper/Cardboard
      selectedMaterials.push(waste_types[4]);
    }
    if ((materialsByte & 8) !== 0) {
      // Glass
      selectedMaterials.push(waste_types[3]);
    }

    console.log("Materiales decodificados:", selectedMaterials.toString());
    console.log("Tamaño original del QR:", data.length);

    // Timestamp 4B
    const timestamp = Buffer.from(new Uint8Array(message.subarray(2, 6)));
    const timestampInt = timestamp.readUIntBE(0, timestamp.length);

    const nonce = new Uint8Array(message.subarray(6, 14));
    const nonceHex = Buffer.from(nonce).toString("hex")

    // TESTING
    console.log('Collector UUID: ', collectorIdUUID);
    console.log(message + '\n' + ' - ' + segregatorIdInt + '\n' + timestamp + ' - ' + timestampInt + '\n' + nonce + ' - ' + nonceHex);
    // Validación de Tiempo (15 minutos de vigencia QR)
    const currentTimestamp = Math.floor(Date.now() / 1000);

    console.log({ CurrentTimestamp: currentTimestamp })
    // 1 minutos son 60 segundos
    if (Math.abs(currentTimestamp - timestampInt) > 60) {
      return res.status(403).json({ valid: false, error: "QR expirado" });
    }

    // VERIFICACIÓN EN BASE DE DATOS (Nonce Check)
    // Intentamos buscar si este nonce ya existe en nuestra tabla de canjes
    // Si ya existe retornará error porque el campo es UNIQUE    
    const { error: errorNonce } = await supabase
      .from('qr_check')
      .insert([
        {
          nonce: nonceHex,
        }
      ]);

    if (errorNonce) {
      // Violación de unicidad (Duplicate Key)
      if (errorNonce.code === '23505') {
        return res.status(409).json({ valid: false, error: "Este QR ya fue utilizado" });
      }
      // Si es otro error de base de datos, lo lanzamos al catch global de la ruta
      throw errorNonce;
    }

    // Armamos un arreglo con los registros a insertar
    const collectionsToInsert = [];

    // waste_types mapping: 1: 'PLÁSTICO', 2: 'METAL', 3: 'VIDRIO', 4: 'PAPEL/CARTÓN'
    if ((materialsByte & 1) !== 0) {
      // Metal (id: 2)
      collectionsToInsert.push({
        id_collector: collectorIdUUID,
        id_waste_type: 2,
        id_segregator: segregatorIdInt,
        is_complete: false
      });
    }
    if ((materialsByte & 2) !== 0) {
      // Plastic (id: 1)
      collectionsToInsert.push({
        id_collector: collectorIdUUID,
        id_waste_type: 1,
        id_segregator: segregatorIdInt,
        is_complete: false
      });
    }
    if ((materialsByte & 4) !== 0) {
      // Paper/Cardboard (id: 4)
      collectionsToInsert.push({
        id_collector: collectorIdUUID,
        id_waste_type: 4,
        id_segregator: segregatorIdInt,
        is_complete: false
      });
    }
    if ((materialsByte & 8) !== 0) {
      // Glass (id: 3)
      collectionsToInsert.push({
        id_collector: collectorIdUUID,
        id_waste_type: 3,
        id_segregator: segregatorIdInt,
        is_complete: false
      });
    }

    if (collectionsToInsert.length > 0) {

      // Insertar en la tabla waste_collections solo si hay materiales seleccionados
      const { data: insertedRows, error: insertError } = await supabase
        .from('waste_collections')
        .insert(collectionsToInsert)
        .select();

      if (insertError) {
        throw insertError; // Si falla, lo mandamos al catch global
      }
      console.log(`Guardados ${collectionsToInsert.length} registros en waste_collections`);


      // GENERAR UN PAYLOAD QR POR CADA REGISTRO INSERTADO
      const payloadsQRToInsert = insertedRows.map(row => {
        // UUID Collector (16 bytes)
        const uuidBuffer = Buffer.from(row.id_collector.replace(/-/g, ''), 'hex');

        // ID Waste Collection (4 bytes)
        const idBuffer = Buffer.alloc(4);
        idBuffer.writeUInt32BE(row.id, 0);

        // Timestamp (4 bytes)
        const tsBuffer = Buffer.alloc(4);
        tsBuffer.writeUInt32BE(Math.floor(Date.now() / 1000), 0);

        // Nonce (8 bytes)
        const nonceBuffer = crypto.randomBytes(8);

        // Unir todo el mensaje (32 bytes totales)
        const payloadBuffer = Buffer.concat([uuidBuffer, idBuffer, tsBuffer, nonceBuffer]);

        // Firmar (64 bytes)
        const sig = ed.sign(payloadBuffer, privateKeyHex);

        // Final Buffer (96 bytes)
        const finalBuffer = Buffer.concat([payloadBuffer, Buffer.from(sig)]);

        return {
          id_collection: row.id,
          payload: finalBuffer.toString('base64')
        };
      });

      // GUARDAR LOS PAYLOADS en DB
      const { error: payloadError } = await supabase
        .from('waste_collections_payloads')
        .insert(payloadsQRToInsert);

      if (payloadError) throw payloadError;

      console.log(`Generados ${payloadsQRToInsert.length} payloads QR exitosamente.`);
    }

    //  Armar el string 1/0 directamente desde los bits
    const m = (materialsByte & 1) !== 0 ? 1 : 0; // Metal
    const p = (materialsByte & 2) !== 0 ? 1 : 0; // Plástico
    const c = (materialsByte & 4) !== 0 ? 1 : 0; // Cartón
    const g = (materialsByte & 8) !== 0 ? 1 : 0; // Vidrio

    // Notifica esp32 de abrir compuertas
    const espCommand = `COL:${m}${p}${c}${g}`;

    console.log(espCommand);

    // Enviar por WebSocket
    notifyEsp(espCommand);

    // Si el programa aquí, el canje es válido y único
    return res.status(200).json({
      valid: true,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ valid: false });
  }
});

// Verify QR as collection center to receive collector's collecions
/*

  QR Has the structure:
  collectiorUUID  - 16 Bytes
  collectionId    - 4 B
  timestamp       - 4 B
  nonce           - 8 B
  signature       - 64 B
  ----------------------
  total           - 96 B

*/
app.post("/verify-qr-collection-center", requireSupabaseAuth, qrParser, async (req, res) => {
  try {
    // This ID came signed by supabase, a client could not fake it
    const ccenterIdUUID = req.user.id;

    const data = req.body;

    // Separa mensaje y firma
    const message = new Uint8Array(data.subarray(0, data.length - 64));
    const signature = new Uint8Array(data.subarray(data.length - 64));

    //  Verifica firma (Ed25519)
    const isValid = ed.verify(signature, message, publicKeyHex);
    if (!isValid) return res.status(401).json({ valid: false, error: "Firma inválida" });

    // Decodifica el Payload
    // 16 bytes to uuid
    const userId = new Uint8Array(message.subarray(0, 16));
    const userIdUUID = stringify(userId);
    // Big endian 4B int
    const collectionId = Buffer.from(new Uint8Array(message.subarray(16, 20)));
    const collectionIdInt = collectionId.readUIntBE(0, collectionId.length);
    // Timestamp 4B
    const timestamp = Buffer.from(new Uint8Array(message.subarray(20, 24)));
    const timestampInt = timestamp.readUIntBE(0, timestamp.length);

    const nonce = new Uint8Array(message.subarray(24, 32));
    const nonceHex = Buffer.from(nonce).toString("hex")

    // TESTING
    console.log(message + '\n' + userId + ' - ' + userIdUUID + '\n' + ' - ' + collectionIdInt + '\n' + timestamp + ' - ' + timestampInt + '\n' + nonce + ' - ' + nonceHex);

    const currentTimestamp = Math.floor(Date.now() / 1000);

    console.log({ CurrentTimestamp: currentTimestamp })
    // 24 horas son 86400 segundos
    if (Math.abs(currentTimestamp - timestampInt) > 86400) {
      return res.status(403).json({ valid: false, error: "QR expirado" });
    }

    // VERIFICACIÓN EN BASE DE DATOS (Nonce Check)
    // Intentamos buscar si este nonce ya existe en nuestra tabla de canjes
    // Si ya existe retornará error porque el campo es UNIQUE    
    const { error: errorNonce } = await supabase
      .from('qr_check')
      .insert([
        {
          nonce: nonceHex,
        }
      ]);

    if (errorNonce) {
      // Violación de unicidad (Duplicate Key)
      if (errorNonce.code === '23505') {
        return res.status(409).json({ valid: false, error: "Este QR ya fue utilizado" });
      }
      // Si es otro error de base de datos, lo lanzamos al catch global de la ruta
      throw errorNonce;
    }

    console.log('SUCCESS COLLECTION AUTH');
    // Si el programa aquí, el canje es válido y único
    // Returns collection ID
    return res.status(200).json({
      valid: true,
      collectionId: collectionIdInt,
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ valid: false });
  }
});

//-------------------------------QR GENERATION--------------------
// Ruta de generación del QR de participante
app.post("/gen-qr", requireSupabaseAuth, (req, res) => {
  try {

    // This ID came signed by supabase, a client could not fake it
    const userIdUuid = req.user.id;
    const couponId = req.body.couponId;

    // UUID (16 bytes)
    const uuidHex = userIdUuid.replace(/-/g, '');
    const uuidBuffer = Buffer.from(uuidHex, 'hex');

    // Coupon ID (2 bytes)
    const couponBuffer = Buffer.alloc(2);
    couponBuffer.writeUInt16BE(couponId, 0);

    // Timestamp (4 bytes)
    const timestamp = Math.floor(Date.now() / 1000);
    const finalTsBuffer = Buffer.alloc(4);
    finalTsBuffer.writeUInt32BE(timestamp);

    // Nonce (8 bytes)
    const nonceBuffer = crypto.randomBytes(8);

    // Unir 29 bytes
    const payloadBuffer = Buffer.concat([uuidBuffer, couponBuffer, finalTsBuffer, nonceBuffer]);

    const signature = ed.sign(payloadBuffer, privateKeyHex);
    const finalBuffer = Buffer.concat([payloadBuffer, Buffer.from(signature)]);

    // Convertir el payload a string Hexadecimal para JSON
    const payloadBase64 = finalBuffer.toString('base64');
    console.log('Generated QR: ' + payloadBase64);
    return res.status(200).json({ qrData: payloadBase64 });

  } catch (err) {
    console.log(err);
    res.status(500).json({ error: "Error interno del servidor" });
  }
});
//-------------------------------GEOFENCES------------------------
// Endpoint que Flutter llamará periódicamente en background
app.post("/update-location", async (req, res) => {
  try {
    const { userId, lat, lon, fcmToken } = req.body;

    // --- RESTRICCIÓN HORARIA (9:00 a 21:00) ---
    // Guadalajara entra en Zona de CDMX
    const options = {
      timeZone: 'America/Mexico_City',
      hour: 'numeric',
      hour12: false,
    };

    const formatter = new Intl.DateTimeFormat('es-MX', options);
    const currentHour = parseInt(formatter.format(new Date()));

    console.log(`Hora actual detectada: ${currentHour}:00`);

    // Si la hora es menor a 9 o mayor/igual a 21, no enviamos notificación
    if (currentHour < 9 || currentHour >= 21) {
      console.log("Fuera de horario de notificaciones (9:00 - 21:00). Saltando envío.");
      return res.status(200).json({
        success: true,
        message: "Ubicación recibida, pero fuera de horario de notificaciones."
      });
    }

    // El programa llegó aquí si el horario es de 9:00 a 21:00

    // Llamar a la función espacial de Supabase
    const { data: nearbySegregators, error } = await supabase.rpc('get_nearby_critical_segregators', {
      user_lat: lat,
      user_lon: lon,
      radius_meters: 5000 // 5km
    });

    if (error) throw error;

    // Si encontró segregadores críticos cerca, enviar Notificación Push
    if (nearbySegregators && nearbySegregators.length > 0 && fcmToken) {

      // Tomaremos el segregador MÁS CERCANO (el índice 0 gracias al ORDER BY de SQL)
      // Para enviar una notificación por CADA segregador, se puede hacer un bucle for/of
      const closestSegregator = nearbySegregators[0];
      // Convertir metros a kilómetros con 1 decimal (Ej: 1.2 km)
      const distanceKm = (closestSegregator.distancia_metros / 1000).toFixed(1);

      // Formatear los niveles de llenado
      // Mapeamos el array de JSON a un string con saltos de línea
      const binLevelsString = closestSegregator.bins.map(bin => {
        // Agregamos un emoji de alerta si supera el 80%
        const alert = bin.filling_percentage > 80 ? ' 🔴' : ' 🟢';
        return `• ${bin.waste_type}: ${bin.filling_percentage}%${alert}`;
      }).join('\n');

      // Cuerpo de la notificación
      const notificationBody = `📍 Distancia: ${distanceKm} km\n${binLevelsString}`;

      // Aquí usamos Firebase Admin SDK para enviar el Push
      const message = {
        notification: {
          title: `¡Segregador #${closestSegregator.segregator_id} requiere recolección!`,
          body: notificationBody,
        },
        data: {
          action: "OPEN_SEGREGATOR_DETAILS",
          segregatorId: closestSegregator.segregator_id.toString(),
        },
        token: fcmToken,
      };

      // Send via FCM
      await admin.messaging().send(message);
      console.log(`Notificación enviada para segregador ${closestSegregator.segregator_id}`);
    }

    res.status(200).json({ success: true });

  } catch (err) {
    console.error("Error del servidor:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
});


//-------------------------------APP---------------------------//

const server = app.listen(process.env.PORT || 3000, () => {
  console.log("Servidor corriendo...");
});

//---------------------------WEBSOCKET-------------------
// Vincula el WebSocket al mismo servidor HTTP
const wss = new WebSocketServer({ server });

wss.on('connection', (ws) => {
  console.log("Nueva conexión WS detectada");
  ws.on('message', async (data) => {
    try {
      const message = JSON.parse(data);

      // CASO REGISTRO de ESP32
      if (message.type === 'REGISTER') {
        ws.espId = message.id;
        espConnections.set(message.id, ws);
        console.log(`ESP32 registrada con ID: ${ws.espId}`);
        return;
      }

      // CASO NIVELES DE LLENADO (FL)
      if (message.type === 'FL') {
        // Obtenemos el ID del segregador desde el socket activo o del mensaje como fallback
        const idSegregator = ws.espId || message.id_segregator;

        if (!idSegregator) {
          console.error("Error: Se recibieron niveles de llenado pero la ESP32 no está registrada.");
          return;
        }

        // Estructuramos los registros para Supabase dinámicamente
        const records = [];

        for (const [key, idWasteType] of Object.entries(MATERIAL_MAP)) {
          if (message[key] !== undefined) {
            records.push({
              id_segregator: idSegregator,
              id_waste_type: idWasteType,
              filling_percentage: Math.min(Math.max(parseInt(message[key]), 0), 100), // Validar rango 0-100
              last_date: new Date().toISOString() // Forzar actualización de timestamp
            });
          }
        }

        if (records.length === 0) return;

        // Enviamos todo en una sola petición a la base de datos
        // Usamos .upsert() para que actualice el nivel actual en lugar de llenar la tabla de basura.
        const { error } = await supabase
          .from('filling_level_bins')
          .upsert(records, {
            onConflict: 'id_segregator,id_waste_type'
          });

        if (error) {
          console.error(`Error guardando niveles para ESP32 ${idSegregator}:`, error.message);
        } else {
          console.log(`Niveles actualizados con éxito para el Segregador: ${idSegregator}`);
        }
      }

    } catch (e) {
      console.log("Mensaje WS no es un JSON válido o hubo un error de parseo");
    }
  });

  ws.on('close', () => {
    if (ws.espId) {
      espConnections.delete(ws.espId);
      console.log(`ESP32 ID ${ws.espId} desconectada`);
    }
  });
});


//------------------------------------Mercado Pago-----------
// Node.js
app.post("/payment-ccenter", async (req, res) => {
  try {

    // Payment data
    const { material, amount, mass, collectionId, ccenterId, collectorId, isCash } = req.body;


    let finalAmount, fee, title, finalAccessToken;

    if (isCash) {
      // PAGO EN EFECTIVO: El recolector ya recibió sus 80%.
      // El Centro de Acopio solo le paga el 20% a la Administración.
      finalAmount = amount * 0.20;
      fee = Number(0); // No hay split, el 100% de este pago va a la Admin
      title = `Comisión Administración - ${material}`;
      finalAccessToken = process.env.MP_ACCESS_TOKEN;
    } else {
      // CASO DIGITAL: Se paga el 100%.
      // El 80% va al Recolector y el 20% a la Administración.
      finalAmount = amount;
      fee = Number(amount) * 0.20;
      title = `Pago Reciclaje - ${material}`;
      // El access token es el recolector

      const { data: dataToken, error: errorToken } =
        await supabase
          .from('collectors')
          .select('mp_access_token')
          .eq('id', collectorId)
          .single();

      if (errorToken || !dataToken?.mp_access_token) {
        return res.status(404).json({ error: "Recolector no encontrado o sin MercadoPago vinculado" });
      }
      finalAccessToken = dataToken.mp_access_token;

    }

    console.log('FinalToken: ', finalAccessToken);

    // const preference = new Preference(clientMP);    
    // INICIALIZAR EL CLIENTE CON EL TOKEN DEL RECOLECTOR
    const clientMPFinal = new MercadoPagoConfig({ accessToken: finalAccessToken });
    const preference = new Preference(clientMPFinal);

    const result = await preference.create({
      body: {
        // Collection ID
        external_reference: collectionId,

        // Data needed to store collection in DB when Webhook notification
        metadata: {
          ccenter_id: ccenterId,
          collection_id: collectionId,
          mass_grams: mass,
          material_type: material,
          is_cash: isCash,
          original_amount: Number(amount),
        },

        items: [
          {
            title: title,
            quantity: 1,
            unit_price: Number(finalAmount),
            currency_id: 'MXN'
          }
        ],
        // Como se utiliza el token del recolector, MP le da el dinero a él
        // pero le retiene esta cantidad (fee) y te la envía a la cuenta de admnistración.
        marketplace_fee: Number(fee.toFixed(2)),
        back_urls: {
          success: "diakron.collectioncenter://mp/success",
          failure: "diakron.collectioncenter://mp/failure",
          pending: "diakron.collectioncenter://mp/pending"
        },
        // Aquí es donde Mercado Pago sabe cuánto mandarle a la cuenta Admin
        // marketplace_fee: 20,
        auto_return: "approved",

        // When payment completed, notify this URL to save delivery in DB
        // notification_url: "https://BACKEND_URL/mp-webhook"
      }
    });


    // TESTING
    console.log("Preferencia creada:\nSandbox URL: ", result.sandbox_init_point,
      "\nProduction URL: ", result.init_point
    );
    // Send response
    return res.json({
      sandboxURL: result.sandbox_init_point,
      // Sanbox gives problems and init point can be perfectly be used with test credentials
      initPoint: result.init_point
    });
  } catch (err) {
    console.error("Error en MP:", err);
    res.status(500).json({ error: err.message });
  }
});

app.post("/mp-webhook", async (req, res) => {
  const { query } = req;

  // Mercado Pago envía avisos de varios tipos, nos interesa 'payment'
  const topic = query.topic || query.type;

  try {
    if (topic === "payment") {
      const paymentId = query.id || req.body.data.id;

      // Retrieve data from payment register
      const payment = await new Payment(clientMP).get({ id: paymentId });

      if (payment.status == "approved") {
        const metadata = payment.metadata;
        // PAGO DE INCENTIVO A TIENDA (ADMIN -> STORE)
        //   if (metadata && metadata.payout_type === 'STORE_INCENTIVE') {
        //     const storeId = metadata.store_id;
        //     const originalAmount = metadata.original_amount;
        //     const rep_percentage = metadata.rep_percentage;

        //     // Avoid duplicate records
        //     const { data: existingRecord } = await supabase
        //       .from('incentives_stores')
        //       .select('id')
        //       .eq('mp_payment_id', paymentId)
        //       .single();

        //     if (existingRecord) {
        //       console.log(`Pago ${paymentId} ya fue procesado. Ignorando...`);
        //       // Stops MP notification
        //       return res.sendStatus(200);
        //     }
        //     console.log(`Procesando pago aprobado de incentivo para Tienda ID: ${storeId}`);

        //     // Store payment in DB
        //     const { error: errorInsert } = await supabase
        //       .from('incentives_stores')
        //       .insert({
        //         id_store: storeId,
        //         amount: originalAmount,

        //         mp_payment_id: paymentId
        //       });

        //     if (errorInsert) throw errorInsert;

        //     console.log(`Incentivo de tienda ${paymentId} registrado con éxito.`);
        //   }
        // } else {

        // Avoid duplicate records
        const { data: existingRecord } = await supabase
          .from('waste_deliveries')
          .select('id')
          .eq('mp_payment_id', paymentId)
          .single();

        if (existingRecord) {
          console.log(`Pago ${paymentId} ya fue procesado. Ignorando...`);
          // Stops MP notification
          return res.sendStatus(200);
        }

        // Get needed info to store in DB
        const collectionId = payment.external_reference;
        const ccenterId = payment.metadata.ccenter_id;
        const mass = payment.metadata.mass_grams;
        const mpTransactionAmount = payment.transaction_amount;

        const isCashPaid = payment.metadata.is_cash;
        const originalAmount = Number(payment.metadata.original_amount);

        console.log("webh ", ccenterId);

        let brute_amount, commission, net_amount;

        if (isCashPaid) {
          // CASO EFECTIVO:
          // El bruto real es el total (100%) enviado en metadata
          brute_amount = originalAmount;
          // La comisión es exactamente lo que se pagó en Mercado Pago (el 20%)
          commission = mpTransactionAmount;
          // El neto es el 80% restante que ya se dio en mano
          net_amount = brute_amount - commission;
        } else {
          // CASO DIGITAL:
          // El bruto es lo que cobró Mercado Pago (100%)
          brute_amount = mpTransactionAmount;
          commission = brute_amount * 0.20;
          net_amount = brute_amount * 0.80;
        }

        // Change status from pending to completed                  
        const { error: errorChangeStatus } = await supabase
          .from('waste_collections')
          .update({ is_complete: true })
          .eq('id', collectionId);
        if (errorChangeStatus) throw errorChangeStatus;

        // Store waste_delivery
        const { error: errorInsert } = await supabase
          .from('waste_deliveries')
          .insert({
            id_collection_center: ccenterId,
            id_waste_collection: collectionId,
            mass_grams: mass,
            brute_amount: Number(brute_amount.toFixed(2)),
            commission: Number(commission.toFixed(2)),
            net_amount: Number(net_amount.toFixed(2)),
            mp_payment_id: paymentId,
            payment_method: isCashPaid ? 'CASH' : 'MERCADO_PAGO',
          });

        if (errorInsert) throw errorInsert;
        console.log(`Recolección ${paymentId} actualizada con éxito`);
      }
    }

    // Siempre responde 200 a Mercado Pago para que deje de reintentar
    res.sendStatus(200);
  } catch (err) {
    console.error("Error en Webhook:", err);
    res.sendStatus(500);
  }
});

// Link Mercado Pago users accounts to the system
app.get("/oauth/callback", async (req, res) => {
  const { code, state } = req.query;

  if (!code || !state) {
    return res.status(400).send("Faltan parámetros requeridos");
  }

  try {

    // State is USER_TYPE:ID
    const [userType, userId] = state.split(":");

    // Intercambiar el código por el Access Token
    const response = await fetch("https://api.mercadopago.com/oauth/token", {
      method: "POST",
      headers: {
        "accept": "application/json",
        "content-type": "application/x-www-form-urlencoded"
      },
      body: new URLSearchParams({
        client_id: process.env.MP_CLIENT_ID,
        client_secret: process.env.MP_CLIENT_SECRET,
        grant_type: "authorization_code",
        code: code,
        // Esta URL se configura en OAUTH URL de la integración MercadoPago
        // redirect_uri: "https://diakron-backend.onrender.com/oauth/callback"
        redirect_uri: "https://diakron-backend.onrender.com/oauth/callback"
      })
    });

    const data = await response.json();

    if (!response.ok) {
      console.error("Error de MP:", data);
      return res.status(500).send("Error obteniendo credenciales");
    }

    //  Extraer los datos importantes
    const { access_token, refresh_token, user_id } = data;

    // Determinar dinámicamente la tabla de destino y el esquema de redirección
    // La tabla destino es el plural del user type
    const targetTable = `${userType}s`;
    const redirectDeepLink = `diakron.${userType}://mp/success-linking`;


    // TESTING
    console.log('User: ', user_id, ' ', access_token, " ", refresh_token, '\n',
      'TargetTable: ', targetTable, ' redirectDeepLink: ', redirectDeepLink
    );

    // GUARDAR EN  BASE DE DATOS    
    const { error: errorInsert } = await supabase
      .from(targetTable)
      .update([
        {
          mp_access_token: access_token,
          mp_refresh_token: refresh_token,
          mp_user_id: user_id,

        }
      ]).eq('id', userId);

    if (errorInsert) {
      console.error(errorInsert);
      throw errorInsert;
    }

    console.log(`OAuth exitoso para ${userType}. ID: ${userId}`);

    // Redirigir a la app correspondiente
    res.redirect(redirectDeepLink);

  } catch (err) {
    console.error("Error en el proceso OAuth:", err);
    res.status(500).send("Error interno");
  }
});

// Paymet from administration to stores
app.post("/admin-payout-store", async (req, res) => {
  try {
    // Recibimos el ID interno del recolector, el monto y un ID de referencia opcional
    const { storeId, amount, rep_percentage } = req.body;

    console.log(`Solicitud Pago: ${storeId}, ${amount}, ${rep_percentage}`);

    // Consigue token en BD
    const { data: dataToken, error: errorToken } =
      await supabase
        .from('stores')
        .select('mp_access_token')
        .eq('id', storeId)
        .single();

    if (errorToken || !dataToken?.mp_access_token) {
      return res.status(404).json({ error: "Tienda no encontrada o sin MercadoPago vinculado" });
    }

    const finalAccessToken = dataToken.mp_access_token;
    // INICIALIZAR EL CLIENTE CON EL TOKEN DEL RECOLECTOR
    const clientMPFinal = new MercadoPagoConfig({ accessToken: finalAccessToken });
    const preference = new Preference(clientMPFinal);

    const result = await preference.create({
      body: {
        notification_url: `https://diakron-backend.onrender.com/mp-webhook-store/${storeId}`,
        external_reference: storeId, // Para rastrear la operación
        metadata: {
          payout_type: 'STORE_INCENTIVE',
          store_id: storeId,
          original_amount: Number(amount),
          rep_percentage: rep_percentage,
        },

        items: [
          {
            title: 'Incentivo Diakron',
            quantity: 1,
            unit_price: Number(amount),
            currency_id: 'MXN'
          }
        ],
        back_urls: {
          success: "diakron.admin://mp/success",
          failure: "diakron.admin://mp/failure",
          pending: "diakron.admin://mp/pending"
        },
        // Aquí es donde Mercado Pago sabe cuánto mandarle a la cuenta Admin
        // marketplace_fee: 20,
        auto_return: "approved",

        // When payment completed, notify this URL to save delivery in DB
        // notification_url: "https://BACKEND_URL/mp-webhook"
      }
    });

    // TESTING
    console.log("Preferencia creada:\nSandbox URL: ", result.sandbox_init_point,
      "\nProduction URL: ", result.init_point
    );
    // Send response
    return res.json({
      sandboxURL: result.sandbox_init_point,
      // Sanbox gives problems and init point can be perfectly be used with test credentials
      initPoint: result.init_point
    });

  } catch (err) {
    console.error("Error en proceso de payout:", err);
    res.status(500).json({ error: err.message });
  }
});

app.post("/mp-webhook-store/:storeId", async (req, res) => {
  const { storeId } = req.params;
  const { query } = req;
  const topic = query.topic || query.type;

  try {
    if (topic === "payment") {
      const paymentId = query.id || req.body.data.id;

      // 1. Buscamos el token de la tienda en la BD usando el parámetro de la URL
      const { data: storeData, error: errorToken } = await supabase
        .from('stores')
        .select('mp_access_token')
        .eq('id', storeId)
        .single();

      if (errorToken || !storeData?.mp_access_token) {
        console.error(`[Webhook Store] No se encontró token para la tienda: ${storeId}`);
        return res.sendStatus(400);
      }

      // 2. IMPORTANTE: Inicializamos Mercado Pago con el token de la TIENDA dueño del pago
      const clientStore = new MercadoPagoConfig({ accessToken: storeData.mp_access_token });
      const payment = await new Payment(clientStore).get({ id: paymentId });

      if (payment.status === "approved") {

        const rep_percentage = payment.metadata.rep_percentage;

        // Evitar registros duplicados de incentivos
        const { data: existingRecord } = await supabase
          .from('incentives_stores')
          .select('id')
          .eq('mp_payment_id', paymentId)
          .single();

        if (existingRecord) {
          console.log(`[Webhook Store] Incentivo ${paymentId} ya procesado.`);
          return res.sendStatus(200);
        }

        console.log(`[Webhook Store] Procesando incentivo aprobado para Tienda ID: ${storeId}`);

        // Guardar el incentivo en la base de datos
        const { error: errorInsert } = await supabase
          .from('incentives_stores')
          .insert({
            id_store: storeId,
            amount: Number(payment.transaction_amount),
            mp_payment_id: paymentId,
            rep_percentage: rep_percentage
          });

        if (errorInsert) throw errorInsert;
        console.log(`[Webhook Store] Incentivo ${paymentId} registrado con éxito.`);
      }
    }

    res.sendStatus(200);
  } catch (err) {
    console.error("Error en Webhook de Tiendas:", err);
    res.sendStatus(500);
  }
});