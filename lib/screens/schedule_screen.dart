import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/storage_service.dart';
import '../widgets/course_card.dart';
import 'add_course_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedDay = 'Senin';
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final courses = StorageService().courses;
    final filteredCourses = courses.where((course) => course.day == _selectedDay).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final totalCredits = courses.fold<int>(0, (sum, course) => sum + course.credits);

    return Scaffold(
      backgroundColor: const Color(0xFF0F131C), // surface
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // xl spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Kuliah',
                        style: TextStyle(
                          color: Color(0xFFF1F5F9), // on-surface-primary
                          fontSize: 24, // H1
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.01,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Atur jadwal kuliahmu dengan mudah',
                        style: TextStyle(
                          color: Color(0xFF94A3B8), // on-surface-secondary
                          fontSize: 14, // Body Regular
                        ),
                      ),
                    ],
                  ),
                  IconButton.filled(
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
                    icon: const Icon(Icons.add, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2433), // surface-container
                      foregroundColor: const Color(0xFF6366F1), // indigo-500 accent
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // --- METRIC CARD ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2433), // surface-container
                  borderRadius: BorderRadius.circular(20), // rounded-2xl
                  border: Border.all(color: const Color(0x14FFFFFF), width: 1), // subtle border
                ),
                child: Row(
                  children: [
                    _summaryItem('${courses.length}', 'Matkul', const Color(0xFF6366F1)), // indigo
                    _divider(),
                    _summaryItem('$totalCredits', 'Total SKS', const Color(0xFFA855F7)), // purple
                    _divider(),
                    _summaryItem('6', 'Hari Kuliah', const Color(0xFF38BDF8)), // sky/cyan
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // --- DAY SELECTOR HEADER ---
              const Text(
                'Jadwal Mingguan',
                style: TextStyle(
                  color: Color(0xFFF1F5F9),
                  fontSize: 18, // H2
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // --- DAY SELECTOR CHIPS ---
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    final isSelected = day == _selectedDay;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFF1F5F9) : const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        selected: isSelected,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _selectedDay = day),
                        selectedColor: const Color(0xFF6366F1), // indigo-500
                        backgroundColor: const Color(0xFF181B25), // surface-container-low
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // rounded-lg
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : const Color(0x14FFFFFF),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // --- CONTENT LIST / EMPTY STATE ---
              Expanded(
                child: filteredCourses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F2433),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0x14FFFFFF), width: 1),
                              ),
                              child: const Icon(
                                Icons.event_note_outlined,
                                size: 48,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Belum ada jadwal',
                              style: TextStyle(
                                color: Color(0xFFF1F5F9),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambahkan mata kuliah untuk hari $_selectedDay',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 32),
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
                                'Tambah Jadwal',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.02,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: const Color(0xFFF1F5F9),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = filteredCourses[index];
                          return CourseCard(
                            course: course,
                            onDelete: () {
                              StorageService().deleteCourse(course);
                              _refresh();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _summaryItem(String value, String label, Color valueColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24, // Metric size
              color: valueColor,
              fontWeight: FontWeight.w800, // Extra bold
              letterSpacing: -0.02,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12, // Label size
              color: Color(0xFF94A3B8), // on-surface-secondary
              fontWeight: FontWeight.w600,
              letterSpacing: 0.02,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 40,
        width: 1,
        color: const Color(0x14FFFFFF), // subtle divider
      );
}