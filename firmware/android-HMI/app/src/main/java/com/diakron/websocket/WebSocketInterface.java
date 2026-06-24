package com.diakron.websocket;

import android.graphics.Bitmap;

// This interface is needed to overwrite methos in each activity and acces UI
public interface WebSocketInterface {
    void onMessageReceived(String string);
    void onQRPayloadReceived(byte[] byteArrayPayload);
    void onFillLevelsReceived(byte[] byteArrayPayload);
    void onConnectionStatus(Boolean connected);

    void onSessionUpdate(int count, String material);
    void onQRReceived(String data);
}
