import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsDarwin,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> requestPermissions() async {
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    await _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> scheduleTaskReminder({
    required String taskId, required String taskTitle, required String courseName, required DateTime reminderTime,
  }) async {
    if (reminderTime.isAfter(DateTime.now())) {
      final tzScheduledDate = tz.TZDateTime.from(reminderTime, tz.local);
      await _notificationsPlugin.zonedSchedule(
        taskId.hashCode, '⏰ Pengingat Tugas!', 'Tugas "$taskTitle" ($courseName) segera dikumpulkan!',
        tzScheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('task_reminder_channel', 'Task Reminders',
            channelDescription: 'Notifikasi pengingat deadline tugas kuliah',
            importance: Importance.high, priority: Priority.high, enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  static Future<void> cancelTaskReminders(String taskId) async {
    await _notificationsPlugin.cancel(taskId.hashCode);
  }
}