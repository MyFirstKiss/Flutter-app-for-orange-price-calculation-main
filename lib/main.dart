import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/data_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/live_prices_screen.dart';
import 'screens/history_screen.dart';

void main() {
  runApp(const OrangeCalculatorApp());
}

class OrangeCalculatorApp extends StatelessWidget {
  const OrangeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอปคำนวณราคาผลส้ม',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Sarabun',
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8723A),
          surface: const Color(0xFFFFF8F0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8F0),
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D1B0E)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D1B0E),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Sarabun',
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentScreen = 'home';

  void navigateTo(String screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case 'home':
        return HomeScreen(onNavigate: navigateTo);
      case 'data':
        return DataScreen(onNavigate: navigateTo);
      case 'calculator':
        return CalculatorScreen(onNavigate: navigateTo);
      case 'liveprices':
        return LivePricesScreen(onNavigate: navigateTo);
      case 'history':
        return HistoryScreen(onNavigate: navigateTo);
      default:
        return HomeScreen(onNavigate: navigateTo);
    }
  }
}
