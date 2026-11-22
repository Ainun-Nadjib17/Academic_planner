import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';

class MataKuliahScreen extends StatelessWidget {
  final List<Course> courses;
  final Function(Course) onDeleteCourse;
  final VoidCallback onAddCourse;

  const MataKuliahScreen({
    super.key,
    required this.courses,
    required this.onDeleteCourse,
    required this.onAddCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah'),
      ),
      body: courses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text('Belum ada mata kuliah'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onAddCourse,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Mata Kuliah'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];

                return CourseCard(
                  course: course,
                  onDelete: () => onDeleteCourse(course),
                );
              },
            ),
    );
  }
}