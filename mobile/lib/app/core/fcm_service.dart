import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../data/api_client.dart';
import '../routes/app_pages.dart';

class FcmService {
  static final FcmService _instance = FcmService._();
  factory FcmService() => _instance;
  FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Current FCM token
  String? _token;
  String? get token => _token;

  /// Initialize FCM: permissions, token, handlers
  Future<void> init() async {
    // Request notification permissions (Android 13+)
    final notifSettings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (notifSettings.authorizationStatus == AuthorizationStatus.denied) {
      // Permission denied — won't receive push
      return;
    }

    // Init local notifications for foreground display
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Get FCM token
    _token = await _messaging.getToken();

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      _registerToken(newToken);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background tap (app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage.data);
    }

    // Background tap (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageTap(message.data);
    });
  }

  /// Register FCM token with server
  Future<void> _registerToken(String token) async {
    final accessToken = ApiClient.getAccessToken();
    if (accessToken == null) return; // Not logged in

    final client = ApiClient();
    await client.post(
      '/notifications/register-device',
      body: {'fcm_token': token, 'platform': 'android'},
      authenticated: true,
    );
  }

  /// Show local notification for foreground messages
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'] ?? 'Notifikasi';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    const androidDetails = AndroidNotificationDetails(
      'smart_caregiver_channel',
      'Smart Caregiver',
      channelDescription: 'Notifikasi Smart Caregiver',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: message.data['notification_id'],
    );
  }

  /// Handle local notification tap
  void _onLocalNotificationTap(NotificationResponse response) {
    final notificationId = response.payload;
    if (notificationId != null) {
      Get.toNamed(Routes.NOTIFIKASI);
    }
  }

  /// Handle push notification tap — navigate to screen
  void _handleMessageTap(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final elderlyId = data['elderly_id'];

    switch (type) {
      case 'critical_alert':
      case 'health_recorded':
        if (elderlyId != null) {
          Get.toNamed(Routes.DASHBOARD, arguments: {
            'elderly_id': elderlyId,
          });
        }
        break;
      case 'alarm_reminder':
        Get.toNamed(Routes.CALENDAR);
        break;
      case 'weekly_summary':
      case 'activity_recommendation':
      default:
        Get.toNamed(Routes.NOTIFIKASI);
        break;
    }
  }
}