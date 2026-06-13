import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.80),
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F4), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Data Kesehatan',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Header Profile Info
              Obx(
                () => Text(
                  controller.patientName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    letterSpacing: -0.64,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Obx(
                    () => Text(
                      '${controller.patientAge} • ${controller.patientGender}',
                      style: const TextStyle(
                        color: Color(0xFF4C4546),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFBBF246),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF536250),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'NORMAL',
                          style: TextStyle(
                            color: Color(0xFF576755),
                            fontSize: 12,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Health Trend Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 28,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFFAFAF9)),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 40,
                      offset: Offset(0, 20),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tren Kesehatan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                            letterSpacing: -0.24,
                          ),
                        ),
                        Obx(
                          () => Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedTrendFilter,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF1C1917),
                                  fontSize: 12,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedTrendFilter = newValue;
                                  }
                                },
                                items: <String>['7 Hari', '30 Hari']
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        'Stabilitas fisik keseluruhan selama ${controller.selectedTrendFilter}',
                        style: const TextStyle(
                          color: Color(0xFF4C4546),
                          fontSize: 14,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1.43,
                          letterSpacing: 0.14,
                        ),
                      ),
                    ),
                    // ── Trend Chart ──
                    const SizedBox(height: 16),
                    // Parameter selector
                    Row(
                      children: [
                        Obx(() {
                          final params = controller.availableParams;
                          final selected = controller.selectedTrendParam;
                          if (params.isEmpty) return const SizedBox.shrink();
                          return Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: params.contains(selected)
                                    ? selected
                                    : params.first,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF1C1917),
                                  fontSize: 12,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.selectedTrendParam = newValue;
                                  }
                                },
                                items: params.map<DropdownMenuItem<String>>((
                                  String value,
                                ) {
                                  final label = DashboardController
                                      .trendParamLabels[value];
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(label ?? value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }),
                        const Spacer(),
                        Obx(() {
                          final label = DashboardController
                              .trendParamLabels[controller.selectedTrendParam];
                          return Text(
                            label ?? 'Gula Darah',
                            style: const TextStyle(
                              color: Color(0xFF4C4546),
                              fontSize: 13,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                        const SizedBox(width: 4),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Chart
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Obx(() {
                        final dataPoints = controller.trendDataPoints;
                        if (dataPoints.isEmpty) {
                          return const Center(
                            child: Text(
                              'Belum ada data tren',
                              style: TextStyle(
                                color: Color(0xFFA3A1A6),
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          );
                        }
                        return _buildTrendChart(
                          dataPoints.cast<Map<String, dynamic>>(),
                          controller.selectedTrendParam,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildAddHealthRecordButton(),
              const SizedBox(height: 32),

              // Health Metrics List
              Obx(
                () => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: controller.healthMetrics.length,
                  itemBuilder: (context, index) {
                    final metric = controller.healthMetrics[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFFAFAF9),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x07000000),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: ShapeDecoration(
                                  color: metric['color'],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    metric['icon'],
                                    color: metric['iconColor'],
                                    size: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF536250),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Flexible(
                                      child: Text(
                                        'Normal',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Color(0xFF576755),
                                          fontSize: 10,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w500,
                                          height: 1.33,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            metric['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF4C4546),
                              fontSize: 13,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                metric['value'],
                                style: const TextStyle(
                                  color: Color(0xFF1B1B1B),
                                  fontSize: 20,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  metric['unit'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF4C4546),
                                    fontSize: 10,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100), // Spacing buat BottomNav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddHealthRecordButton() {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.LOG_KESEHATAN,
          arguments: {
            'elderly_id': controller.elderlyId,
            'name': controller.patientName,
          },
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF192126),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              'Tambah Data Kesehatan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChart(List<Map<String, dynamic>> dataPoints, String param) {
    // Build spots from data
    final spots = <FlSpot>[];
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;

    for (int i = 0; i < dataPoints.length; i++) {
      final raw = dataPoints[i][param];
      final value = (raw is num)
          ? raw.toDouble()
          : double.tryParse(raw?.toString() ?? '');
      if (value != null && value.isFinite) {
        spots.add(FlSpot(i.toDouble(), value));
        if (value < minVal) minVal = value;
        if (value > maxVal) maxVal = value;
      }
    }

    if (spots.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data parameter ini',
          style: TextStyle(
            color: Color(0xFFA3A1A6),
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      );
    }

    // Add padding to range
    final range = maxVal - minVal;
    final padding = range > 0 ? range * 0.15 : 10;
    final chartMinY = (minVal - padding).clamp(0, double.infinity).toDouble();
    final chartMaxY = maxVal + padding;

    // Date labels for bottom axis
    final dateLabels = dataPoints.map((dp) {
      try {
        final d = DateTime.parse(dp['date'] as String);
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];
        return '${d.day}/${months[d.month - 1]}';
      } catch (_) {
        return '';
      }
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (chartMaxY - chartMinY) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color(0xFFA8A29E).withValues(alpha: 0.3),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: dataPoints.length > 7
                  ? (dataPoints.length / 6).ceilToDouble()
                  : 1,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= dateLabels.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    dateLabels[idx],
                    style: const TextStyle(
                      color: Color(0xFF4C4546),
                      fontSize: 10,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(bottom: BorderSide(color: Color(0xFFA8A29E))),
        ),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: chartMinY,
        maxY: chartMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: spots.length > 2,
            color: const Color(0xFFBBF246),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: spots.length > 14
                ? const FlDotData(show: false)
                : FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: const Color(0xFFBBF246),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFBBF246).withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
