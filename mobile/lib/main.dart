import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
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

class _DeenIslamAppState extends State<DeenIslamApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
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
      title: 'দ্বীন ইসলাম - DeenIslam',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MainNavigationScaffold(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
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
