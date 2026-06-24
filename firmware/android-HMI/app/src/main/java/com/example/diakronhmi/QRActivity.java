package com.example.diakronhmi;

import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.google.zxing.BarcodeFormat;
import com.journeyapps.barcodescanner.BarcodeEncoder;

import java.util.Arrays;

import okio.ByteString;

public class QRActivity extends AppCompatActivity {
    // Creamos una instancia estática para destruir la activity desde afuera
    public static QRActivity instance = null;
    private TextView tvCounter, tvPrompt;
    private CountDownTimer countDownTimer;
    // En 60 segundos se cierra la activity
    private long timeLeftInMillis = 60000;

    private TextView tvClock;
    private android.os.Handler clockHandler = new android.os.Handler();

    // Donde se muestra código QR
    ImageView qrImg;

    // Botón volver
    View btnBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_qractivity);

        tvCounter = findViewById(R.id.tvCounter);
        tvPrompt = findViewById(R.id.tvPrompt);

        // Guardamos la referencia a esta activity
        instance = this;
        // Asigna interfaz a objetos
        qrImg = findViewById(R.id.qrImg);
        btnBack = findViewById(R.id.btnBack);

        btnBack.setOnClickListener(v -> {
            finish();
        });

        VideoView videoView = findViewById(R.id.videoQRCharacter);

        String path = "android.resource://" + getPackageName() + "/" + R.raw.video_qr;

        videoView.setVideoURI(Uri.parse(path));

        videoView.setOnPreparedListener(mp -> {

            mp.setLooping(true);

            mp.setVolume(0f, 0f);

            videoView.start();
        });

        tvClock = findViewById(R.id.tvClock);
        iniciarReloj();
    }

    private void startTimer() {
        // millisInFuture: Tiempo total
        // countDownInterval: Cada cuánto tiempo se ejecuta onTick (1000ms = 1 seg)
        countDownTimer = new CountDownTimer(timeLeftInMillis, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                timeLeftInMillis = millisUntilFinished;
                updateText();
            }

            @Override
            public void onFinish() {
                tvCounter.setText("0");
                finish(); // Mata la actividad al llegar a cero
            }
        }.start();
    }

    private void updateText() {
        int seconds = (int) (timeLeftInMillis / 1000);
        tvCounter.setText(String.valueOf(seconds));
    }

    @Override
    protected void onStart() {
        super.onStart();

        // Destroy activity after 60 secs
        startTimer();

        // Anclar la pantalla al iniciar
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            startLockTask();
        }
        // Ocultar UI
        View decor = getWindow().getDecorView();
        decor.setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                        | View.SYSTEM_UI_FLAG_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        );

        // Evitar que la pantalla se duerma
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);


        // Create QR Code
        try {
            BarcodeEncoder barcodeEncoder = new BarcodeEncoder();

            // Get byteArrayPayload by extra
            byte[] byteArrayPayload = getIntent().getByteArrayExtra("byteArrayPayload");

            // LÓGICA PARA DISTINGUIR EL TIPO DE QR
            if (byteArrayPayload != null) {
                if (byteArrayPayload.length == 78) {
                    // QR de Recolector
                    tvPrompt.setText("Escanea este código con tu app de Recolector");
                } else if (byteArrayPayload.length == 90) {
                    // QR de Participante / Ciudadano
                    tvPrompt.setText("¡Escanea el QR con la aplicación de participantes y gana puntos!");
                } else {
                    // Por si llega de otro tamaño
                    tvPrompt.setText("Error UNKNOW LENGTH");
                }
            }

            // Create string of QR payload (Base64 to achieve the smaller size possible)
            // 80 Bytes ->  107 Base64 Char
            String qrPayload = Base64.encodeToString(
                    byteArrayPayload,
                    Base64.NO_PADDING | Base64.NO_WRAP | Base64.URL_SAFE
            );

            Bitmap bitmap = barcodeEncoder.encodeBitmap(qrPayload, BarcodeFormat.QR_CODE, 1000, 1000);
            qrImg.setImageBitmap(bitmap);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Clean reference to avoid memory leaks
        instance = null;
        clockHandler.removeCallbacksAndMessages(null);
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