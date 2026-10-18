import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/audio_service.dart';
import 'core/services/location_service.dart';
import 'core/services/reminder_service.dart';
import 'core/services/storage_service.dart';
import 'features/location/onboarding_screen.dart';
import 'core/theme/app_theme.dart';
import 'data/models/prayer_times_model.dart';
import 'features/dua/presentation/dua_screen.dart';
import 'features/hadith/presentation/hadith_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/prayer/presentation/prayer_screen.dart';
import 'features/quran/presentation/quran_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const DeenIslamApp());
}

class DeenIslamApp extends StatefulWidget {
  const DeenIslamApp({super.key});

  @override
  State<DeenIslamApp> createState() => _DeenIslamAppState();
}

class _DeenIslamAppState extends State<DeenIslamApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.light;
  bool? _onboarded; // null while the saved flag loads

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    StorageService.getOnboarded().then((v) {
      if (mounted) setState(() => _onboarded = v);
    });
    StorageService.loadCalcConfig();
    _loadSavedTheme();
    // Non-blocking: never delays first frame or prompts for permissions.
    _syncReminders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Covers date, time-zone and permission changes while the app was away.
    if (state == AppLifecycleState.resumed) _syncReminders();
  }

  /// Refreshes the saved GPS fix silently (only if permission is already
  /// granted and the fix is stale), then re-applies the reminder schedule.
  Future<void> _syncReminders() async {
    try {
      var loc = await LocationService.load();
      if (LocationService.isStale(loc) && await LocationService.hasPermission()) {
        final r = await LocationService.detect(requestPermission: false);
        if (r.isSuccess) loc = r.location!;
      }
      await ReminderService.instance.init();
      if (await ReminderService.instance.notificationsAllowed()) {
        await ReminderService.instance.reschedule(loc);
      }
    } catch (_) {
      // Reminders are best-effort at startup; screens report real errors.
    }
  }

  Future<void> _loadSavedTheme() async {
    final isDark = await StorageService.getDarkMode();
    if (!mounted) return;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final nextIsDark = _themeMode != ThemeMode.dark;
    setState(() {
      _themeMode = nextIsDark ? ThemeMode.dark : ThemeMode.light;
    });
    await StorageService.setDarkMode(nextIsDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MISHKAT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: _onboarded == null
          ? const Scaffold(body: SizedBox.shrink())
          : (_onboarded!
              ? MainNavigationScaffold(
                  onToggleTheme: _toggleTheme,
                  isDark: _themeMode == ThemeMode.dark,
                )
              : LocationOnboardingScreen(
                  onDone: (_) {
                    setState(() => _onboarded = true);
                    _syncReminders();
                  },
                )),
    );
  }
}

class MainNavigationScaffold extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const MainNavigationScaffold({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _currentIndex = 0;
  Timer? _adhanTimer;
  String? _lastAdhanKey;

  // Same stream the settings preview uses. It needs internet and plays only
  // while the app is open; background playback is not implemented.
  static const String _adhanUrl = 'https://www.islamcan.com/audio/adhan/azan1.mp3';

  @override
  void initState() {
    super.initState();
    _adhanTimer = Timer.periodic(const Duration(seconds: 20), (_) => _checkAdhan());
  }

  @override
  void dispose() {
    _adhanTimer?.cancel();
    super.dispose();
  }

  /// Foreground Adhan: plays once when an enabled prayer time arrives while
  /// the app is open. Uses the same schedule as the UI and reminders.
  Future<void> _checkAdhan() async {
    try {
      final now = DateTime.now();
      final loc = await LocationService.load();
      final t = PrayerTimesModel.forLocation(now, loc);
      final waqts = {
        'ফজর': t.fajr,
        'যোহর': t.dhuhr,
        'আসর': t.asr,
        'মাগরিব (ইফতার)': t.maghrib,
        'ইশা': t.isha,
      };
      final alarms = await StorageService.getAzanAlarms();
      for (final e in waqts.entries) {
        if (e.value.hour != now.hour || e.value.minute != now.minute) continue;
        if (!(alarms[e.key] ?? true)) return;
        final key = '${now.year}-${now.month}-${now.day}-${e.key}';
        if (_lastAdhanKey == key) return;
        _lastAdhanKey = key;
        if (!mounted) return;
        // When the Adhan file is bundled, Android plays it itself from the
        // scheduled notification (also with the app open); don't double-play.
        if (await ReminderService.instance.adhanAvailable() &&
            await StorageService.getAdhanSound()) {
          return;
        }
        await AudioService.instance.playUrl(_adhanUrl);
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${e.key}-এর ওয়াক্ত হয়েছে'),
              duration: const Duration(seconds: 30),
              action: SnackBarAction(
                label: 'থামান',
                onPressed: () => AudioService.instance.stop(),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        return;
      }
    } catch (_) {
      // Never crash the UI because of an optional foreground sound.
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onToggleTheme: widget.onToggleTheme,
        isDark: widget.isDark,
      ),
      const QuranScreen(),
      const HadithScreen(),
      const PrayerScreen(),
      const DuaScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "হোম",
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: "কুরআন",
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: "হাদিস",
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time_filled),
            label: "নামাজ",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: "দোয়া",
          ),
        ],
      ),
    );
  }
}
