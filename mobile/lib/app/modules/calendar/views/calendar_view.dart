import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F8),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFFFDF8F8)),
            child: Stack(
              children: [
                // --- Konten Utama ---
                Container(
                  width: double.infinity,
                  // Padding bottom disesuaikan
                  padding: const EdgeInsets.only(top: 100, bottom: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(minWidth: 64),
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 12, left: 16.89, right: 16.91, bottom: 12),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0x33C8C5CB)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          shadows: const [
                                            BoxShadow(color: Color(0x0CA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 28.20,
                                                  height: 16,
                                                  child: Text('WED', style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.19,
                                                  height: 28,
                                                  child: Text('23', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(minWidth: 64),
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 12, left: 19.66, right: 19.65, bottom: 12),
                                        decoration: ShapeDecoration(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          shadows: const [
                                            BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 23.75,
                                                  height: 16,
                                                  child: Text('THU', style: TextStyle(color: Colors.white.withValues(alpha: 0.80), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                                ),
                                              ],
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.69,
                                                  height: 28,
                                                  child: Text('24', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(minWidth: 64),
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 12, left: 18.86, right: 18.87, bottom: 12),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0x33C8C5CB)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          shadows: const [
                                            BoxShadow(color: Color(0x0CA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 18.13,
                                                  height: 16,
                                                  child: Text('FRI', style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 24.27,
                                                  height: 28,
                                                  child: Text('25', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(minWidth: 64),
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 12, left: 19, right: 19.02, bottom: 12),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0x33C8C5CB)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          shadows: const [
                                            BoxShadow(color: Color(0x0CA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 21.80,
                                                  height: 16,
                                                  child: Text('SAT', style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 23.98,
                                                  height: 28,
                                                  child: Text('26', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(minWidth: 64),
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 12, left: 18.41, right: 18.40, bottom: 12),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFBBF246),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0x33C8C5CB)),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          shadows: const [
                                            BoxShadow(color: Color(0x0CA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0),
                                          ],
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 25.19,
                                                  height: 16,
                                                  child: Text('SUN', style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 23.05,
                                                  height: 28,
                                                  child: Text('27', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Icon(Icons.wb_sunny_outlined, color: Color(0xFFBBF246), size: 24)],
                                  ),
                                  SizedBox(
                                    width: 79.23,
                                    height: 28,
                                    child: Text('Morning', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 44,
                                    top: 16,
                                    bottom: 0,
                                    child: Container(
                                      width: 2,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFE5E2E1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    spacing: 16,
                                    children: [
                                      Opacity(
                                        opacity: 0.60,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: ShapeDecoration(
                                            color: Colors.white.withValues(alpha: 0.50),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(width: 1, color: Color(0x33C8C5CB)),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            spacing: 16,
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xFFE5E2E1),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                                                ),
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [Icon(Icons.check_circle, color: Color(0xFF8C8B90), size: 24)],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Blood Pressure Check', style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, decoration: TextDecoration.lineThrough, height: 1.43, letterSpacing: 0.14)),
                                                    Text('Systolic / Diastolic', style: TextStyle(color: Color(0xCC47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, height: 1.43)),
                                                  ],
                                                ),
                                              ),
                                              const Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text('07:30', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                  Text('AM', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          shadows: const [BoxShadow(color: Color(0x1EA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0)],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 16,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: ShapeDecoration(color: const Color(0xFFE3E1EC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Icon(Icons.medication_outlined, color: Color(0xFF1C1B1C), size: 24)],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Morning Medication', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                  Text('Aspirin & Vitamins, with food', style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, height: 1.43)),
                                                ],
                                              ),
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('08:00', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                Text('AM', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          shadows: const [BoxShadow(color: Color(0x1EA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0)],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 16,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: ShapeDecoration(color: const Color(0xFFE3E1EC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Icon(Icons.directions_walk, color: Color(0xFF1C1B1C), size: 24)],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Physical Therapy', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                  Text('Light stretching', style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, height: 1.43)),
                                                ],
                                              ),
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('10:30', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                Text('AM', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Icon(Icons.wb_sunny_outlined, color: Color(0xFFBBF246), size: 24)],
                                  ),
                                  SizedBox(
                                    width: 98.84,
                                    height: 28,
                                    child: Text('Afternoon', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 44,
                                    top: 16,
                                    bottom: 0,
                                    child: Container(
                                      width: 2,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFE5E2E1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    spacing: 16,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          shadows: const [BoxShadow(color: Color(0x1EA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0)],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 16,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: ShapeDecoration(color: const Color(0xFFE3E1EC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Icon(Icons.restaurant, color: Color(0xFF1C1B1C), size: 24)],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Lunch & Hydration', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                  Text('Record fluid intake', style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, height: 1.43)),
                                                ],
                                              ),
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('01:00', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                Text('PM', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          shadows: const [BoxShadow(color: Color(0x1EA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0)],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 16,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: ShapeDecoration(color: const Color(0xFFE3E1EC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Icon(Icons.people_alt_outlined, color: Color(0xFF1C1B1C), size: 24)],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Family Visit', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                  Text('Sarah coming over', style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, height: 1.43)),
                                                ],
                                              ),
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('03:30', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                Text('PM', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Icon(Icons.nightlight_round_outlined, color: Color(0xFFBBF246), size: 24)],
                                  ),
                                  SizedBox(
                                    width: 76.53,
                                    height: 28,
                                    child: Text('Evening', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 20, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.40)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 44,
                                    top: 16,
                                    bottom: 0,
                                    child: Container(
                                      width: 2,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFE5E2E1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    spacing: 16,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          shadows: const [BoxShadow(color: Color(0x1EA1A1AA), blurRadius: 16, offset: Offset(0, 4), spreadRadius: 0)],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 16,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: ShapeDecoration(color: const Color(0xFFE3E1EC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Icon(Icons.dark_mode_outlined, color: Color(0xFF1C1B1C), size: 24)],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Evening Wind Down', style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                  Text('Read chapter, dim lights', style: TextStyle(color: Color(0xFF47464B), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w400, height: 1.43)),
                                                ],
                                              ),
                                            ),
                                            const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('08:00', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF1C1B1C), fontSize: 14, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w500, height: 1.43, letterSpacing: 0.14)),
                                                Text('PM', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFF47464B), fontSize: 12, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // --- Top App Bar Custom ---
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(top: 32, left: 20, right: 20, bottom: 16),
                    decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  image: const DecorationImage(image: NetworkImage("https://placehold.co/40x40"), fit: BoxFit.fill),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 32,
                              child: Text('CareTrack', style: TextStyle(color: Color(0xFF18181B), fontSize: 24, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600, height: 1.33, letterSpacing: -0.60)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999))),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Icon(Icons.notifications_outlined, color: Colors.black)],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
      // Floating Action Button (+)
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 25,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Custom Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: ShapeDecoration(
            color: const Color(0xFF192126),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, "Home"),
                _buildNavItem(1, Icons.calendar_today_outlined, "Calendar"),
                _buildNavItem(2, Icons.medical_services_outlined, "medical"),
                _buildNavItem(3, Icons.person_outline, "Person"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBBF246) : Colors.transparent,
          borderRadius: BorderRadius.circular(43),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF192126) : Colors.white70,
              size: 24,
            ),
            if (isSelected && label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF192126),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}