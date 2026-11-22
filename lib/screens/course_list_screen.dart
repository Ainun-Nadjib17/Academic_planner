import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/storage_service.dart';
import '../widgets/course_card.dart';
import 'add_course_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final courses = StorageService().courses;

    return Scaffold(
      backgroundColor: const Color(0xFF0F131C), // surface
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F131C),
        elevation: 0,
        title: const Text(
          'Mata Kuliah',
          style: TextStyle(
            color: Color(0xFFF1F5F9), // on-surface-primary
            fontWeight: FontWeight.w700,
            fontSize: 24, // H1
            letterSpacing: -0.01,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF94A3B8)), // on-surface-secondary
      ),
      body: courses.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ikon dalam lingkaran dengan background surface-container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2433), // surface-container
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0x14FFFFFF), width: 1),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: Color(0xFF94A3B8), // on-surface-secondary
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Belum ada mata kuliah',
                      style: TextStyle(
                        color: Color(0xFFF1F5F9), // on-surface-primary
                        fontSize: 18, // H2
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tambahkan mata kuliah pertamamu untuk memulai perencanaan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8), // on-surface-secondary
                        fontSize: 14, // Body Regular
                      ),
                    ),
                    const SizedBox(height: 32), // xl spacing
                    FilledButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<Course>(
                          context,
                          MaterialPageRoute(builder: (_) => const AddCourseScreen()),
                        );
                        if (result != null) {
                          StorageService().addCourse(result);
                          _refresh();
                        }
                      },
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Tambah Mata Kuliah',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.02,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1), // indigo-500
                        foregroundColor: const Color(0xFFF1F5F9),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14), // rounded-xl
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // xl & lg spacing
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCard(
                  course: course,
                  onDelete: () {
                    StorageService().deleteCourse(course);
                    _refresh();
                  },
                );
              },
            ),
    );
  }
}