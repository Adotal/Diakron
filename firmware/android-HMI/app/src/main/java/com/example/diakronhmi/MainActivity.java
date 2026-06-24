package com.example.diakronhmi;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.drawable.DrawableCompat;

import com.airbnb.lottie.LottieAnimationView;
import com.airbnb.lottie.RenderMode;
import com.diakron.ui.CircularFillView;
import com.diakron.websocket.MyWebSocketListener;
import com.diakron.websocket.WebSocketInterface;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class MainActivity extends AppCompatActivity implements WebSocketInterface {

    private CircularFillView metalCircle, plasticCircle, paperCircle, glassCircle;
    private TextView metalText, plasticText, paperText, glassText;
    private ImageView metalImg, plasticImg, paperImg, glassImg;

    private View btnPhoto, btnCollector;
    private TextView tvHeaderTitle;

    // Variables para el Header Dinámico
    private TextView txtTime, txtStatus;
    private View indicatorStatus;
    private Handler timeHandler = new Handler(Looper.getMainLooper());

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);

        // 1. MAPEO DEL HEADER DINÁMICO
        txtTime = findViewById(R.id.txtTime);
        txtStatus = findViewById(R.id.txtStatus);
        indicatorStatus = findViewById(R.id.indicatorStatus);

        LinearLayout header = findViewById(R.id.headerContainer);
        if (header != null) {
            for (int i = 0; i < header.getChildCount(); i++) {
                View child = header.getChildAt(i);
                if (child instanceof TextView && ((TextView) child).getText().toString().contains("Segregador")) {
                    tvHeaderTitle = (TextView) child;
                    break;
                }
            }
        }

        // 2. MAPEO Y CONFIGURACIÓN ESTÉTICA POR MATERIAL (Android 5+ Retrocompatible)
        // Pasamos el prefijo (ej: "metal_") y la función se encarga de buscar el icono base y la decoración automáticamente.

        // --- A. METAL ---
        View metalView = findViewById(R.id.ind_organicos);
        metalCircle = metalView.findViewById(R.id.circleView);
        metalText = metalView.findViewById(R.id.txtPercent);
        metalImg = metalView.findViewById(R.id.imgIcon);
        configurarTarjetaMaterial(metalView, "Metal", "metal_", Color.parseColor("#455A64"), Color.parseColor("#37474F"), metalCircle);

        // --- B. PLÁSTICO ---
        View plasticView = findViewById(R.id.ind_plasticos);
        plasticCircle = plasticView.findViewById(R.id.circleView);
        plasticText = plasticView.findViewById(R.id.txtPercent);
        plasticImg = plasticView.findViewById(R.id.imgIcon);
        configurarTarjetaMaterial(plasticView, "Plástico", "plastic_", Color.parseColor("#1976D2"), Color.parseColor("#0D47A1"), plasticCircle);

        // --- C. PAPEL ---
        View paperView = findViewById(R.id.ind_papel);
        paperCircle = paperView.findViewById(R.id.circleView);
        paperText = paperView.findViewById(R.id.txtPercent);
        paperImg = paperView.findViewById(R.id.imgIcon);
        configurarTarjetaMaterial(paperView, "Papel", "paper_", Color.parseColor("#F57C00"), Color.parseColor("#E65100"), paperCircle);

        // --- D. VIDRIO ---
        View glassView = findViewById(R.id.ind_vidrio);
        glassCircle = glassView.findViewById(R.id.circleView);
        glassText = glassView.findViewById(R.id.txtPercent);
        glassImg = glassView.findViewById(R.id.imgIcon);
        configurarTarjetaMaterial(glassView, "Vidrio", "glass_", Color.parseColor("#00897B"), Color.parseColor("#004D40"), glassCircle);


        // 3. EVENTOS Y WEBSOCKET
        if (tvHeaderTitle != null) {
            tvHeaderTitle.setOnLongClickListener(v -> {
                stopLockTask();
                //Toast.makeText(this, "Modo quiosco desactivado", Toast.LENGTH_SHORT).show();
                return true;
            });
        }

        MyWebSocketListener.getInstance().setActivity(this);
        MyWebSocketListener.getInstance().connect();

        btnPhoto = findViewById(R.id.btnManualPhoto);
        btnCollector = findViewById(R.id.btnCollector);

        btnPhoto.setOnClickListener(v -> {
            MyWebSocketListener.getInstance().sendMessage("CAPT");
            Toast.makeText(this, "Proceso Manual...", Toast.LENGTH_SHORT).show();
        });

        btnCollector.setOnClickListener(v -> {
            MyWebSocketListener.getInstance().sendMessage("COL");
            Toast.makeText(this, "Autenticando Recolector...", Toast.LENGTH_SHORT).show();
        });

        VideoView videoView = findViewById(R.id.videoCharacter);

        String path = "android.resource://" + getPackageName() + "/" + R.raw.recycle_character;

        videoView.setVideoURI(Uri.parse(path));

        videoView.setOnPreparedListener(mp -> {

            mp.setLooping(true);

            mp.setVolume(0f, 0f);

            videoView.start();
        });

        // Iniciar reloj asíncrono
        iniciarReloj();
    }

    // =================================================================
    // MÉTODOS DE SOPORTE PARA ANDROID 5 / RELOJ / PROGRESO
    // =================================================================

    private void configurarTarjetaMaterial(View materialView, String nombre, String prefijoMaterial, int colorPill, int colorTexto, CircularFillView circle) {
        if (materialView == null) return;

        // 1. Nombre del material
        TextView tvName = materialView.findViewById(R.id.txtMaterialName);
        if (tvName != null) tvName.setText(nombre);

        // 2. Color del texto del porcentaje
        TextView tvPercent = materialView.findViewById(R.id.txtPercent);
        if (tvPercent != null) tvPercent.setTextColor(colorTexto);

        // 3. Color de la Píldora Superior
        View labelContainer = materialView.findViewById(R.id.labelContainer);
        if (labelContainer != null && labelContainer.getBackground() != null) {
            Drawable fondoUnico = labelContainer.getBackground().mutate();
            DrawableCompat.setTint(DrawableCompat.wrap(fondoUnico), colorPill);
            labelContainer.setBackground(fondoUnico);
        }

        // 4. Color e Icono del Centro de la Vista Circular (Carga Dinámica)
        ImageView imgIcon = materialView.findViewById(R.id.imgIcon);
        if (imgIcon != null) {
            // Nota: Aquí asumí temporalmente tus nombres de iconos anteriores "ic_metal_can", etc.
            // Si tus iconos centrales cambian a "metal_icon", puedes cambiar la terminación aquí abajo:
            String nombreIcono = "ic_" + prefijoMaterial.replace("_", "") + (prefijoMaterial.equals("metal_") ? "_can" : prefijoMaterial.equals("plastic_") ? "_bottle" : prefijoMaterial.equals("paper_") ? "_sheet" : "_cup");

            int resIconId = getResources().getIdentifier(nombreIcono, "drawable", getPackageName());
            if (resIconId != 0) {
                try { imgIcon.setImageDrawable(getResources().getDrawable(resIconId)); } catch (Exception e) {}
            }
            imgIcon.setColorFilter(colorPill, PorterDuff.Mode.SRC_IN);
        }

        // 5. NUEVO: CAMBIO DINÁMICO DE LA IMAGEN DE DECORACIÓN (Onda de fondo)
        ImageView imgDecoration = materialView.findViewById(R.id.imgDecoration);
        if (imgDecoration != null) {
            // Concatena el prefijo recibido (ej: "metal_") con "decoration" -> "metal_decoration"
            String nombreDecoration = prefijoMaterial + "decoration";

            int resDecoId = getResources().getIdentifier(nombreDecoration, "drawable", getPackageName());
            if (resDecoId != 0) {
                try {
                    imgDecoration.setImageDrawable(getResources().getDrawable(resDecoId));
                } catch (Exception e) {
                    Log.e("UI_ERROR", "Error al cargar decoración: " + nombreDecoration);
                }
            } else {
                Log.e("UI_ERROR", "No se encontró el drawable: " + nombreDecoration);
            }
        }

        // 6. Asignar color al medidor dinámico hecho en Canvas
        if (circle != null) {
            circle.setFillColor(colorPill);
        }
    }

    private void iniciarReloj() {
        timeHandler.post(new Runnable() {
            @Override
            public void run() {
                if (txtTime != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a", Locale.getDefault());
                    txtTime.setText(sdf.format(new Date()));
                }
                timeHandler.postDelayed(this, 60000);
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        timeHandler.removeCallbacksAndMessages(null);
    }

    @Override
    protected void onStart() {
        super.onStart();
        View decor = getWindow().getDecorView();
        decor.setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                        | View.SYSTEM_UI_FLAG_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        );
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    @Override
    protected void onResume() {
        super.onResume();
        MyWebSocketListener.getInstance().setActivity(this);
        MyWebSocketListener.getInstance().sendMessage("FL");
        boolean estadoActual = MyWebSocketListener.getInstance().isConnected();
        onConnectionStatus(estadoActual);
    }

    // =================================================================
    // INTERFAZ WEBSOCKET
    // =================================================================

    @Override
    public void onConnectionStatus(Boolean connected) {
        runOnUiThread(() -> {
            if (txtStatus != null && indicatorStatus != null) {
                if (connected) {
                    txtStatus.setText("En línea");
                    txtStatus.setTextColor(Color.parseColor("#4CAF50"));
                    if (indicatorStatus.getBackground() != null) {
                        Drawable bgUnico = indicatorStatus.getBackground().mutate();
                        DrawableCompat.setTint(DrawableCompat.wrap(bgUnico), Color.parseColor("#39B54A"));
                        indicatorStatus.setBackground(bgUnico);
                    }
                } else {
                    txtStatus.setText("Desconectado");
                    txtStatus.setTextColor(Color.parseColor("#F44336"));
                    if (indicatorStatus.getBackground() != null) {
                        Drawable bgUnico = indicatorStatus.getBackground().mutate();
                        DrawableCompat.setTint(DrawableCompat.wrap(bgUnico), Color.parseColor("#F44336"));
                        indicatorStatus.setBackground(bgUnico);
                    }
                }
            }
        });
    }

    @Override
    public void onMessageReceived(String string) {
        runOnUiThread((() -> {
            if (string.equals("QR_SUCCESS") || (string.startsWith("COL:") && string.length() == 8)) {

                // Cierra QRActivity si está abierta
                if (QRActivity.instance != null) {
                    QRActivity.instance.finish();
                }

                if (string.startsWith("COL:")) {

                    Intent toCollectionActivity =
                            new Intent(this, CollectionActivity.class);

                    toCollectionActivity.putExtra(
                            "byteArrayPayload",
                            string.substring(4, 8)
                    );

                    startActivity(toCollectionActivity);

                    // OPCIONAL:
                    // cerrar MainActivity para que no vuelva al inicio
                    finish();
                }
            }
            //Toast.makeText(this, string, Toast.LENGTH_SHORT).show();
        }));
    }

    @Override
    public void onQRPayloadReceived(byte[] byteArrayPayload) {
        runOnUiThread((() -> {
            Intent toQRActivity = new Intent(this, QRActivity.class);
            toQRActivity.putExtra("byteArrayPayload", byteArrayPayload);
            startActivity(toQRActivity);
        }));
    }

    @Override
    public void onFillLevelsReceived(byte[] byteArrayPayload) {
        runOnUiThread((() -> {
            int[] fillLevels = new int[4];
            for (int i = 0; i < 4; ++i) {
                fillLevels[i] = byteArrayPayload[i + 2] & 0xFF;
            }

            if (metalCircle != null) metalCircle.setProgress(fillLevels[0]);
            if (metalText != null) metalText.setText(fillLevels[0] + " %");

            if (plasticCircle != null) plasticCircle.setProgress(fillLevels[1]);
            if (plasticText != null) plasticText.setText(fillLevels[1] + " %");

            if (paperCircle != null) paperCircle.setProgress(fillLevels[2]);
            if (paperText != null) paperText.setText(fillLevels[2] + " %");

            if (glassCircle != null) glassCircle.setProgress(fillLevels[3]);
            if (glassText != null) glassText.setText(fillLevels[3] + " %");
        }));
    }

    @Override
    public void onSessionUpdate(int count, String material) {
        runOnUiThread(() -> {
            Intent intent = new Intent(MainActivity.this, NewActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            intent.putExtra("INITIAL_COUNT", count);
            intent.putExtra("INITIAL_MATERIAL", material); // Pass the material type
            startActivity(intent);
        });
    }

    @Override
    public void onQRReceived(String data) {}
}