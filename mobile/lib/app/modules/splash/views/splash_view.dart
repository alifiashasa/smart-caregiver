import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Reverting to MediaQuery as it's more reliable for the first frame's build
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dark Blue Top Background with Curve (Original Layout Restored)
          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.5,
            right: -size.width * 0.5,
            height: size.height * 0.6,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF192126), // Dark blue background
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(800), // Very wide curve
                ),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // Spacer to position the logo on the curve's edge (Original Spacing Restored)
              SizedBox(
                height: (size.height * 0.5 - 60).clamp(0.0, double.infinity),
              ),

              // Logo in a white circle
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.eco, size: 60, color: Color(0xFFBBF246)),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Brand Name
              const Text(
                'CareTrack',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1B1B),
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 16),

              // Tagline
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Pantau pasien, kelola perawatan dengan tenang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4C4546),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
