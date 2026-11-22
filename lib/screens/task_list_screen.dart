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
  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final tasks = StorageService().tasks;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;

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
                        'Daftar Tugas',
                        style: TextStyle(
                          color: Color(0xFFF1F5F9), // on-surface-primary
                          fontSize: 24, // H1
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.01,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kelola tugas kuliahmu',
                        style: TextStyle(
                          color: Color(0xFF94A3B8), // on-surface-secondary
                          fontSize: 14, // Body Regular
                        ),
                      ),
                    ],
                  ),
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
                      backgroundColor: const Color(0xFF1F2433), // surface-container
                      foregroundColor: const Color(0xFF6366F1), // indigo-500
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
                  color: const Color(0xFF1F2433), // surface-container
                  borderRadius: BorderRadius.circular(20), // rounded-2xl
                  border: Border.all(color: const Color(0x14FFFFFF), width: 1), // subtle border
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
                  color: Color(0xFFF1F5F9),
                  fontSize: 18, // H2
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // --- CONTENT LIST / EMPTY STATE ---
              Expanded(
                child: tasks.isEmpty
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
                                Icons.assignment_outlined,
                                size: 48,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Belum ada tugas',
                              style: TextStyle(
                                color: Color(0xFFF1F5F9),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tambahkan tugas kuliahmu agar tidak terlewat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
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
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final isDone = task.isCompleted;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F2433), // surface-container
                              borderRadius: BorderRadius.circular(14), // rounded-xl
                              border: Border.all(
                                color: isDone 
                                    ? const Color(0x0AFFFFFF) // Border lebih tipis jika selesai
                                    : const Color(0x14FFFFFF), // Normal border
                                width: 1,
                              ),
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
                                    activeColor: const Color(0xFF10B981), // emerald-500 for success
                                    checkColor: const Color(0xFF0F131C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
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
                                          color: isDone ? const Color(0xFF64748B) : const Color(0xFFF1F5F9),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
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
              fontSize: 24, // Metric size
              color: valueColor,
              fontWeight: FontWeight.w800,
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