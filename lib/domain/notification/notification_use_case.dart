import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:offline_ticket_booking/core/use_case/use_case.dart';

class ShowNotificationUseCase
    extends UseCase<void, ShowNotificationUseCaseParams> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ShowNotificationUseCase({required this.flutterLocalNotificationsPlugin});

  @override
  Future<void> execute(ShowNotificationUseCaseParams params) async {
    try {
      // Ask for permission
      final bool? result =
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission();

      if (result == null || !result) {
        if (kDebugMode) {
          print("Permission denied!");
        }
        return;
      }

      // If permission granted, show notification
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'default_channel_id',
            'Default Channel',
            channelDescription: 'This is the default channel',
            importance: Importance.max,
            priority: Priority.high,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        params.title,
        params.body,
        notificationDetails,
      );

      print("Notification shown!");
    } catch (e) {
      print("Error: $e");
    }
  }
}

class ShowNotificationUseCaseParams {
  final String title;
  final String body;

  ShowNotificationUseCaseParams({required this.title, required this.body});
}
