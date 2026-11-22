import 'package:flutter/material.dart';
import 'schedule_screen.dart';
import 'course_list_screen.dart';
import 'task_list_screen.dart';
import '../services/storage_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = StorageService().tasks;
    final now = DateTime.now();

    // --- 1. PERHITUNGAN METRIK ---
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = tasks.where((t) => !t.isCompleted).length;
    final totalTasks = tasks.length;
    final completionRate =
        totalTasks == 0 ? 0.0 : (completedTasks / totalTasks) * 100;
    final overdueTasks =
        tasks.where((t) => !t.isCompleted && t.deadline.isBefore(now)).length;

    // --- 2. PERHITUNGAN GRAFIK PER MINGGU (4 Minggu Terakhir) ---
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    for (var task in tasks) {
      if (task.isCompleted) {
        final diff = now.difference(task.deadline).inDays;
        if (diff >= 0 && diff < 7)
          w1++;
        else if (diff >= 7 && diff < 14)
          w2++;
        else if (diff >= 14 && diff < 21)
          w3++;
        else if (diff >= 21 && diff < 28) w4++;
      }
    }
    final maxVal =
        [w1, w2, w3, w4].reduce((a, b) => a > b ? a : b).clamp(1, 100);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: SafeArea(
        // --- PERBAIKAN UTAMA: Tambahkan SingleChildScrollView ---
        child: SingleChildScrollView(
          // Padding dipindah ke sini agar area scroll benar-benar penuh
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo, Selamat Datang!',
                style: TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih menu di bawah untuk mengelola akademismu.',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),

              // --- METRICS SECTION ---
              Container(
                padding: const EdgeInsets.all(18),
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
                      color: Color(0x66000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildMetricItem(
                                'Selesai',
                                completedTasks.toString(),
                                const Color(0xFF10B981))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildMetricItem(
                                'Belum Selesai',
                                pendingTasks.toString(),
                                const Color(0xFFF43F5E))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0x14FFFFFF), height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: _buildMetricItem(
                                'Completion Rate',
                                '${completionRate.toStringAsFixed(1)}%',
                                const Color(0xFF6366F1))),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _buildMetricItem(
                                'Terlambat',
                                overdueTasks.toString(),
                                const Color(0xFFF59E0B))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- CHART SECTION ---
              const Text(
                'Penyelesaian Tugas per Minggu',
                style: TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
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
                child: SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBarChartItem('4M', w4, maxVal),
                      _buildBarChartItem('3M', w3, maxVal),
                      _buildBarChartItem('2M', w2, maxVal),
                      _buildBarChartItem('1M', w1, maxVal),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- MENU CARDS ---
              _buildMenuCard(
                context,
                icon: Icons.calendar_month,
                title: 'Jadwal Kuliah',
                subtitle: 'Lihat jadwal harian dan mingguan',
                color: const Color(0xFF6366F1),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ScheduleScreen())).then((_) {
                  if (mounted) setState(() {});
                }),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                icon: Icons.menu_book,
                title: 'Mata Kuliah',
                subtitle: 'Kelola daftar mata kuliah dan dosen',
                color: const Color(0xFFA855F7),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CourseListScreen())).then((_) {
                          if (mounted) setState(() {});
                        }),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                icon: Icons.assignment,
                title: 'Daftar Tugas',
                subtitle: 'Pantau deadline dan tugas yang harus dikumpulkan',
                color: const Color(0xFFF43F5E),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TaskListScreen())).then((_) {
                  if (mounted) setState(() {});
                }),
              ),

              // Jarak aman di bawah agar tidak mentok di notch/home indicator
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChartItem(String label, int value, int maxVal) {
    final heightPercent = (value / maxVal).clamp(0.1, 1.0);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Color(0xFFF1F5F9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 22,
            height: 80 * heightPercent,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
              ),
              borderRadius: BorderRadius.circular(11),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x556366F1),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
        ],
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2233), Color(0xFF121826)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.30), color.withOpacity(0.10)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(0.35), width: 1),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0x0DFFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
