import 'package:flutter_test/flutter_test.dart';

import 'package:academic_planner/main.dart';

void main() {
  testWidgets('Dashboard tampil dengan metrik awal kosong', (tester) async {
    await tester.pumpWidget(const AcademicPlannerApp());

    expect(find.text('Halo, Selamat Datang!'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
    expect(find.text('0.0%'), findsOneWidget);
    expect(find.text('Daftar Tugas'), findsOneWidget);
  });
}
