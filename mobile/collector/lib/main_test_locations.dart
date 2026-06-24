import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For defaultTargetPlatform
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 1. TOP-LEVEL function to handle Firebase messages when app is closed/minimized
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📬 Background Notification Received: ${message.messageId}");
}

// 2. Local Notifications channel setup (Required for Android Foreground)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // name
  description: 'This channel is used for important alerts.', // description
  importance: Importance.max,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Manejar cuando el usuario toca la notificación estando la app en segundo plano
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['action'] == 'OPEN_MAP') {
      // Navegar a tu pantalla de mapa
      // router.go('/map');
    }
  });

  // Create the notification channel (Android)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // Required to show heads-up notifications while app is open (iOS)
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diakron Background Test',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const BackgroundTrackerScreen(),
    );
  }
}

class BackgroundTrackerScreen extends StatefulWidget {
  const BackgroundTrackerScreen({super.key});

  @override
  State<BackgroundTrackerScreen> createState() =>
      _BackgroundTrackerScreenState();
}

class _BackgroundTrackerScreenState extends State<BackgroundTrackerScreen> {
  String _status = 'Initializing...';
  String? _fcmToken;
  final String testUserId = 'a5b6533e-4ff4-494b-83b3-2ff94830c199';

  @override
  void initState() {
    super.initState();
    _setupNotifications();
    _initLocationTracking();
  }

  Future<void> _setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    _fcmToken = await messaging.getToken();
    print("🔑 FCM TOKEN: $_fcmToken");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          id: 1,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
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
  }

  Future<void> _initLocationTracking() async {
    // 1. Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _status = 'Please enable GPS');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Request BACKGROUND location permission specifically
    if (permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
    }

    setState(() => _status = 'Tracking Active (Background Enabled)');

    // 2. Configure Background Service settings based on OS
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        // THIS is what keeps the app alive in the background:
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Monitoreando segregadores cercanos...",
          notificationTitle: "Diakron Recolector Activo",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 10,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator:
            true, // The blue pill on iOS status bar
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    // 3. Start listening to the stream
    Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      Position position,
    ) {
      print("📍 Location Update: ${position.latitude}, ${position.longitude}");
      if (_fcmToken != null) {
        _sendLocation(position.latitude, position.longitude);
      }
    });
  }

  Future<void> _sendLocation(double lat, double lon) async {
    final url = Uri.parse('https://diakron-backend.onrender.com/update-location');
    // TESTING
    // final url = Uri.parse('http://192.168.100.135:3000/update-location');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': testUserId,
          'lat': lat,
          'lon': lon,
          'fcmToken': _fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(
            () => _status =
                'Last Sync: ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
          );
        }
      }
    } catch (e) {
      print('Network Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.satellite_alt, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'You can now minimize the app or lock the screen. The persistent notification will keep GPS alive.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
