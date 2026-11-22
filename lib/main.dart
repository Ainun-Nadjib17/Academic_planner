import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Timezone
  tz.initializeTimeZones();
  
  // 2. Inisialisasi & Minta Izin Notifikasi
  await NotificationService.initialize();
  await NotificationService.requestPermissions();

  // 3. Muat data dari penyimpanan lokal
  await StorageService().loadData();

  runApp(const AcademicPlannerApp());
}

class AcademicPlannerApp extends StatelessWidget {
  const AcademicPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Planner',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF1B2333),
          contentTextStyle: TextStyle(color: Color(0xFFF8FAFC)),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}