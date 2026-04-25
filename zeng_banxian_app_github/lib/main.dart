import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'providers/fortune_provider.dart';

void main() {
  runApp(const ZengBanXianApp());
}

class ZengBanXianApp extends StatelessWidget {
  const ZengBanXianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FortuneProvider(),
      child: MaterialApp(
        title: '曾半仙算命',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B4513),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'MaShanZheng',
        ),
        home: const HomeScreen(),
        routes: {
          '/result': (context) => const ResultScreen(),
        },
      ),
    );
  }
}
