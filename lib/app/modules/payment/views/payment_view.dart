import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/payment_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/shared_widgets.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HajatAppBar(title: 'Pembayaran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(),
            const SizedBox(height: 20),
            _buildMethodSelector(),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.selectedMethod.value == 'transfer') return _buildBankList();
              if (controller.selectedMethod.value == 'ewallet') return _buildEwalletList();
              return const SizedBox.shrink();
            }),
            Obx(() {
              if (controller.selectedMethod.value.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTotalSection(),
                  const SizedBox(height: 28),
                  Obx(() => GradientButton(
                        label: controller.isLoading.value ? 'Memproses...' : 'Bayar Sekarang',
                        onTap: controller.isLoading.value ? () {} : controller.pay,
                        icon: Icons.payment_rounded,
                      )),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Pesanan',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _SummaryRow(label: 'Vendor', value: controller.vendor.name),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Paket', value: controller.package.name),
          const SizedBox(height: 6),
          _SummaryRow(label: 'Tanggal', value: controller.formattedDate),
          if (controller.notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            _SummaryRow(label: 'Catatan', value: controller.notes),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodSelector() {
    final methods = [
      {'id': 'transfer', 'label': 'Transfer Bank', 'icon': Icons.account_balance_rounded},
      {'id': 'ewallet', 'label': 'E-Wallet', 'icon': Icons.wallet_rounded},
      {'id': 'cod', 'label': 'Bayar di Tempat', 'icon': Icons.handshake_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Metode Pembayaran',
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: methods.map((m) {
            return Expanded(
              child: Obx(() {
                final isSelected = controller.selectedMethod.value == m['id'];
                return GestureDetector(
                  onTap: () => controller.selectMethod(m['id'] as String),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.textHint.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(m['icon'] as IconData,
                            color: isSelected ? Colors.white : AppColors.textHint, size: 22),
                        const SizedBox(height: 4),
                        Text(m['label'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            )),
                      ],
                    ),
                  ),
                );
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBankList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih Bank',
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ...controller.banks.map((bank) => Obx(() {
              final isSelected = controller.selectedBank.value == bank['id'];
              return GestureDetector(
                onTap: () => controller.selectedBank.value = bank['id'] as String,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.textHint.withOpacity(0.3),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.textHint.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(bank['logo'] as String, style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bank['label'] as String,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Text('No. Rek: ${bank['account']}',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                        ),
                    ],
                  ),
                ),
              );
            })),
      ],
    );
  }

  Widget _buildEwalletList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pilih E-Wallet',
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: controller.ewallets.map((ew) => Obx(() {
                final isSelected = controller.selectedEwallet.value == ew['id'];
                return GestureDetector(
                  onTap: () => controller.selectedEwallet.value = ew['id'] as String,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.textHint.withOpacity(0.3),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(ew['logo'] as String, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(ew['label'] as String,
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, fontWeight: FontWeight.w600)),
                              Text(ew['number'] as String,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary, size: 16),
                      ],
                    ),
                  ),
                );
              })).toList(),
        ),
      ],
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Pembayaran',
              style: GoogleFonts.poppins(
                  color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          Text(controller.formattedPrice,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
        ),
        Text(': ', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary)),
        Expanded(
          child: Text(value,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}