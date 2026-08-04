import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:movieflix/main.dart';

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync('hive_widget_test');
    Hive.init(tempDir.path);
  });

  testWidgets('MovieFlixApp renders splash logo text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MovieFlixApp(),
      ),
    );

    expect(find.byType(MovieFlixApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
