class Task {
  final String id;
  final String title;
  final String courseName;
  final String description;
  final DateTime deadline;
  bool isCompleted;
  final int reminderHoursBefore;

  Task({
    required this.id,
    required this.title,
    required this.courseName,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
    this.reminderHoursBefore = 24,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'title': title, 'courseName': courseName,
      'description': description, 'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted, 'reminderHoursBefore': reminderHoursBefore,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'], title: json['title'], courseName: json['courseName'],
      description: json['description'], deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'] ?? false,
      reminderHoursBefore: json['reminderHoursBefore'] ?? 24,
    );
  }
}