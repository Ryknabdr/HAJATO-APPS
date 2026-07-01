import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart'; 
import '../../../routes/app_routes.dart';

class TemplateSelectionView extends StatelessWidget {
  const TemplateSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "Pilih Tema Undangan",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Silakan pilih gaya dan tema desain undangan digital untuk acara Anda:",
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.75,
                children: [
                  _buildTemplateCard(controller: controller, templateId: 'template_1', title: "Premium Gold", desc: "Nuansa mewah & klasik", colorTheme: const Color(0xFFC9A96E)),
                  _buildTemplateCard(controller: controller, templateId: 'template_2', title: "Rustic Elegant", desc: "Tema alam & estetika modern", colorTheme: const Color(0xFF5D6B54)),
                  _buildTemplateCard(controller: controller, templateId: 'template_3', title: "Navy Bliss", desc: "Nuansa biru malam yang elegan", colorTheme: const Color(0xFF1E3A8A)),
                  _buildTemplateCard(controller: controller, templateId: 'template_4', title: "Rose Blossom", desc: "Desain romantis warna merah muda", colorTheme: const Color(0xFFEC4899)),
                  _buildTemplateCard(controller: controller, templateId: 'template_5', title: "Emerald Forest", desc: "Hijau zamrud mewah & royal", colorTheme: const Color(0xFF065F46)),
                  _buildTemplateCard(controller: controller, templateId: 'template_6', title: "Maroon Majesty", desc: "Kombinasi merah marun & emas", colorTheme: const Color(0xFF7F1D1D)),
                  _buildTemplateCard(controller: controller, templateId: 'template_7', title: "Minimalist Grey", desc: "Gaya modern, bersih, & simpel", colorTheme: const Color(0xFF6B7280)),
                  _buildTemplateCard(controller: controller, templateId: 'template_8', title: "Vintage Sepia", desc: "Estetika jadul dan hangat", colorTheme: const Color(0xFF78350F)),
                  _buildTemplateCard(controller: controller, templateId: 'template_9', title: "Orchid Purple", desc: "Sentuhan ungu anggun & magis", colorTheme: const Color(0xFF6D28D9)),
                  _buildTemplateCard(controller: controller, templateId: 'template_10', title: "Tropical Vibes", desc: "Nuansa ceria dengan elemen daun", colorTheme: const Color(0xFF047857)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard({
    required EventController controller,
    required String templateId,
    required String title,
    required String desc,
    required Color colorTheme,
  }) {
    return Obx(() {
      final isSelected = controller.selectedTemplate.value == templateId;
      return GestureDetector(
        onTap: () {
          // ── 🟢 FIX TOTAL: Set langsung ke RxString controller, lalu kembali mundur bawaan stack Get.back() ──
          controller.selectedTemplate.value = templateId;
          Get.back(); 
          
          Get.snackbar('Tema Terpilih', '$title berhasil diterapkan ke form.',
              snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFF10B981), colorText: Colors.white, duration: const Duration(seconds: 1));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F6AF5) : Colors.transparent,
              width: 2.5, // Ditebalkan sedikit biar border menyala lebih kelihatan premium
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? const Color(0xFF4F6AF5).withOpacity(0.1) : Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorTheme.withOpacity(0.15),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: Center(
                    child: Icon(
                      isSelected ? Icons.stars_rounded : Icons.star_border_rounded, 
                      size: 40, 
                      color: colorTheme
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(fontSize: 11, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}