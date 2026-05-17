import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';

class PromoModel {
  final String id;
  final String title;
  final String subtitle;
  final String discount;
  final String validUntil;
  final String category;
  final Color color;
  final IconData icon;
  final bool isNew;

  PromoModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.validUntil,
    required this.category,
    required this.color,
    required this.icon,
    this.isNew = false,
  });
}

class PromoController extends GetxController {
  final isLoading = false.obs;
  final selectedCategory = 'Semua'.obs;
  final RxList<PromoModel> allPromos = <PromoModel>[].obs;
  final RxList<PromoModel> filteredPromos = <PromoModel>[].obs;

  final categories = [
    'Semua',
    'Fotografer',
    'Catering',
    'Dekorasi',
    'WO',
    'Sound'
  ];

  @override
  void onInit() {
    super.onInit();
    loadPromos();
  }

  void loadPromos() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      allPromos.assignAll([
        PromoModel(
          id: '1',
          title: 'Diskon Fotografer',
          subtitle: 'Abadikan momen spesialmu dengan harga terbaik',
          discount: '20%',
          validUntil: '30 Apr 2026',
          category: 'Fotografer',
          color: AppColors.primaryLight,
          icon: Icons.photo_camera_rounded,
          isNew: true,
        ),
        PromoModel(
          id: '2',
          title: 'Promo Catering Spesial',
          subtitle: 'Nikmati sajian lezat untuk 100 tamu',
          discount: '15%',
          validUntil: '25 Apr 2026',
          category: 'Catering',
          color: AppColors.success,
          icon: Icons.restaurant_rounded,
        ),
        PromoModel(
          id: '3',
          title: 'Dekorasi Impian',
          subtitle: 'Wujudkan dekorasi pernikahan impianmu',
          discount: '25%',
          validUntil: '15 Mei 2026',
          category: 'Dekorasi',
          color: AppColors.info,
          icon: Icons.park_rounded,
          isNew: true,
        ),
        PromoModel(
          id: '4',
          title: 'Paket Wedding Organizer',
          subtitle: 'Urus semua persiapan pernikahanmu',
          discount: '10%',
          validUntil: '20 Mei 2026',
          category: 'WO',
          color: AppColors.accent,
          icon: Icons.favorite_rounded,
        ),
        PromoModel(
          id: '5',
          title: 'Sound System Premium',
          subtitle: 'Musik terbaik untuk acara tak terlupakan',
          discount: '30%',
          validUntil: '10 Mei 2026',
          category: 'Sound',
          color: AppColors.secondary,
          icon: Icons.music_note_rounded,
          isNew: true,
        ),
        PromoModel(
          id: '6',
          title: 'Promo Makeup Artist',
          subtitle: 'Tampil cantik di hari spesialmu',
          discount: '20%',
          validUntil: '28 Apr 2026',
          category: 'Fotografer',
          color: AppColors.warning,
          icon: Icons.face_retouching_natural,
        ),
      ]);
      filteredPromos.assignAll(allPromos);
      isLoading.value = false;
    });
  }

  void filterByCategory(String cat) {
    selectedCategory.value = cat;
    if (cat == 'Semua') {
      filteredPromos.assignAll(allPromos);
    } else {
      filteredPromos
          .assignAll(allPromos.where((p) => p.category == cat).toList());
    }
  }

  void claimPromo(PromoModel promo) {
    Get.snackbar(
      '🎉 Promo Diklaim!',
      '${promo.discount} off untuk ${promo.title} berhasil diklaim',
      backgroundColor: AppColors.primaryDark,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}