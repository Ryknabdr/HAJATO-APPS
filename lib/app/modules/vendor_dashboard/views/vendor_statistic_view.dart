import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/vendor_dashboard_controller.dart';
import '../../../core/widgets/shared_widgets.dart';

class VendorStatisticView extends GetView<VendorDashboardController> {
  const VendorStatisticView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Vendor'),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            
            _TopPackageSection(),

            const SizedBox(height: 16),

            _BookingStatusChart(),

            const SizedBox(height: 16),

            _MonthlyBookingChart(),

            const SizedBox(height: 16),

            _RatingDistributionChart(),

            const SizedBox(height: 16),

            _RevenueChart(),

            const SizedBox(height: 16),


            _StatTile(
              title: 'Total Booking',
              value: '${controller.totalBooking.value}',
              icon: Icons.shopping_bag_outlined,
            ),
            _StatTile(
              title: 'Booking Selesai',
              value: '${controller.completedBooking.value}',
              icon: Icons.check_circle_outline,
            ),
            _StatTile(
              title: 'Total Pendapatan',
              value: formatRupiah(controller.totalPendapatan.value),
              icon: Icons.payments_outlined,
            ),
            _StatTile(
              title: 'Rating Vendor',
              value: '${controller.averageRating.value.toStringAsFixed(1)} ⭐',
              icon: Icons.star_outline,
            ),
            _StatTile(
              title: 'Total Ulasan',
              value: '${controller.totalReviews.value}',
              icon: Icons.reviews_outlined,
            ),
            _StatTile(
              title: 'Dana Dicairkan',
              value: formatRupiah(controller.danaDicairkan.value),
              icon: Icons.account_balance_wallet_outlined,
            ),
            _StatTile(
              title: 'Dana Ditahan',
              value: formatRupiah(controller.danaDitahan.value),
              icon: Icons.lock_clock_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _BookingStatusChart extends GetView<VendorDashboardController> {
  @override
  Widget build(BuildContext context) {
    final active = controller.totalBooking.value - controller.completedBooking.value;
    final completed = controller.completedBooking.value;

    final maxY = controller.totalBooking.value == 0
        ? 1.0
        : controller.totalBooking.value.toDouble();

    return _ChartCard(
      title: 'Grafik Status Booking',
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: active.toDouble(),
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: completed.toDouble(),
                  width: 28,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('Aktif');
                  if (value == 1) return const Text('Selesai');
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class _MonthlyBookingChart extends GetView<VendorDashboardController> {
  @override
  Widget build(BuildContext context) {
    final monthCount = List<int>.filled(12, 0);

    for (final booking in controller.bookings) {
      try {
        final date = DateTime.parse(booking.eventDate);
        monthCount[date.month - 1]++;
      } catch (_) {}
    }

    final maxValue = monthCount.isEmpty
        ? 1
        : monthCount.reduce((a, b) => a > b ? a : b);

    final maxY = maxValue == 0 ? 1.0 : maxValue.toDouble();

    return _ChartCard(
      title: 'Booking per Bulan',
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: List.generate(12, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthCount[index].toDouble(),
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                getTitlesWidget: (value, meta) {
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

                  final index = value.toInt();

                  if (index < 0 || index > 11) {
                    return const Text('');
                  }

                  return Text(
                    months[index],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class _RatingDistributionChart extends GetView<VendorDashboardController> {
  @override
  Widget build(BuildContext context) {
    final ratingCount = {
      5: 0,
      4: 0,
      3: 0,
      2: 0,
      1: 0,
    };

    for (final review in controller.reviews) {
      final rating = review.rating.toInt();

      if (ratingCount.containsKey(rating)) {
        ratingCount[rating] = ratingCount[rating]! + 1;
      }
    }

    final maxValue = ratingCount.values.isEmpty
        ? 1
        : ratingCount.values.reduce((a, b) => a > b ? a : b);

    final maxY = maxValue == 0 ? 1.0 : maxValue.toDouble();

    return _ChartCard(
      title: 'Distribusi Rating',
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: [5, 4, 3, 2, 1].map((rating) {
            return BarChartGroupData(
              x: rating,
              barRods: [
                BarChartRodData(
                  toY: ratingCount[rating]!.toDouble(),
                  width: 24,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}⭐');
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class _TopPackageSection extends GetView<VendorDashboardController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Paket Terlaris',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (controller.topPackages.isEmpty)
              const Text('Belum ada data paket')
            else
              Column(
                children: controller.topPackages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  final medal = index == 0
                      ? '🥇'
                      : index == 1
                          ? '🥈'
                          : index == 2
                              ? '🥉'
                              : '${index + 1}.';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      medal,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(
                      item.packageName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      '${item.totalBooking} Booking',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _RevenueChart extends GetView<VendorDashboardController> {
  @override
  Widget build(BuildContext context) {
    final released = controller.danaDicairkan.value.toDouble();
    final hold = controller.danaDitahan.value.toDouble();

    final total = released + hold;

    if (total == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Belum ada data dana'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribusi Dana',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 42,
                  sections: [
                    PieChartSectionData(
                      value: released,
                      title: 'Cair',
                      radius: 70,
                    ),
                    PieChartSectionData(
                      value: hold,
                      title: 'Hold',
                      radius: 70,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            _LegendRow(
              label: 'Dana Dicairkan',
              value: formatRupiah(controller.danaDicairkan.value),
            ),

            const SizedBox(height: 6),

            _LegendRow(
              label: 'Dana Ditahan',
              value: formatRupiah(controller.danaDitahan.value),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 220,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final String value;

  const _LegendRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}