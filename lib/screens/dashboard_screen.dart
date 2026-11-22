import 'package:flutter/material.dart';
import 'schedule_screen.dart';
import 'course_list_screen.dart';
import 'task_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F131C), // surface
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0), // xl spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Halo, Selamat Datang!',
                style: TextStyle(
                  color: Color(0xFFF1F5F9), // on-surface-primary
                  fontSize: 24, // H1
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.01,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih menu di bawah untuk mengelola akademismu.',
                style: TextStyle(
                  color: Color(0xFF94A3B8), // on-surface-secondary
                  fontSize: 14, // Body Regular
                ),
              ),
              const SizedBox(height: 32), // xl spacing
              
              _buildMenuCard(
                context,
                icon: Icons.calendar_month,
                title: 'Jadwal Kuliah',
                subtitle: 'Lihat jadwal harian dan mingguan',
                color: const Color(0xFF6366F1), // indigo-500 (Primary Brand)
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen())),
              ),
              const SizedBox(height: 16), // lg spacing
              _buildMenuCard(
                context,
                icon: Icons.menu_book,
                title: 'Mata Kuliah',
                subtitle: 'Kelola daftar mata kuliah dan dosen',
                color: const Color(0xFFA855F7), // purple-500 (Accent Violet)
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseListScreen())),
              ),
              const SizedBox(height: 16), // lg spacing
              _buildMenuCard(
                context,
                icon: Icons.assignment,
                title: 'Daftar Tugas',
                subtitle: 'Pantau deadline dan tugas yang harus dikumpulkan',
                color: const Color(0xFFF43F5E), // rose-500 (Urgent / Deadline)
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskListScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2433), // surface-container
        borderRadius: BorderRadius.circular(14), // rounded-xl
        border: Border.all(color: const Color(0x14FFFFFF), width: 1), // rgba(255,255,255,0.08) subtle border
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(20), // lg padding
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15), // Opacity dinaikkan sedikit agar terlihat di dark mode
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFFF1F5F9), // on-surface-primary
                          fontSize: 16, // H2/Subheading
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8), // on-surface-secondary
                          fontSize: 13, // Body/Caption
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF64748B), // on-surface-tertiary
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}