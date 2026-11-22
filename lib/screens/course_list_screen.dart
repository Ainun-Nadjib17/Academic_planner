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

  // Tombol kembali selalu mengarah ke Dashboard.
  void _backToDashboard() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final courses = StorageService().courses;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19), // surface
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F19),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'Kembali ke Dashboard',
          onPressed: _backToDashboard,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Mata Kuliah',
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFCBD5E1)),
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
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF232C42), Color(0xFF121826)],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0x33A855F7), width: 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4DA855F7),
                            blurRadius: 28,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 42,
                        color: Color(0xFFC4B5FD),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Belum ada mata kuliah',
                      style: TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tambahkan mata kuliah pertamamu untuk memulai perencanaan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13.5,
                        height: 1.45,
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
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: const Color(0xFFFFFFFF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: const Color(0x666366F1),
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