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

  // Tombol kembali selalu mengarah ke Dashboard.
  void _backToDashboard() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final courses = StorageService().courses;
    final filteredCourses = courses.where((course) => course.day == _selectedDay).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    final totalCredits = courses.fold<int>(0, (sum, course) => sum + course.credits);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19), // surface
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
                  IconButton.filled(
                    tooltip: 'Kembali ke Dashboard',
                    onPressed: _backToDashboard,
                    icon: const Icon(Icons.arrow_back, size: 22),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF161E2E),
                      foregroundColor: const Color(0xFFCBD5E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0x1AFFFFFF)),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwal Kuliah',
                          style: TextStyle(
                            color: Color(0xFFF8FAFC),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Atur jadwal kuliahmu dengan mudah',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
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
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: const Color(0xFFF8FAFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A2233), Color(0xFF121826)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x59000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
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
                  color: Color(0xFFE2E8F0),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
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
                            color: isSelected ? const Color(0xFFF8FAFC) : const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.1,
                          ),
                        ),
                        selected: isSelected,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _selectedDay = day),
                        selectedColor: const Color(0xFF6366F1),
                        backgroundColor: const Color(0xFF141B28),
                        surfaceTintColor: Colors.transparent,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected ? const Color(0xFF8B9DFF) : const Color(0x1AFFFFFF),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                        child: SingleChildScrollView(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF232C42), Color(0xFF121826)],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0x336366F1), width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x4D6366F1),
                                    blurRadius: 28,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.event_note_outlined,
                                size: 42,
                                color: Color(0xFF8B9DFF),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Belum ada jadwal',
                              style: TextStyle(
                                color: Color(0xFFF8FAFC),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambahkan mata kuliah untuk hari $_selectedDay',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13.5,
                                height: 1.45,
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
              fontSize: 26,
              color: valueColor,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF93A1B8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 40,
        width: 1,
        color: const Color(0x1AFFFFFF), // subtle divider
      );
}