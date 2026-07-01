import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambah ini
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  await initializeDateFormatting('id', null);

  // --- LOGIKA CEK LOGIN & ROLE ---
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String role = prefs.getString('role') ?? ''; // Ambil role yang sudah disimpan saat login
  
  // Tentukan route awal berdasarkan status login DAN role
  String initialRoute = AppRoutes.onboarding; 
  
  if (isLoggedIn) {
    if (role == 'admin') {
      initialRoute = AppRoutes.dashboard;
    } else if (role == 'vendor' || role == 'vendor_pending') {
      initialRoute = AppRoutes.vendorDashboard;
    } else {
      initialRoute = AppRoutes.home;
    }
  } else {
    initialRoute = AppRoutes.onboarding;
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(HajatoApp(initialRoute: initialRoute)); // Kirim route ke app
}

class HajatoApp extends StatelessWidget {
  final String initialRoute;
  const HajatoApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HAJATO - Hajatan Organizer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: initialRoute, // Pakai hasil cek tadi
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
      locale: const Locale('id', 'ID'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}