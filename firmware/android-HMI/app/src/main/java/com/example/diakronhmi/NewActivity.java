package com.example.diakronhmi;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.VideoView;

import androidx.appcompat.app.AppCompatActivity;
import com.diakron.websocket.MyWebSocketListener;
import com.diakron.websocket.WebSocketInterface;

import java.util.HashMap;
import java.util.Map;

public class NewActivity extends AppCompatActivity implements WebSocketInterface {
    private TextView tvTimerValue, tvContador, tvMaterialType;
    private View btnGenerateQR;
    private CountDownTimer timer;
    private VideoView videoView;
    private TextView tvClock;
    private android.os.Handler clockHandler = new android.os.Handler();

    private static final Map<String, String> MATERIAL_TRANSLATIONS = new HashMap<>();
    static {
        // Raw material keys
        MATERIAL_TRANSLATIONS.put("PAPER/CARDBOARD", "PAPEL/CARTÓN");
        MATERIAL_TRANSLATIONS.put("PLASTIC", "PLÁSTICO");
        MATERIAL_TRANSLATIONS.put("GLASS", "VIDRIO");
        MATERIAL_TRANSLATIONS.put("METAL", "METAL");
        }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_new);

        tvTimerValue = findViewById(R.id.tvTimerValue);
        tvContador = findViewById(R.id.tvContadorResiduos);
        tvMaterialType = findViewById(R.id.tvMaterialType);
        btnGenerateQR = findViewById(R.id.btnGenerateQR);


        int initialCount = getIntent().getIntExtra("INITIAL_COUNT", 0);
        tvContador.setText(String.valueOf(initialCount));

        // Setup initial material type if passed from MainActivity
        String initialMaterial = getIntent().getStringExtra("INITIAL_MATERIAL");
        if (initialMaterial != null && !initialMaterial.isEmpty()) {
            String key = initialMaterial.trim();
            // Safe replacement for getOrDefault
            String translated = MATERIAL_TRANSLATIONS.containsKey(key) ? MATERIAL_TRANSLATIONS.get(key) : initialMaterial;
            tvMaterialType.setText(translated);
        }

        MyWebSocketListener.getInstance().setActivity(this);

        reiniciarTimer();

        btnGenerateQR.setOnClickListener(v -> {
            if (timer != null) timer.cancel();
            enviarGetQR();
        });

        videoView = findViewById(R.id.imgMainIllustration);
        String path = "android.resource://" + getPackageName() + "/" + R.raw.ic_list_segregation;

        videoView.setVideoURI(Uri.parse(path));

        videoView.setOnPreparedListener(mp -> {

            mp.setLooping(true);

            mp.setVolume(0f, 0f);

            videoView.start();
        });

        tvClock = findViewById(R.id.tvClock);
        iniciarReloj();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (timer != null) {
            timer.cancel();
        }
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        clockHandler.removeCallbacksAndMessages(null);
    }

    private void reiniciarTimer() {
        if (timer != null) timer.cancel();

        timer = new CountDownTimer(60000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                tvTimerValue.setText("0m " + (millisUntilFinished / 1000) + "s");
            }

            @Override
            public void onFinish() {
                enviarGetQR();
            }
        }.start();
    }

    private void enviarGetQR() {
        MyWebSocketListener.getInstance().sendMessage("GET_QR");
    }
    @Override
    public void onSessionUpdate(int count, final String material) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // Update the counter
                if (tvContador != null) {
                    tvContador.setText(String.valueOf(count));
                }

                // Update material text and show toast if valid
                if (material != null && !material.isEmpty()) {
                    // Look up translation. If key isn't found, it defaults back to the original string safely.
                    String key = material.trim();
                    // Safe replacement for getOrDefault
                    String translatedMaterial = MATERIAL_TRANSLATIONS.containsKey(key) ? MATERIAL_TRANSLATIONS.get(key) : material;

                    if (tvMaterialType != null) {
                        tvMaterialType.setText(translatedMaterial);
                    }
                }
                // Reset the countdown timer
                reiniciarTimer();
            }
        });
    }

    @Override
    public void onQRPayloadReceived(final byte[] byteArrayPayload) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (timer != null) timer.cancel();

                Intent toQRActivity = new Intent(NewActivity.this, QRActivity.class);
                toQRActivity.putExtra("byteArrayPayload", byteArrayPayload);
                startActivity(toQRActivity);

                finish();
            }
        });
    }
    @Override
    public void onQRReceived(String data) {
        // No hace nada pero es necesario
        Log.d("WebSocket", "QR String recibido: " + data);
    }
    @Override public void onMessageReceived(String s) {}
    @Override public void onConnectionStatus(Boolean b) {}
    @Override public void onFillLevelsReceived(byte[] p) {}

    @Override
    protected void onResume() {
        super.onResume();
        MyWebSocketListener.getInstance().setActivity(this);
    }

    private void iniciarReloj() {

        clockHandler.post(new Runnable() {
            @Override
            public void run() {

                java.text.SimpleDateFormat sdf =
                        new java.text.SimpleDateFormat("hh:mm a",
                                java.util.Locale.getDefault());

                String hora = sdf.format(new java.util.Date());

                tvClock.setText(hora);

                // Actualiza cada segundo
                clockHandler.postDelayed(this, 1000);
            }
        });
    }
}