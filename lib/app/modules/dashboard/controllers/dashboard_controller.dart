import 'package:get/get.dart';
import '../../../data/repositories/dummy_data.dart';

class DashboardController extends GetxController {
  final totalTamu = 0.obs;
  final tamuHadir = 0.obs;
  final tamuSudahCheckIn = 0.obs;
  final totalVendor = 0.obs;
  final totalBooking = 0.obs;

  final weeklyData = <double>[12, 25, 18, 35, 28, 42, 38].obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  void _loadStats() {
    final guests = DummyData.sampleGuests;
    totalTamu.value = guests.length;
    tamuHadir.value = guests.where((g) => g.hadir).length;
    tamuSudahCheckIn.value = guests.where((g) => g.checkedIn).length;
    totalVendor.value = DummyData.vendors.length;
    totalBooking.value = 3;
  }
}
