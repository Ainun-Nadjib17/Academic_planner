import 'package:flutter/material.dart';
import 'models/course.dart';

class Task {
  final String id;
  final String title;
  final String courseName;
  final String description;
  final DateTime deadline;
  bool isCompleted;
  final int reminderHoursBefore; // <-- BARU: Berapa jam sebelum deadline

  Task({
    required this.id,
    required this.title,
    required this.courseName,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
    this.reminderHoursBefore = 24, // <-- BARU: Default 24 jam (1 hari) sebelumnya
  });
}

class TambahTugasScreen extends StatefulWidget {
  final List<Course> courses;
  final Function(Task) onAddTask;

  const TambahTugasScreen({
    super.key,
    required this.courses,
    required this.onAddTask,
  });

  @override
  State<TambahTugasScreen> createState() => _TambahTugasScreenState();
}

class _TambahTugasScreenState extends State<TambahTugasScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Course? _selectedCourse;
  DateTime? _selectedDeadline;
  int _reminderHours = 24; // <-- BARU: State untuk menyimpan pilihan jam pengingat

  Future<void> _selectDeadline() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDeadline = selectedDate;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCourse == null || _selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih mata kuliah dan deadline terlebih dahulu'),
        ),
      );
      return;
    }

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      courseName: _selectedCourse!.name,
      description: _descriptionController.text.trim(),
      deadline: _selectedDeadline!,
      reminderHoursBefore: _reminderHours, // <-- BARU: Masukkan nilai jam ke model Task
    );

    widget.onAddTask(task);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
      ),
      body: widget.courses.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada mata kuliah.\n'
                  'Tambahkan mata kuliah terlebih dahulu.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama tugas
                    const Text(
                      'Nama Tugas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Membuat laporan praktikum',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.assignment),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama tugas wajib diisi';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Pilihan mata kuliah
                    const Text(
                      'Mata Kuliah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Course>(
                      value: _selectedCourse,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.menu_book),
                        hintText: 'Pilih mata kuliah',
                      ),
                      items: widget.courses.map((course) {
                        return DropdownMenuItem<Course>(
                          value: course,
                          child: Text(
                            course.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (course) {
                        setState(() {
                          _selectedCourse = course;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Mata kuliah wajib dipilih';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Deadline
                    const Text(
                      'Deadline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDeadline,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_month),
                        ),
                        child: Text(
                          _selectedDeadline == null
                              ? 'Pilih tanggal deadline'
                              : '${_selectedDeadline!.day}/'
                                '${_selectedDeadline!.month}/'
                                '${_selectedDeadline!.year}',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // <-- BARU: Pengaturan Waktu Pengingat Notifikasi
                    const Text(
                      'Pengingat Notifikasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _reminderHours,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.notifications_active),
                        hintText: 'Pilih waktu pengingat',
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 Jam sebelumnya')),
                        DropdownMenuItem(value: 3, child: Text('3 Jam sebelumnya')),
                        DropdownMenuItem(value: 12, child: Text('12 Jam sebelumnya')),
                        DropdownMenuItem(value: 24, child: Text('1 Hari (24 Jam) sebelumnya')),
                        DropdownMenuItem(value: 72, child: Text('3 Hari (72 Jam) sebelumnya')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _reminderHours = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Deskripsi
                    const Text(
                      'Deskripsi Tugas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Detail tugas, instruksi, atau catatan...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveTask,
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Tugas'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}