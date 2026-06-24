package com.diakron.websocket;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import okio.ByteString;

/*
    We are making separate webSocketListener.
    A singleton instance of webSocketListener is made
    so that we can do stuffs with single socket from anywhere in the project
 */
public class MyWebSocketListener extends WebSocketListener {

    // Singleton
    private static MyWebSocketListener instance;

    private WebSocket webSocket;
    private OkHttpClient okHttpClient;

    // To link activity to Singleton
    private WebSocketInterface activity;

    //    private final String ESP32_URL = "ws://192.168.12.128:80/ws";
    // TESING HOTSPOT
    private final String ESP32_URL = "ws://192.168.100.100:80/ws";

    // Constructor
    private MyWebSocketListener(){
        okHttpClient = new OkHttpClient();
    }

    // Get Singleton
    public static synchronized MyWebSocketListener getInstance() {

        if(instance == null)
            instance = new MyWebSocketListener();

         return instance;
    }

    // Subscribe Activity to Singleton
    public void setActivity(WebSocketInterface activity){
        this.activity = activity;
    }

    public void connect(){

        // Is already connected or trying to
        if(webSocket != null)
            return;


        Request request = new Request.Builder().url(ESP32_URL).build();

        webSocket = okHttpClient.newWebSocket(request, new WebSocketListener() {

            @Override
            public void onClosed(@NonNull WebSocket webSocket, int code, @NonNull String reason) {
                // Is not aimed to close the conections, but if, free space
                MyWebSocketListener.this.webSocket = null;
                if (activity != null)
                    activity.onConnectionStatus(false);

            }

            @Override
            public void onClosing(@NonNull WebSocket webSocket, int code, @NonNull String reason) {
                webSocket.close(1000, null);
                if(activity != null) {
                    activity.onMessageReceived("Closing connection");
                }
            }

            @Override
            public void onFailure(@NonNull WebSocket webSocket, @NonNull Throwable t, @Nullable Response response) {

                // Print error
                if(activity != null) {
                    activity.onMessageReceived("Error" + t.getMessage());
                    activity.onConnectionStatus(false);
                }
                Log.e("WebSocket", "Error", t);

                // Try to reconnect
                try {
                    // First close connection
                    if(activity != null)
                        activity.onMessageReceived("Trying to reconnect");
                    webSocket.close(1000, null);
                    MyWebSocketListener.this.webSocket = null;
                    // Wait 2 secs until trying to reconnect
                    Thread.sleep(2000);
                    connect();

                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }

            }

            @Override
            public void onMessage(@NonNull WebSocket webSocket, @NonNull String text) {
                if (activity != null) {
                    activity.onMessageReceived(text); // Mantienes lo que ya tenías

                    try {
                        // Intentamos ver si es el JSON de sesión
                        org.json.JSONObject json = new org.json.JSONObject(text);
                        String type = json.optString("type");

                        if ("SESSION_UPDATE".equals(type)) {
                            int count = json.getInt("count");// Extract the material string (defaults to empty string if missing)
                            String material = json.optString("material", "");
                            // Pass both to the active activity
                            activity.onSessionUpdate(count, material);
                        } else if ("QR_RECEIVED".equals(type)) {
                            String data = json.optString("data");
                            activity.onQRReceived(data); // Avisamos a la Activity
                        }
                    } catch (org.json.JSONException e) {
                    }
                }
            }
            @Override
            public void onMessage(@NonNull WebSocket webSocket,
                                  @NonNull ByteString bytes)
            {
                if(activity == null)
                    return;

                byte[] payload = bytes.toByteArray();

                if(payload.length < 2)
                    return;

                // =========================
                // FILL LEVELS
                // =========================

                if(payload[0] == 'F' && payload[1] == 'L')
                {
                    activity.onFillLevelsReceived(payload);
                }

                // =========================
                // QR PAYLOAD
                // =========================

                else if(payload[0] == 'Q' && payload[1] == 'R')
                {
                    byte[] qrData =
                            java.util.Arrays.copyOfRange(
                                    payload,
                                    2,
                                    payload.length);

                    activity.onQRPayloadReceived(qrData);
                }

                // =========================
                // IMAGE JPEG
                // =========================

                else if(payload[0] == 'I' && payload[1] == 'M')
                {
                    Log.d("WS", "JPEG IMAGE RECEIVED");
                }
            }

            @Override
            public void onOpen(@NonNull WebSocket webSocket, @NonNull Response response) {

                if (activity != null) {
                    activity.onMessageReceived("Connected to ESP32");
                    activity.onConnectionStatus(true);
                }
            }
        });

        // Available to reconnect after manual closing:
//        okHttpClient.dispatcher().executorService().shutdown();
    }

    public void sendMessage(String message) {
        if(webSocket != null){
            webSocket.send(message);
        }
    }

    public void disconnect() {
        if (webSocket != null) {
            // 1000 es el código estándar para "Normal Closure"
            webSocket.close(1000, "App closing or manual disconnect");

            // Es vital ponerlo en null para que el método connect()
            // no crea que sigue conectado la próxima vez
            webSocket = null;

            Log.d("WebSocket", "Disconnected manually");
        }
    }

    public boolean isConnected() {
        return webSocket != null;
    }


}
