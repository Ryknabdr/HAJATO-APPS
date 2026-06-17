import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/vendor_dashboard_controller.dart';
import '../../../core/widgets/shared_widgets.dart';

class VendorScheduleView extends StatefulWidget {
  const VendorScheduleView({super.key});

  @override
  State<VendorScheduleView> createState() =>
      _VendorScheduleViewState();
}

class _VendorScheduleViewState extends State<VendorScheduleView> {
  final controller = Get.find<VendorDashboardController>();

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Acara'),
      ),
      body: Obx(
        () {
          if (controller.schedules.isEmpty) {
            return const Center(
              child: Text('Belum ada jadwal acara'),
            );
          }

          final selectedSchedules = controller.schedules.where((item) {
            final date = DateTime.parse(item.eventDate);

            return date.year == selectedDay.year &&
                date.month == selectedDay.month &&
                date.day == selectedDay.day;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TableCalendar(
                  firstDay: DateTime(2025),
                  lastDay: DateTime(2030),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                      focusedDay = focused;
                    });
                  },
                  eventLoader: (day) {
                    return controller.schedules.where((item) {
                      final date = DateTime.parse(item.eventDate);

                      return date.year == day.year &&
                          date.month == day.month &&
                          date.day == day.day;
                    }).toList();
                  },
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                selectedSchedules.isEmpty
                    ? 'Jadwal Hari Ini'
                    : 'Acara Pada ${_formatDate(selectedDay.toString())}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              if (selectedSchedules.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Tidak ada jadwal booking di tanggal ini'),
                  ),
                )
              else
                ...selectedSchedules.map((item) {
                  return _ScheduleCard(item: item);
                }).toList(),

              const SizedBox(height: 20),

              const Text(
                'Semua Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ...controller.schedules.map((item) {
                return _ScheduleCard(item: item);
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final dynamic item;

  const _ScheduleCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal.withOpacity(0.12),
              child: const Icon(
                Icons.event,
                color: Colors.teal,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.packageName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _formatDate(item.eventDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text('Jam: ${item.eventTime}'),
                  Text('Customer: ${item.customerName}'),
                  Text('Lokasi: ${item.location}'),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatRupiah(item.totalPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      _StatusBadge(
                        label: _statusText(item.bookingStatus),
                        color: _statusColor(item.bookingStatus),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);

    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  } catch (e) {
    return dateString;
  }
}

String _statusText(String status) {
  switch (status) {
    case 'confirmed':
      return 'Dikonfirmasi';
    case 'completed':
      return 'Selesai';
    case 'pending_payment':
      return 'Menunggu';
    default:
      return status;
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'confirmed':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    case 'pending_payment':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}