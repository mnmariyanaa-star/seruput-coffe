import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pilih_akses_screen.dart';

class OnboardingExperience extends StatelessWidget {
  const OnboardingExperience({super.key});

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  void _goToPilihAkses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PilihAksesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/onboarding_experience.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: navy,
                        size: 80,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.10,
                left: 0,
                right: 0,
                child: Text(
                  'Seruput',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: navy,
                    fontSize: 58,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.18,
                left: 0,
                right: 0,
                child: Text(
                  'Sempurnakan Momenmu',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 42,
                right: 42,
                bottom: 68,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      _goToPilihAkses(context);
                    },
                    child: const Text(
                      'Mulai Pesan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}