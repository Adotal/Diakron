import 'dart:convert';

import 'package:diakron_collectors/routing/router.dart';
import 'package:diakron_collectors/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

// 1. TOP-LEVEL function (Debe estar fuera de cualquier clase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📬 Background Notification Received: ${message.messageId}");
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important alerts.', // description
    importance: Importance.max,
  );

  static Future<void> initialize() async {
    // Registrar el handler de background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Crear el canal de notificaciones (Android)
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Configurar notificaciones en Foreground (iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Pedir permisos al usuario
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    // Escuchar notificaciones en Foreground (App Abierta)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          id: 1,
          title: notification.title,
          body: notification.body,
          payload: jsonEncode(message.data),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: '@mipmap/ic_launcher',
              priority: Priority.max,
              importance: Importance.max,
              // PARA TEXTOS MULTILÍNEA
              styleInformation: BigTextStyleInformation(
                notification.body ?? '',
                htmlFormatBigText: true,
                contentTitle: notification.title,
                htmlFormatContentTitle: true,
              ),
            ),
          ),
        );
      }
    });

    // Manejar tap en notificación (Background -> Foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });
  }

  // Extraemos la lógica a un método para reutilizarla
  static void _handleNotificationTap(RemoteMessage message) {
    if (message.data['action'] == 'OPEN_SEGREGATOR_DETAILS' ||
        message.data['action'] == 'OPEN_MAP') {
      // NAVEGAR USANDO LA LLAVE GLOBAL
      final context = rootNavigatorKey.currentContext;

      if (context != null) {
        context.go(Routes.map);
      } 
    }
  }

  // Método para obtener el token que le enviaremos a Node.js
  static Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
