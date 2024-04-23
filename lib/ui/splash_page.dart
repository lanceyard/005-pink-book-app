import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pink_book_app/widget/theme/color_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: basePinkColor,
      body: Center(
        child: SvgPicture.asset(
          'assets/logo.svg',
          width: 240,
          height: 240,
        ),
      ),
    );
  }
}

//! TO Do :
// gambar svg delay, mungkin  device saya kurang mumpuni