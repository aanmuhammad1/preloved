import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preloved/main.dart';

void main() {
  testWidgets('PrelovedApp berhasil dibuat', (tester) async {
    await tester.pumpWidget(const PrelovedApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Judul halaman Preloved tampil', (tester) async {
    await tester.pumpWidget(const PrelovedApp());

    expect(find.text('Preloved'), findsOneWidget);
  });

  testWidgets('Halaman memiliki Scaffold', (tester) async {
    await tester.pumpWidget(const PrelovedApp());

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
