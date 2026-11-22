import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/task.dart';
import 'notification_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  List<Course> courses = [];
  List<Task> tasks = [];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final coursesString = prefs.getString('courses');
      if (coursesString != null) {
        courses = jsonDecode(coursesString).map((e) => Course.fromJson(e)).toList();
      }
    } catch (e) { /* ignore */ }

    try {
      final tasksString = prefs.getString('tasks');
      if (tasksString != null) {
        tasks = jsonDecode(tasksString).map((e) => Task.fromJson(e)).toList();
        // Jadwalkan ulang notifikasi untuk tugas yang belum selesai saat app dibuka
        for (var task in tasks) {
          if (!task.isCompleted) {
            final reminderTime = task.deadline.subtract(Duration(hours: task.reminderHoursBefore));
            NotificationService.scheduleTaskReminder(
              taskId: task.id, taskTitle: task.title, courseName: task.courseName, reminderTime: reminderTime,
            );
          }
        }
      }
    } catch (e) { /* ignore */ }
  }

  Future<void> _saveCourses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('courses', jsonEncode(courses.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(tasks.map((e) => e.toJson()).toList()));
  }

  void addCourse(Course course) { courses.add(course); _saveCourses(); }
  void deleteCourse(Course course) { courses.remove(course); _saveCourses(); }

  void addTask(Task task) {
    tasks.add(task);
    _saveTasks();
    final reminderTime = task.deadline.subtract(Duration(hours: task.reminderHoursBefore));
    NotificationService.scheduleTaskReminder(taskId: task.id, taskTitle: task.title, courseName: task.courseName, reminderTime: reminderTime);
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
      final reminderTime = task.deadline.subtract(Duration(hours: task.reminderHoursBefore));
      NotificationService.scheduleTaskReminder(taskId: task.id, taskTitle: task.title, courseName: task.courseName, reminderTime: reminderTime);
    }
  }
}