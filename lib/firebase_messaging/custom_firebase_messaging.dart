import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_push_notification_remote_config/firebase_messaging/custom_local_notification.dart';
import 'package:flutter_push_notification_remote_config/main.dart';

class CustomFirebaseMessaging {
  final CustomLocalNotification _customLocalNotification;

  CustomFirebaseMessaging._internal(this._customLocalNotification);
  static final CustomFirebaseMessaging _singleton =
      CustomFirebaseMessaging._internal(CustomLocalNotification());
  factory CustomFirebaseMessaging() => _singleton;

  Future<void> inicialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _customLocalNotification.androidNotification(notification, android);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['goTO'] != null) {
        navigatorKey.currentState?.pushNamed(message.data['goTO']);
      }
    });
  }

  getTokenFirebase() async =>
      debugPrint(await FirebaseMessaging.instance.getToken());
}
