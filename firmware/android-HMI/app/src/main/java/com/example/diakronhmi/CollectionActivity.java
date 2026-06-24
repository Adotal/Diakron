package com.example.diakronhmi;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Base64;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.VideoView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;

import com.diakron.websocket.MyWebSocketListener;
import com.google.zxing.BarcodeFormat;
import com.journeyapps.barcodescanner.BarcodeEncoder;

public class CollectionActivity extends AppCompatActivity {

    private TextView tvMaterials;
    private View btnFinalize;
    private VideoView videoView;
    private CountDownTimer countDownTimer;
    // En 10 minutos se cierra la activity
    private long timeLeftInMillis = 600000;

    private TextView tvClock;
    private android.os.Handler clockHandler = new android.os.Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_collection_activity);


        tvMaterials = findViewById(R.id.tvMaterials);
        btnFinalize = findViewById(R.id.btnFinalize);


        // Recuperar el String de 4 caracteres con
        /*
          Añadir tipos de materiales al payload
          Operadores bit a bit (Bitwise OR)
          0001  - Metal
          0010  - Plastic
          0100  - Paper/Cardboard
          1000  - Glass
        */
        String materialsFlags = getIntent().getStringExtra("byteArrayPayload");

        // Evaluar los caracteres y armar el texto
        if (materialsFlags != null && materialsFlags.length() == 4) {

            // Los índices ahora van del 0 al 3 porque cortaste el "COL:"
            boolean collectMetal = (materialsFlags.charAt(0) == '1');
            boolean collectPlastic = (materialsFlags.charAt(1) == '1');
            boolean collectCardboard = (materialsFlags.charAt(2) == '1');
            boolean collectGlass = (materialsFlags.charAt(3) == '1');

            // Usamos StringBuilder para ir sumando los textos dinámicamente
            StringBuilder materialsText = new StringBuilder();
            if (collectMetal) materialsText.append("• Metal ");
            if (collectPlastic) materialsText.append("• Plástico ");
            if (collectCardboard) materialsText.append("• Cartón / Papel ");
            if (collectGlass) materialsText.append("• Vidrio ");

            // Mostrarlo en el TextView
            tvMaterials.setText(materialsText.toString());
        } else {
            tvMaterials.setText("Error al leer los materiales.");
        }

        // 3. Botón para finalizar la recolección
        btnFinalize.setOnClickListener(v -> {

            // Cerrar compuertas
            MyWebSocketListener.getInstance().sendMessage("LOCK");

            // Regresar a pantalla principal
            Intent intent = new Intent(CollectionActivity.this, MainActivity.class);

            // Limpia activities anteriores
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
                    Intent.FLAG_ACTIVITY_NEW_TASK);

            startActivity(intent);

            finish();
        });

        videoView = findViewById(R.id.imgHeader);
        String path = "android.resource://" + getPackageName() + "/" + R.raw.clean_container;

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
    }

    private void startTimer() {
        // millisInFuture: Tiempo total
        // countDownInterval: Cada cuánto tiempo se ejecuta onTick (1000ms = 1 seg)
        countDownTimer = new CountDownTimer(timeLeftInMillis, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                timeLeftInMillis = millisUntilFinished;
            }

            @Override
            public void onFinish() {
                MyWebSocketListener.getInstance().sendMessage("LOCK");

                Intent intent = new Intent(CollectionActivity.this, MainActivity.class);

                intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
                        Intent.FLAG_ACTIVITY_NEW_TASK);

                startActivity(intent);

                finish();
            }
        }.start();
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
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