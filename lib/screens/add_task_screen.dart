import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final List<Course> courses;
  const AddTaskScreen({super.key, required this.courses});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Course? _selectedCourse;
  DateTime? _selectedDeadline;
  int _reminderHours = 24;

  // ============================================================
  // LOGIC (TIDAK DIUBAH)
  // ============================================================

  Future<void> _selectDeadline() async {
    final today = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context, 
      initialDate: today, 
      firstDate: today, 
      lastDate: today.add(const Duration(days: 365)),
      builder: (context, child) {
        // Memaksa date picker menggunakan tema gelap agar sesuai desain
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6366F1), // indigo-500
              surface: Color(0xFF1F2433), // surface-container
              onSurface: Color(0xFFF1F5F9), // on-surface-primary
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() => _selectedDeadline = selectedDate);
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCourse == null || _selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih mata kuliah dan deadline terlebih dahulu'),
          backgroundColor: Color(0xFFF43F5E), // rose-500 untuk warning
        ),
      );
      return;
    }
    Navigator.pop(context, Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(), 
      courseName: _selectedCourse!.name,
      description: _descriptionController.text.trim(), 
      deadline: _selectedDeadline!,
      reminderHoursBefore: _reminderHours,
    ));
  }

  @override
  void dispose() { 
    _titleController.dispose(); 
    _descriptionController.dispose(); 
    super.dispose(); 
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  // ============================================================
  // UI / DESIGN (NOCTURNE SCHOLAR THEME)
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F131C), // surface
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F131C),
        elevation: 0,
        title: const Text(
          'Tambah Tugas', 
          style: TextStyle(
            color: Color(0xFFF1F5F9), // on-surface-primary
            fontWeight: FontWeight.w700, 
            fontSize: 24, // H1
            letterSpacing: -0.01,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF94A3B8)), // on-surface-secondary
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // xl & lg spacing
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Nama Tugas'),
              _textField(
                controller: _titleController, 
                hint: 'Contoh: Membuat laporan praktikum', 
                icon: Icons.assignment_outlined,
              ),
              
              const SizedBox(height: 16), // lg spacing
              
              _label('Mata Kuliah'),
              _dropdown<Course>(
                value: _selectedCourse,
                icon: Icons.menu_book_outlined,
                hint: 'Pilih mata kuliah',
                items: widget.courses.map((course) => 
                  DropdownMenuItem<Course>(value: course, child: Text(course.name, overflow: TextOverflow.ellipsis))
                ).toList(),
                onChanged: (course) => setState(() => _selectedCourse = course),
                validator: (value) => value == null ? 'Mata kuliah wajib dipilih' : null,
              ),
              
              const SizedBox(height: 16),
              
              _label('Deadline'),
              InkWell(
                onTap: _selectDeadline,
                borderRadius: BorderRadius.circular(8), // rounded-lg
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2433), // surface-container
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0x14FFFFFF), width: 1), // subtle border
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Color(0xFF94A3B8), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDeadline == null ? 'Pilih tanggal deadline' : _formatDate(_selectedDeadline!),
                          style: TextStyle(
                            color: _selectedDeadline == null ? const Color(0xFF64748B) : const Color(0xFFF1F5F9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              _label('Pengingat Notifikasi'),
              _dropdown<int>(
                value: _reminderHours,
                icon: Icons.notifications_active_outlined,
                hint: 'Pilih waktu pengingat',
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 Jam sebelumnya')),
                  DropdownMenuItem(value: 3, child: Text('3 Jam sebelumnya')),
                  DropdownMenuItem(value: 12, child: Text('12 Jam sebelumnya')),
                  DropdownMenuItem(value: 24, child: Text('1 Hari (24 Jam) sebelumnya')),
                  DropdownMenuItem(value: 72, child: Text('3 Hari (72 Jam) sebelumnya')),
                ],
                onChanged: (value) { if (value != null) setState(() => _reminderHours = value); },
              ),
              
              const SizedBox(height: 16),
              
              _label('Deskripsi Tugas'),
              TextFormField(
                controller: _descriptionController, 
                maxLines: 4,
                style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14),
                decoration: _decoration(Icons.note_outlined, hint: 'Detail tugas, instruksi, atau catatan...').copyWith(
                  alignLabelWithHint: true,
                ),
              ),
              
              const SizedBox(height: 32), // xl spacing
              
              SizedBox(
                width: double.infinity, 
                height: 56,
                child: FilledButton.icon(
                  onPressed: _saveTask, 
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text(
                    'Simpan Tugas', 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.02,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1), // indigo-500
                    foregroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14), // rounded-xl
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets untuk Desain ---

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // sm spacing
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF94A3B8), // on-surface-secondary
          fontWeight: FontWeight.w600, // SemiBold
          fontSize: 12, // Label size
          letterSpacing: 0.02,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller, 
      style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14),
      decoration: _decoration(icon, hint: hint), 
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Nama tugas wajib diisi' : null,
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required IconData icon,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14),
      decoration: _decoration(icon, hint: hint),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
      dropdownColor: const Color(0xFF1F2433), // surface-container
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  InputDecoration _decoration(IconData icon, {String? hint}) {
    return InputDecoration(
      hintText: hint, 
      hintStyle: const TextStyle(color: Color(0xFF64748B)), // on-surface-tertiary
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20), 
      filled: true, 
      fillColor: const Color(0xFF1F2433), // surface-container
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), // rounded-lg
        borderSide: const BorderSide(color: Color(0x14FFFFFF), width: 1), // rgba(255,255,255,0.08)
      ), 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), 
        borderSide: const BorderSide(color: Color(0x14FFFFFF), width: 1), 
      ), 
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), 
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5), // indigo-500 focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5), // rose-500 error
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
      ),
    );
  }
}