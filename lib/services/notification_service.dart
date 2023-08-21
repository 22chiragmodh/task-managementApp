import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'flutter_logo'); // Replace 'app_icon' with your app's icon name

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  scheduleNotification(int hour, int minute, String scheduledate, String title,
      int id, String Description) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        Description,
        convertTime(scheduledate, hour, minute),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                "your channel id", "your channel name")),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime convertTime(String scheduledate, int hour, int minute) {
    final List<String> dateParts = scheduledate.split('/');
    final int year = int.parse(dateParts[2]);
    final int month = int.parse(dateParts[0]);
    final int day = int.parse(dateParts[1]);

    final tz.TZDateTime scheduledDateTime =
        tz.TZDateTime(tz.local, year, month, day, hour, minute);

    return scheduledDateTime;
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}
