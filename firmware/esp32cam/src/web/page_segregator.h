#pragma once
#include "../main.h"

const char DEBUG_PAGE[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diakron | Terminal de Depuración</title>
    <style>
        :root {
            --bg: #121212;
            --surface: #1e1e1e;
            --primary: #00e676;
            --error: #ff5252;
            --info: #2196f3;
            --text: #e0e0e0;
        }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background-color: var(--bg); 
            color: var(--text); 
            margin: 0; 
            display: flex; 
            flex-direction: column; 
            height: 100vh;
        }
        header { 
        background: #000; padding: 1rem; border-bottom: 2px solid var(--primary); }
        h1 { margin: 0; font-size: 1.2rem; color: var(--primary); text-transform: uppercase; letter-spacing: 2px; }
        
        .container { display: grid; grid-template-columns: 350px 1fr; gap: 10px; padding: 10px; flex: 1; overflow: hidden; }
        
        /* Sección Izquierda: Cámara y Controles */
        .sidebar { display: flex; flex-direction: column; gap: 10px; }
        .card { background: var(--surface); padding: 15px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.3); }
        .viewfinder { width: 100%; border-radius: 4px; background: #000; min-height: 240px; display: block; }
        
        .controls { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 10px; }
        button { 
            padding: 10px; border: none; border-radius: 4px; cursor: pointer; 
            font-weight: bold; transition: 0.3s; background: #333; color: white;
        }
        button:hover { opacity: 0.8; transform: translateY(-1px); }
        .btn-capture { background: var(--primary); color: #000; }
        .btn-clear { background: #444; grid-column: span 2; }

        /* Sección Derecha: Terminal */
        .terminal-container { 
            display: flex; 
            flex-direction: column; 
            background: #000; 
            border-radius: 8px; 
            border: 1px solid #333;
            overflow: hidden;
        }
        .terminal-header { background: #222; padding: 5px 15px; font-size: 0.8rem; color: #888; display: flex; justify-content: space-between; }
        #terminal { 
            flex: 1; 
            padding: 15px; 
            overflow-y: auto; 
            font-family: 'Consolas', 'Monaco', monospace; 
            font-size: 13px; 
            line-height: 1.5;
            scroll-behavior: smooth;
        }
        
        /* Estilos de los Logs */
        .log { margin-bottom: 4px; border-left: 3px solid #444; padding-left: 10px; }
        .log-info { border-left-color: var(--info); }
        .log-error { border-left-color: var(--error); color: var(--error); }
        .log-state { border-left-color: var(--primary); color: var(--primary); }
        .timestamp { color: #555; font-size: 0.7rem; margin-right: 8px; }

        @media (max-width: 768px) {
            .container { grid-template-columns: 1fr; }
        }

        .terminal-input-area {
            display: flex;
            background: #111;
            padding: 10px;
            border-top: 1px solid #333;
        }
        #cmd-input {
            flex: 1;
            background: transparent;
            border: none;
            color: var(--primary);
            font-family: monospace;
            outline: none;
            font-size: 14px;
        }
        .btn-send {
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
            padding: 2px 15px;
            font-size: 0.7rem;
            margin-left: 10px;
        }

        .settings-btn{
            background:transparent;
            border:1px solid var(--primary);
            color:var(--primary);
            width:40px;
            height:40px;
            border-radius:50%;
            font-size:20px;
        }

        .settings-panel{
            position:fixed;
            top:0;
            right:-450px;
            width:400px;
            height:100%;
            background:#181818;
            border-left:2px solid var(--primary);
            transition:0.3s;
            z-index:999;
            box-shadow:-5px 0 20px rgba(0,0,0,0.5);
        }

        .settings-panel.open{
            right:0;
        }

        .settings-content{
            display:flex;
            flex-direction:column;
            height:100%;
        }

        .settings-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            padding:20px;
            border-bottom:1px solid #333;
        }

        .settings-body{
            padding:20px;
            display:flex;
            flex-direction:column;
            gap:10px;
        }

        .settings-body input{
            background:#111;
            border:1px solid #333;
            color:white;
            padding:10px;
            border-radius:6px;
        }

        .save-btn{
            background:var(--primary);
            color:black;
            font-weight:bold;
        }

        .reboot-btn{
            background:#ff5252;
        }
    </style>
</head>

<body>

<header>
    <div style="display:flex;justify-content:space-between;align-items:center;">
        <h1>
            Diakron
            <span id="status"
            style="font-size:0.6rem;color:#555;">
            • Desconectado
            </span>
        </h1>

        <button id="settingsBtn" class="settings-btn">
            ⚙
        </button>
    </div>
</header>

<div class="container">
    <div class="sidebar">
        <div class="card">
            <img id="img" class="viewfinder" alt="Esperando stream..." />
            <div class="controls">
                <button class="btn-capture" onclick="sendCommand('CAPT')">CAPTURA</button>
                <button onclick="sendCommand('FL')">NIVELES</button>
                <button class="btn-clear" onclick="clearTerminal()">LIMPIAR TERMINAL</button>
            </div>
        </div>
        <div class="card" style="font-size: 0.8rem; color: #888;">
            <strong>IP:</strong> ${location.host}<br>
            <strong>Proyecto:</strong> Diakron Segregador
        </div>
    </div>

    <div class="terminal-container">
        <div class="terminal-header">
            <span>SALIDA SERIAL REMOTA</span>
            <span id="auto-scroll-label">AUTO-SCROLL ON</span>
        </div>
        <div id="terminal"></div>
        <div class="terminal-input-area">
            <span style="color:var(--primary); margin-right:10px;">&gt;</span>
            <input type="text" id="cmd-input" placeholder="Escribir comando..." autocomplete="off">
            <button class="btn-send" onclick="sendCustomCommand()">ENVIAR</button>
        </div>
    </div>
</div>

<div id="settingsPanel" class="settings-panel">

    <div class="settings-content">

        <div class="settings-header">
            <h2>Configuración de Red</h2>

            <button onclick="closeSettings()">
                ✕
            </button>
        </div>

        <div class="settings-body">

            <label>SSID</label>
            <input id="wifi_ssid">

            <label>Password</label>
            <input id="wifi_pass" type="password">

            <label>IP</label>
            <input id="wifi_ip">

            <label>Gateway</label>
            <input id="wifi_gateway">

            <label>Subnet</label>
            <input id="wifi_subnet">

            <label>Primary DNS</label>
            <input id="wifi_dns1">

            <label>Secondary DNS</label>
            <input id="wifi_dns2">

            <button class="save-btn"
                    onclick="saveWifi()">
                Guardar Configuración
            </button>

            <button class="reboot-btn"
                    onclick="rebootESP()">
                Reiniciar ESP32
            </button>

        </div>
    </div>
</div>

<script>
    const cmdInput = document.getElementById("cmd-input");
    const terminal = document.getElementById("terminal");
    const img = document.getElementById("img");
    const statusLabel = document.getElementById("status");
    
    // Conexión WebSocket al servicio existente
    const ws = new WebSocket(`ws://${location.host}/ws`);
    ws.binaryType = "arraybuffer";

    ws.onopen = () => {
        statusLabel.innerText = "• CONECTADO";
        statusLabel.style.color = "var(--primary)";
        addLog("[SISTEMA] Conexión WebSocket establecida", "info");
    };

    ws.onclose = () => {
        statusLabel.innerText = "• DESCONECTADO";
        statusLabel.style.color = "var(--error)";
    };

    ws.onmessage = (event) => {
    if (typeof event.data === "string") {
        parseLog(event.data);
    } else {
        // Obtenemos el ArrayBuffer completo
        const arrayBuffer = event.data;
        
        // Creamos una vista de bytes para verificar los primeros dos (I y M)
        const bytes = new Uint8Array(arrayBuffer);
        
        // Verificamos si empieza con 'IM' (opcional, por seguridad)
        if (bytes[0] === 73 && bytes[1] === 77) { 
            // Creamos un nuevo buffer que empieza desde el byte 2 hasta el final
            const imageBlob = new Blob([arrayBuffer.slice(2)], {type: 'image/jpeg'});
            
            // Creamos la URL para la imagen
            const imageUrl = URL.createObjectURL(imageBlob);
            
            // Liberamos la memoria de la URL anterior para evitar fugas de memoria
            if (img.src) URL.revokeObjectURL(img.src);
            
            img.src = imageUrl;
        } else {
            // Si no tiene el encabezado, lo tratamos como imagen directa
            const blob = new Blob([event.data], {type: 'image/jpeg'});
            img.src = URL.createObjectURL(blob);
        }
    }
};

    cmdInput.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
            sendCustomCommand();
        }
    });

    function sendCustomCommand() {
        const cmd = cmdInput.value.trim();
        if (cmd === "") return;
        
        ws.send(cmd); // Esto llega a wsService en el ESP32
        addLog(`Comando enviado: ${cmd}`, "state");
        cmdInput.value = "";
    }

    function parseLog(msg) {
        let type = "default";
        if(msg.includes("[INFO]")) type = "info";
        if(msg.includes("[ERROR]")) type = "error";
        if(msg.includes("[STATE]")) type = "state";
        addLog(msg, type);
    }

    function addLog(msg, type) {
        const div = document.createElement("div");
        const now = new Date();
        const timeStr = now.getHours().toString().padStart(2, '0') + ":" + 
                        now.getMinutes().toString().padStart(2, '0') + ":" + 
                        now.getSeconds().toString().padStart(2, '0');
        
        div.className = `log log-${type}`;
        div.innerHTML = `<span class="timestamp">${timeStr}</span>${msg}`;
        terminal.appendChild(div);
        
        // Auto-scroll
        terminal.scrollTop = terminal.scrollHeight;
    }

    function sendCommand(cmd) {
        ws.send(cmd);
        addLog(`Enviando comando: ${cmd}`, "state");
    }

    function clearTerminal() {
        terminal.innerHTML = "";
    }


    const settingsPanel =
    document.getElementById("settingsPanel");

    document
    .getElementById("settingsBtn")
    .onclick = () =>
    {
        settingsPanel.classList.add("open");

        loadWifiConfig();
    };

    function closeSettings()
    {
        settingsPanel.classList.remove("open");
    }

    async function loadWifiConfig()
    {
        const res = await fetch("/wifi/config");

        const cfg = await res.json();

        document.getElementById("wifi_ssid").value =
            cfg.ssid;

        document.getElementById("wifi_pass").value =
            cfg.password;

        document.getElementById("wifi_ip").value =
            cfg.ip;

        document.getElementById("wifi_gateway").value =
            cfg.gateway;

        document.getElementById("wifi_subnet").value =
            cfg.subnet;

        document.getElementById("wifi_dns1").value =
            cfg.dns1;

        document.getElementById("wifi_dns2").value =
            cfg.dns2;
    }

    async function saveWifi()
    {
        const data = {
            ssid:
                document.getElementById("wifi_ssid").value,

            password:
                document.getElementById("wifi_pass").value,

            ip:
                document.getElementById("wifi_ip").value,

            gateway:
                document.getElementById("wifi_gateway").value,

            subnet:
                document.getElementById("wifi_subnet").value,

            dns1:
                document.getElementById("wifi_dns1").value,

            dns2:
                document.getElementById("wifi_dns2").value
        };

        await fetch("/wifi/save", {
            method:"POST",
            headers:{
                "Content-Type":"application/json"
            },
            body:JSON.stringify(data)
        });

        alert("Configuración guardada");
    }

    async function rebootESP()
    {
        await fetch("/reboot");

        alert("Reiniciando ESP32...");
    }
</script>



</body>
</html>
)rawliteral";