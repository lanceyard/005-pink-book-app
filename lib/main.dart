import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/login_page.dart';
import 'package:pink_book_app/ui/register_page.dart';
import 'package:pink_book_app/widget/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

//! To Do :
// SplashScreen bawaan flutter belum hilang kurang tau solusinya
// Dependencies Goggle fonts belum terbaru

//* Changes System:
// Melakukan perubahan pada CompileSDkVersion menjadi 34
// Mengupgrade gradle.wrapper (di aku erorr kemarin harus up ke 8.1.1)

