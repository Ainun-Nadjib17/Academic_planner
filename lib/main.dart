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
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF536DFE)),
      ),
      home: const DashboardScreen(),
    );
  }
}