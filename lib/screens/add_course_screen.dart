import 'package:flutter/material.dart';
import '../models/course.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _roomController = TextEditingController();
  
  String _selectedDay = 'Senin';
  int _selectedCredits = 2;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 40);
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];

  // ============================================================
  // LOGIC (TIDAK DIUBAH)
  // ============================================================

  Future<void> _selectTime(bool isStart) async {
    final selected = await showTimePicker(
      context: context, 
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) {
        // Memaksa time picker menggunakan tema gelap agar sesuai desain
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6366F1),
              surface: Color(0xFF1F2433),
              onSurface: Color(0xFFF1F5F9),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      setState(() {
        if (isStart) _startTime = selected;
        else _endTime = selected;
      });
    }
  }

  String _formatTime(TimeOfDay time) => 
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  void _saveCourse() {
    if (!_formKey.currentState!.validate()) return;
    if ((_endTime.hour * 60 + _endTime.minute) <= (_startTime.hour * 60 + _startTime.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jam selesai harus setelah jam mulai'),
          backgroundColor: Color(0xFFF43F5E), // rose-500 untuk warning
        ),
      );
      return;
    }
    Navigator.pop(context, Course(
      name: _nameController.text.trim(), 
      lecturer: _lecturerController.text.trim(), 
      day: _selectedDay,
      startTime: _formatTime(_startTime), 
      endTime: _formatTime(_endTime),
      credits: _selectedCredits, 
      room: _roomController.text.trim(),
    ));
  }

  @override
  void dispose() { 
    _nameController.dispose(); 
    _lecturerController.dispose(); 
    _roomController.dispose(); 
    super.dispose(); 
  }

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
          'Tambah Mata Kuliah', 
          style: TextStyle(
            color: Color(0xFFF1F5F9), // on-surface-primary
            fontWeight: FontWeight.w700, // Bold
            fontSize: 24, // H1
            letterSpacing: -0.01,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF94A3B8)), // on-surface-secondary
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // xl & lg spacing
          children: [
            _label('Nama Mata Kuliah'),
            _textField(controller: _nameController, hint: 'Contoh: Pemrograman Java', icon: Icons.book_outlined),
            
            const SizedBox(height: 16), // lg spacing
            
            _label('Nama Dosen'),
            _textField(controller: _lecturerController, hint: 'Nama dosen pengampu', icon: Icons.person_outline),
            
            const SizedBox(height: 16),
            
            _label('Hari'),
            _dropdown<String>(
              value: _selectedDay,
              icon: Icons.calendar_today_outlined,
              items: _days.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
              onChanged: (value) { if (value != null) setState(() => _selectedDay = value); },
            ),
            
            const SizedBox(height: 16),
            
            _label('Jumlah SKS'),
            _dropdown<int>(
              value: _selectedCredits,
              icon: Icons.school_outlined,
              items: [1, 2, 3, 4, 5, 6].map((sks) => DropdownMenuItem(value: sks, child: Text('$sks SKS'))).toList(),
              onChanged: (value) { if (value != null) setState(() => _selectedCredits = value); },
            ),
            
            const SizedBox(height: 16),
            
            _label('Waktu Kuliah'),
            Row(
              children: [
                Expanded(child: _timeButton('Mulai', _startTime, () => _selectTime(true))),
                const SizedBox(width: 12), // md spacing
                Expanded(child: _timeButton('Selesai', _endTime, () => _selectTime(false))),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _label('Ruangan'),
            _textField(controller: _roomController, hint: 'Contoh: B-204', icon: Icons.location_on_outlined, requiredField: false),
            
            const SizedBox(height: 32), // xl spacing
            
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _saveCourse,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1), // indigo-500 (Primary Brand)
                  foregroundColor: const Color(0xFFF1F5F9), // on-surface-primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14), // rounded-xl
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simpan Mata Kuliah', 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w700, // Bold
                    letterSpacing: 0.02,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
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
          fontSize: 12, // Label / Badges size
          letterSpacing: 0.02,
        ),
      ),
    );
  }
  
  Widget _textField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    bool requiredField = true
  }) {
    return TextFormField(
      controller: controller, 
      style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14), // Body Regular
      decoration: _decoration(icon, hint: hint), 
      validator: requiredField 
          ? (value) => (value == null || value.trim().isEmpty) ? 'Field ini wajib diisi' : null 
          : null,
    );
  }

  Widget _dropdown<T>({
    required T value,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14),
      decoration: _decoration(icon),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
      dropdownColor: const Color(0xFF1F2433), // surface-container
      items: items,
      onChanged: onChanged,
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
        borderRadius: BorderRadius.circular(8), // rounded-lg untuk input fields
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

  Widget _timeButton(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14), // rounded-xl
      child: Container(
        padding: const EdgeInsets.all(16), // lg padding
        decoration: BoxDecoration(
          color: const Color(0xFF1F2433), // surface-container
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x14FFFFFF), width: 1), // subtle border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF94A3B8), // on-surface-secondary
                fontSize: 12, 
                fontWeight: FontWeight.w600,
                letterSpacing: 0.02,
              ),
            ),
            const SizedBox(height: 8), // sm spacing
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Color(0xFF6366F1)), // indigo-500 accent
                const SizedBox(width: 8),
                Text(
                  _formatTime(time),
                  style: const TextStyle(
                    color: Color(0xFFF1F5F9), // on-surface-primary
                    fontWeight: FontWeight.w700, // Bold
                    fontSize: 16, // H2 size untuk angka penting
                    letterSpacing: -0.01,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}