import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onDelete;

  const CourseCard({super.key, required this.course, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 5, height: 85, decoration: BoxDecoration(color: const Color(0xFF536DFE), borderRadius: BorderRadius.circular(10))),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(course.lecturer, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 15, color: Color(0xFF536DFE)),
                      const SizedBox(width: 5),
                      Text('${course.startTime} - ${course.endTime}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 15, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(course.room.isEmpty ? 'Ruangan belum ditentukan' : course.room, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 10),
                      Text('${course.credits} SKS', style: const TextStyle(fontSize: 12, color: Color(0xFF536DFE), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}