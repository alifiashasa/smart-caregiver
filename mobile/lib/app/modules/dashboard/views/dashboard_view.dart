import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final pagePadding = AppTheme.pagePadding(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Data Kesehatan'),
        backgroundColor: AppTheme.background,
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async {
            await controller.loadLatestHealthRecord();
            await controller.loadTrends();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(pagePadding, 24, pagePadding, 112),
            children: [
              _buildPatientHero(context),
              const SizedBox(height: 18),
              _buildTrendCard(context),
              const SizedBox(height: 16),
              _buildAddHealthRecordButton(context),
              const SizedBox(height: 28),
              _buildMetricsHeader(context),
              const SizedBox(height: 14),
              _buildMetricsGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHero(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              final initials = controller.patientName.isNotEmpty
                  ? controller.patientName.trim().split(' ').take(2)
                      .map((w) => w[0].toUpperCase())
                      .join()
                  : '?';
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.accentSoft,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: textTheme.titleSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.patientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text(
                      '${controller.patientAge} - ${controller.patientGender}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Normal',
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildTrendCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tren Kesehatan',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            Obx(
              () => _buildSegmentedTabs(
                context: context,
                value: controller.selectedTrendFilter,
                items: const ['7 Hari', '30 Hari'],
                onChanged: (value) => controller.selectedTrendFilter = value,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final params = controller.availableParams;
          final selected = controller.selectedTrendParam;
          if (params.isEmpty) {
            return Text(
              'Gula Darah',
              style: textTheme.labelSmall?.copyWith(
                color: AppTheme.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            );
          }
          return _buildParameterTabs(
            context: context,
            value: params.contains(selected) ? selected : params.first,
            items: params,
            onChanged: (value) => controller.selectedTrendParam = value,
          );
        }),
        const SizedBox(height: 14),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Obx(() {
            if (controller.isLoading && controller.trendDataPoints.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final dataPoints = controller.trendDataPoints;
            if (dataPoints.isEmpty) return _buildChartEmptyState(context);
            return _buildTrendChart(
              dataPoints.cast<Map<String, dynamic>>(),
              controller.selectedTrendParam,
            );
          }),
        ),
      ],
    );
  }
  Widget _buildSegmentedTabs({
    required BuildContext context,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final selected = item == value;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => onChanged(item),
              child: AnimatedContainer(
                duration: AppTheme.motionFast,
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item,
                  style: textTheme.labelLarge?.copyWith(
                    color: selected ? AppTheme.primary : AppTheme.textTertiary,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildParameterTabs({
    required BuildContext context,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: items.map((item) {
          final selected = item == value;
          final label = DashboardController.trendParamLabels[item] ?? item;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(item),
                child: AnimatedContainer(
                  duration: AppTheme.motionFast,
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primary : AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: selected ? Colors.white : AppTheme.textTertiary,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChartEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppTheme.textTertiary,
                size: 34,
              ),
              const SizedBox(height: 10),
              Text(
                'Belum ada data tren',
                style: textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                'Catat data kesehatan untuk melihat grafik perkembangan.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddHealthRecordButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.toNamed(
          Routes.LOG_KESEHATAN,
          arguments: {
            'elderly_id': controller.elderlyId,
            'name': controller.patientName,
          },
        );
      },
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('Tambah Data Kesehatan'),
    );
  }

  Widget _buildMetricsHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tanda Vital Terakhir', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Ringkasan hasil pemeriksaan terbaru.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.accentSoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Normal',
            style: textTheme.labelMedium?.copyWith(color: AppTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 720 ? 4 : 2;
        return Obx(() {
          final metrics = controller.healthMetrics;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: crossAxisCount == 4 ? 1.25 : 1.05,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return _buildMetricCard(context, metric);
            },
          );
        });
      },
    );
  }

  Widget _buildMetricCard(BuildContext context, Map<String, dynamic> metric) {
    final textTheme = Theme.of(context).textTheme;
    final color = metric['color'] as Color? ?? AppTheme.surfaceMuted;
    final icon =
        metric['icon'] as IconData? ?? Icons.health_and_safety_outlined;
    final iconColor = metric['iconColor'] as Color? ?? AppTheme.primary;
    final value = metric['value']?.toString() ?? '-';
    final unit = metric['unit']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            metric['title']?.toString() ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelLarge?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall?.copyWith(fontSize: 22),
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 5),
                Text(
                  unit,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(List<Map<String, dynamic>> dataPoints, String param) {
    final spots = <FlSpot>[];
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;

    for (var i = 0; i < dataPoints.length; i++) {
      final raw = dataPoints[i][param];
      final value = raw is num
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
          style: TextStyle(color: AppTheme.textTertiary),
        ),
      );
    }

    final range = maxVal - minVal;
    final padding = range > 0 ? range * 0.15 : 10;
    final chartMinY = (minVal - padding).clamp(0, double.infinity).toDouble();
    final chartMaxY = maxVal + padding;
    final dateLabels = dataPoints.map((point) {
      try {
        final date = DateTime.parse(point['date'] as String);
        const months = [
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
        return '${date.day}/${months[date.month - 1]}';
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
              color: AppTheme.borderStrong.withValues(alpha: 0.32),
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
              reservedSize: 32,
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
                      color: AppTheme.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: AppTheme.borderStrong),
          ),
        ),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: chartMinY,
        maxY: chartMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: spots.length > 2,
            color: AppTheme.accent,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: spots.length > 14
                ? const FlDotData(show: false)
                : FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.accent,
                        strokeWidth: 2,
                        strokeColor: AppTheme.primary,
                      );
                    },
                  ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.accent.withValues(alpha: 0.18),
            ),
          ),
        ],
      ),
    );
  }
}
