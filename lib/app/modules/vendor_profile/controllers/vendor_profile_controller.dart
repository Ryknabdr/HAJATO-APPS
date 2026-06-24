import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_config.dart';

class VendorProfileController extends GetxController {
  final vendorName = ''.obs;
  final vendorEmail = ''.obs;
  final vendorStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadVendorData();
  }

  Future<void> loadVendorData() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    vendorName.value = prefs.getString('name') ?? 'Vendor';
    vendorEmail.value = prefs.getString('email') ?? '-';
    vendorStatus.value = prefs.getString('vendor_status') ?? 'pending';

    if (token == null || token.isEmpty) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/vendor/my-data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('VENDOR PROFILE DATA STATUS: ${response.statusCode}');
      print('VENDOR PROFILE DATA BODY: ${response.body}');

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = result['data'] ?? {};

        final latestOwnerName = data['owner_name'] ?? vendorName.value;
        final latestStatus = data['status'] ?? vendorStatus.value;

        vendorName.value = latestOwnerName;
        vendorStatus.value = latestStatus;

        await prefs.setString('name', latestOwnerName);
        await prefs.setString('owner_name', latestOwnerName);
        await prefs.setString('vendor_status', latestStatus);
      }
    } catch (e) {
      print('LOAD VENDOR PROFILE ERROR: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    try {
      if (token != null && token.isNotEmpty) {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/api/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('VENDOR LOGOUT STATUS: ${response.statusCode}');
        print('VENDOR LOGOUT BODY: ${response.body}');
      }
    } catch (e) {
      print('VENDOR LOGOUT ERROR: $e');
    }

    await prefs.clear();

    Get.offAllNamed('/login');
  }
}