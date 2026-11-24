import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deen_islam/features/home/presentation/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'deen_selected_city_v1': 'ঢাকা',
    });
  });

  testWidgets('HomeScreen renders clean decluttered layout without errors', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          onToggleTheme: () {},
          isDark: false,
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Verify AppBar elements
    expect(find.text('দ্বীন ইসলাম'), findsOneWidget);
    expect(find.text('ঢাকা'), findsOneWidget);

    // 2. Verify Unified Spiritual Hub elements
    expect(find.textContaining('পরবর্তী ওয়াক্ত'), findsOneWidget);
    expect(find.textContaining('বর্তমান:'), findsOneWidget);
    expect(find.text('সকল ওয়াক্ত'), findsOneWidget);

    // 3. Verify Daily Quick Essentials
    expect(find.text('কিবলা কম্পাস'), findsWidgets);
    expect(find.text('ডিজিটাল তাসবীহ'), findsWidgets);
    expect(find.text('নিত্যদিনের দোয়া'), findsWidgets);
    expect(find.text('সালাত শিক্ষা'), findsOneWidget);

    // 4. Verify Quran Audio Deck
    expect(find.text('সূরা আল-ফাতিহা'), findsOneWidget);
    expect(find.text('কুরআন'), findsOneWidget);

    // 5. Verify Asmaul Husna Name Card
    expect(find.text('আসমাউল হুসনা'), findsOneWidget);
    expect(find.text('অন্য নাম ↻'), findsOneWidget);
    expect(find.text('সকল ৯৯ নাম →'), findsOneWidget);

    // 6. Verify Seerah Encyclopedia Card
    expect(find.textContaining('সীরাতুন্নবী (ﷺ) বিশ্বকোষ'), findsOneWidget);

    // 7. Verify Categorized Services Header & Filter Chips
    expect(find.text('ইসলামিক সেবাসমূহ'), findsOneWidget);
    expect(find.textContaining('সবগুলো'), findsOneWidget);
    expect(find.textContaining('ইবাদত'), findsWidgets);
    expect(find.textContaining('কুরআন ও জ্ঞান'), findsOneWidget);
    expect(find.textContaining('টুলস'), findsOneWidget);
  });

  testWidgets('HomeScreen Asmaul Husna cycles name on button tap', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          onToggleTheme: () {},
          isDark: false,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Initially shows #১
    expect(find.text('#১ / ৯৯'), findsOneWidget);

    // Scroll until visible then tap "অন্য নাম ↻"
    await tester.scrollUntilVisible(
      find.text('অন্য নাম ↻'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('অন্য নাম ↻'));
    await tester.pumpAndSettle();

    // Now cycles to #২
    expect(find.text('#২ / ৯৯'), findsOneWidget);
  });

  testWidgets('HomeScreen service category filter switches list cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          onToggleTheme: () {},
          isDark: false,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Initially 'সবগুলো (২০)' shows 20 items
    expect(find.text('২০টি সেবা'), findsOneWidget);

    // Scroll until visible then tap '🛠️ টুলস (৫)'
    await tester.scrollUntilVisible(
      find.text('🛠️ টুলস (৫)'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('🛠️ টুলস (৫)'));
    await tester.pumpAndSettle();

    // Now shows 5 items
    expect(find.text('৫টি সেবা'), findsOneWidget);
  });
}
