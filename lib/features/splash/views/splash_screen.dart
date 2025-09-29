import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nestup/core/theme/app_colors.dart';
import 'package:nestup/features/home/views/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _mottoController;

  String _motto = "";
  final String _fullMotto = "Find your next stay, simple and seamless.";

  @override
  void initState() {
    super.initState();

    // Logo ripple effect (scale + fade)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    // Title slide from top
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Motto typewriter fade
    _mottoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      _titleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 2200), () {
      _mottoController.forward();
      _startTypewriter();
    });

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  void _startTypewriter() {
    int i = 0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (i < _fullMotto.length) {
        setState(() {
          _motto += _fullMotto[i];
        });
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _mottoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rippleScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    final rippleFade = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    final titleSlide = Tween<Offset>(
      begin: const Offset(0, -1), // from top
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeOut));

    return Scaffold(
      backgroundColor: AppColors.neutral,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ripple
            FadeTransition(
              opacity: rippleFade,
              child: ScaleTransition(
                scale: rippleScale,
                child: Image.asset(
                  'assets/images/app-logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title slide from top
            SlideTransition(
              position: titleSlide,
              child: Text(
                'NestUp',
                style: GoogleFonts.nunito(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Motto typewriter
            FadeTransition(
              opacity: _mottoController,
              child: Text(
                _motto,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.brandPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
