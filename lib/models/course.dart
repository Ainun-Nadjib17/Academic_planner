class Course {
  final String name;
  final String lecturer;
  final String day;
  final String startTime;
  final String endTime;
  final int credits;
  final String room;

  Course({
    required this.name,
    required this.lecturer,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.credits,
    required this.room,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name, 'lecturer': lecturer, 'day': day,
      'startTime': startTime, 'endTime': endTime,
      'credits': credits, 'room': room,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      name: json['name'], lecturer: json['lecturer'], day: json['day'],
      startTime: json['startTime'], endTime: json['endTime'],
      credits: json['credits'], room: json['room'],
    );
  }
}