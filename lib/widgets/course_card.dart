import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onDelete;

  const CourseCard({super.key, required this.course, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0x1AFFFFFF), width: 1),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2233), Color(0xFF121826)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 85,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        height: 1.25,
                        color: Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course.lecturer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 15, color: Color(0xFF8B9DFF)),
                        const SizedBox(width: 5),
                        Text(
                          '${course.startTime} - ${course.endTime}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFCBD5E1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            course.room.isEmpty ? 'Ruangan belum ditentukan' : course.room,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0x2E6366F1),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0x4D8B9DFF), width: 1),
                          ),
                          child: Text(
                            '${course.credits} SKS',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFC7D2FE),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0x1AF43F5E),
                  foregroundColor: const Color(0xFFF43F5E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.delete_outline, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
