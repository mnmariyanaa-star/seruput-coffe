import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding_product.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const Color navy = Color(0xFF34327E);
  static const Color cream = Color(0xFFFFFAF6);

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingProduct(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bool layarKecil = constraints.maxHeight < 760;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo_seruput.png',
                              width: layarKecil ? 220 : 270,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.local_cafe_rounded,
                                  color: navy,
                                  size: 120,
                                );
                              },
                            ),

                            SizedBox(height: layarKecil ? 32 : 50),

                            SizedBox(
                              width: layarKecil ? 34 : 42,
                              height: layarKecil ? 34 : 42,
                              child: CircularProgressIndicator(
                                color: navy,
                                strokeWidth: 3,
                                backgroundColor: navy.withOpacity(0.12),
                              ),
                            ),

                            SizedBox(height: layarKecil ? 12 : 16),

                            Text(
                              'Menyiapkan menu terbaik...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy.withOpacity(0.65),
                                fontSize: layarKecil ? 13 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
