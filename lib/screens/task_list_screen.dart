import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  void _refresh() => setState(() {});

  // Tombol kembali selalu mengarah ke Dashboard.
  void _backToDashboard() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final tasks = StorageService().tasks;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;

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
                          'Daftar Tugas',
                          style: TextStyle(
                            color: Color(0xFFF8FAFC),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola tugas kuliahmu',
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
                      final result = await Navigator.push<Task>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTaskScreen(courses: StorageService().courses),
                        ),
                      );
                      if (result != null) {
                        StorageService().addTask(result);
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
                width: double.infinity,
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
                    _summaryItem(tasks.length.toString(), 'Total Tugas', const Color(0xFF6366F1)), // indigo
                    _divider(),
                    _summaryItem(completedTasks.toString(), 'Selesai', const Color(0xFF10B981)), // emerald (success)
                    _divider(),
                    _summaryItem(pendingTasks.toString(), 'Belum Selesai', const Color(0xFFF43F5E)), // rose (urgent)
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // --- SECTION TITLE ---
              const Text(
                'Semua Tugas',
                style: TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 16),
              
              // --- CONTENT LIST / EMPTY STATE ---
              Expanded(
                child: tasks.isEmpty
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
                                border: Border.all(color: const Color(0x33F43F5E), width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x4DF43F5E),
                                    blurRadius: 28,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.assignment_outlined,
                                size: 42,
                                color: Color(0xFFFDA4AF),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Belum ada tugas',
                              style: TextStyle(
                                color: Color(0xFFF8FAFC),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tambahkan tugas kuliahmu agar tidak terlewat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13.5,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 32),
                            FilledButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push<Task>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddTaskScreen(courses: StorageService().courses),
                                  ),
                                );
                                if (result != null) {
                                  StorageService().addTask(result);
                                  _refresh();
                                }
                              },
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text(
                                'Tambah Tugas',
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
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final isDone = task.isCompleted;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDone
                                    ? const [Color(0xFF121826), Color(0xFF0E1420)]
                                    : const [Color(0xFF1A2233), Color(0xFF121826)],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isDone
                                    ? const Color(0x14FFFFFF)
                                    : const Color(0x1F6366F1),
                                width: 1,
                              ),
                              boxShadow: isDone
                                  ? null
                                  : const [
                                      BoxShadow(
                                        color: Color(0x33000000),
                                        blurRadius: 16,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Custom Checkbox
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: const Color(0xFF94A3B8),
                                  ),
                                  child: Checkbox(
                                    value: isDone,
                                    activeColor: const Color(0xFF10B981),
                                    checkColor: const Color(0xFF0B0F19),
                                    side: const BorderSide(color: Color(0xFF64748B), width: 1.6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    onChanged: (_) {
                                      StorageService().toggleTask(task);
                                      _refresh();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Task Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          color: isDone ? const Color(0xFF64748B) : const Color(0xFFF8FAFC),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          letterSpacing: -0.2,
                                          decoration: isDone ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.menu_book, size: 14, color: Color(0xFF6366F1)),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              task.courseName,
                                              style: const TextStyle(
                                                color: Color(0xFF94A3B8),
                                                fontSize: 13,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today, 
                                            size: 14, 
                                            color: isDone ? const Color(0xFF64748B) : const Color(0xFFF43F5E), // Rose jika belum selesai
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Deadline: ${_formatDate(task.deadline)}',
                                            style: TextStyle(
                                              color: isDone ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (task.description.isNotEmpty) ...[
                                        const SizedBox(height: 10),
                                        Text(
                                          task.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                
                                // Delete Button
                                IconButton(
                                  onPressed: () {
                                    StorageService().deleteTask(task);
                                    _refresh();
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFFF43F5E), // rose-500
                                    size: 22,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
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