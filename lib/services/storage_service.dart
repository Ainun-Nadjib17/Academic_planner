import 'package:hive_flutter/hive_flutter.dart';
import '../models/course.dart';
import '../models/task.dart';
import 'notification_service.dart';

/// Penyimpanan lokal di perangkat menggunakan Hive (file database lokal,
/// bukan SharedPreferences).
///
/// API publik sengaja dipertahankan: `courses`, `tasks`, `loadData`,
/// `addCourse`, `deleteCourse`, `addTask`, `deleteTask`, dan `toggleTask`,
/// sehingga seluruh layar tetap bekerja tanpa perubahan.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _boxName = 'academic_planner_db';
  static const String _coursesKey = 'courses';
  static const String _tasksKey = 'tasks';

  List<Course> courses = [];
  List<Task> tasks = [];

  Box<dynamic>? _box;
  Future<Box<dynamic>>? _opening;

  /// Membuka box Hive sekali saja, lalu memakai instance yang sama.
  Future<Box<dynamic>> _openBox() {
    final box = _box;
    if (box != null) {
      if (box.isOpen) return Future<Box<dynamic>>.value(box);
      _box = null;
      _opening = null;
    }
    return _opening ??= _openBoxOnce();
  }

  Future<Box<dynamic>> _openBoxOnce() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(_boxName);
    _box = box;
    return box;
  }

  Future<void> loadData() async {
    final box = await _openBox();

    courses = _decode(box.get(_coursesKey), Course.fromJson);
    tasks = _decode(box.get(_tasksKey), Task.fromJson);

    // Jadwalkan ulang notifikasi untuk tugas yang belum selesai saat app dibuka
    for (var task in tasks) {
      if (!task.isCompleted) {
        final reminderTime =
            task.deadline.subtract(Duration(hours: task.reminderHoursBefore));
        NotificationService.scheduleTaskReminder(
          taskId: task.id,
          taskTitle: task.title,
          courseName: task.courseName,
          reminderTime: reminderTime,
        );
      }
    }
  }

  /// Mengubah data mentah dari Hive menjadi model. Record yang rusak dilewati
  /// satu per satu agar data lain tidak ikut hilang.
  List<T> _decode<T>(dynamic raw, T Function(Map<String, dynamic>) fromJson) {
    if (raw is! List) return <T>[];
    final result = <T>[];
    for (final item in raw) {
      if (item is Map) {
        try {
          result.add(fromJson(Map<String, dynamic>.from(item)));
        } catch (_) {
          // Lewati record yang tidak bisa dibaca.
        }
      }
    }
    return result;
  }

  Future<void> _save(String key, List<Map<String, dynamic>> data) async {
    final box = await _openBox();
    await box.put(key, data);
  }

  Future<void> _saveCourses() =>
      _save(_coursesKey, courses.map((e) => e.toJson()).toList());

  Future<void> _saveTasks() =>
      _save(_tasksKey, tasks.map((e) => e.toJson()).toList());

  void addCourse(Course course) {
    courses.add(course);
    _saveCourses();
  }

  void deleteCourse(Course course) {
    courses.remove(course);
    _saveCourses();
  }

  void addTask(Task task) {
    tasks.add(task);
    _saveTasks();
    final reminderTime =
        task.deadline.subtract(Duration(hours: task.reminderHoursBefore));
    NotificationService.scheduleTaskReminder(
      taskId: task.id,
      taskTitle: task.title,
      courseName: task.courseName,
      reminderTime: reminderTime,
    );
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    _saveTasks();
    NotificationService.cancelTaskReminders(task.id);
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    _saveTasks();
    if (task.isCompleted) {
      NotificationService.cancelTaskReminders(task.id);
    } else {
      final reminderTime =
          task.deadline.subtract(Duration(hours: task.reminderHoursBefore));
      NotificationService.scheduleTaskReminder(
        taskId: task.id,
        taskTitle: task.title,
        courseName: task.courseName,
        reminderTime: reminderTime,
      );
    }
  }
}
