import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/vendor_data_controller.dart';

class VendorDataView extends GetView<VendorDataController> {
  const VendorDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Data Vendor',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
        ),
        actions: [
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox.shrink();
            }

            return IconButton(
              onPressed: () {
                controller.prepareEditForm();
                Get.bottomSheet(
                  _EditVendorBottomSheet(controller: controller),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              icon: Icon(
                Icons.edit_rounded,
                color: AppColors.primary,
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchVendorData,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
            children: [
              _VendorHeaderCard(controller: controller),

              const SizedBox(height: 16),

              _MainEditButton(controller: controller),

              const SizedBox(height: 18),

              _SectionTitle(title: 'Informasi Usaha'),

              const SizedBox(height: 10),

              _InfoCard(
                children: [
                  _InfoRow(
                    icon: Icons.storefront_rounded,
                    label: 'Nama Usaha',
                    value: controller.businessName.value,
                  ),
                  _InfoRow(
                    icon: Icons.category_rounded,
                    label: 'Kategori',
                    value: controller.category.value,
                  ),
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    label: 'Lokasi',
                    value: controller.location.value,
                  ),
                  _InfoRow(
                    icon: Icons.phone_rounded,
                    label: 'Nomor HP',
                    value: controller.phone.value,
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _SectionTitle(title: 'Deskripsi Usaha'),

              const SizedBox(height: 10),

              _DescriptionCard(
                description: controller.description.value,
              ),

              const SizedBox(height: 18),

              _SectionTitle(title: 'Informasi Pemilik'),

              const SizedBox(height: 10),

              _InfoCard(
                children: [
                  _InfoRow(
                    icon: Icons.person_rounded,
                    label: 'Nama Pemilik',
                    value: controller.ownerName.value,
                  ),
                  _InfoRow(
                    icon: Icons.badge_rounded,
                    label: 'NIK',
                    value: controller.nik.value,
                  ),
                  _InfoRow(
                    icon: Icons.article_rounded,
                    label: 'NPWP',
                    value: controller.npwp.value,
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _SectionTitle(title: 'Dokumen Verifikasi'),

              const SizedBox(height: 10),

              _DocumentCard(
                children: [
                  _DocumentRow(
                    title: 'Foto KTP',
                    filename: controller.ktpImage.value,
                    imageUrl: controller.getImageUrl(controller.ktpImage.value),
                  ),
                  _DocumentRow(
                    title: 'Foto Selfie',
                    filename: controller.selfieImage.value,
                    imageUrl:
                        controller.getImageUrl(controller.selfieImage.value),
                  ),
                  _DocumentRow(
                    title: 'Surat Izin Usaha',
                    filename: controller.businessLicense.value,
                    imageUrl: controller.getImageUrl(
                      controller.businessLicense.value,
                    ),
                    isLast: true,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _SectionTitle(title: 'Informasi Sistem'),

              const SizedBox(height: 10),

              _InfoCard(
                children: [
                  _InfoRow(
                    icon: Icons.verified_rounded,
                    label: 'Status Vendor',
                    value: controller.getStatusText(),
                  ),
                  _InfoRow(
                    icon: Icons.calendar_month_rounded,
                    label: 'Tanggal Registrasi',
                    value: controller.createdAt.value,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _VendorHeaderCard extends StatelessWidget {
  final VendorDataController controller;

  const _VendorHeaderCard({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final status = controller.status.value;

    Color statusBg;
    Color statusColor;
    IconData statusIcon;

    if (status == 'approved') {
      statusBg = const Color.fromARGB(255, 0, 255, 9).withOpacity(0.12);
      statusColor = const Color.fromARGB(255, 255, 255, 255);
      statusIcon = Icons.verified_rounded;
    } else if (status == 'rejected') {
      statusBg = Colors.red.withOpacity(0.12);
      statusColor = Colors.red;
      statusIcon = Icons.cancel_rounded;
    } else {
      statusBg = Colors.orange.withOpacity(0.12);
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_top_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.businessName.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.category.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Colors.white.withOpacity(0.9),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        controller.location.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.getStatusText(),
                      style: GoogleFonts.poppins(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainEditButton extends StatelessWidget {
  final VendorDataController controller;

  const _MainEditButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          controller.prepareEditForm();

          Get.bottomSheet(
            _EditVendorBottomSheet(controller: controller),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        icon: const Icon(Icons.edit_rounded),
        label: Text(
          'Edit Data Vendor',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.primary.withOpacity(0.18),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final cleanValue =
        value.isEmpty || value == 'null' || value == '-' ? '-' : value;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.grey.shade100,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  cleanValue,
                  style: GoogleFonts.poppins(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cleanDescription =
        description.isEmpty || description == 'null' || description == '-'
            ? 'Belum ada deskripsi usaha.'
            : description;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        cleanDescription,
        style: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 13,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final List<Widget> children;

  const _DocumentCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  final String title;
  final String filename;
  final String imageUrl;
  final bool isLast;

  const _DocumentRow({
    required this.title,
    required this.filename,
    required this.imageUrl,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = imageUrl.isNotEmpty;

    return InkWell(
      onTap: hasFile
          ? () {
              Get.dialog(
                Dialog(
                  insetPadding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          color: AppColors.primary,
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'Gambar tidak dapat ditampilkan',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade100,
                  ),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: hasFile
                    ? AppColors.primary.withOpacity(0.09)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                hasFile
                    ? Icons.image_rounded
                    : Icons.image_not_supported_rounded,
                color: hasFile ? AppColors.primary : Colors.grey,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hasFile ? filename : 'Belum ada dokumen',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color:
                    hasFile ? Colors.green.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                hasFile ? 'Ada' : 'Kosong',
                style: GoogleFonts.poppins(
                  color: hasFile ? Colors.green : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditVendorBottomSheet extends StatelessWidget {
  final VendorDataController controller;

  const _EditVendorBottomSheet({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Edit Data Vendor',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    _EditField(
                      label: 'Nama Usaha',
                      controller: controller.businessNameController,
                      icon: Icons.storefront_rounded,
                    ),
                    _EditField(
                      label: 'Kategori',
                      controller: controller.categoryController,
                      icon: Icons.category_rounded,
                    ),
                    _EditField(
                      label: 'Deskripsi',
                      controller: controller.descriptionController,
                      icon: Icons.description_rounded,
                      maxLines: 3,
                    ),
                    _EditField(
                      label: 'Lokasi',
                      controller: controller.locationController,
                      icon: Icons.location_on_rounded,
                    ),
                    _EditField(
                      label: 'Nomor HP',
                      controller: controller.phoneController,
                      icon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    _EditField(
                      label: 'Nama Pemilik',
                      controller: controller.ownerNameController,
                      icon: Icons.person_rounded,
                    ),
                    _EditField(
                      label: 'NIK',
                      controller: controller.nikController,
                      icon: Icons.badge_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    _EditField(
                      label: 'NPWP',
                      controller: controller.npwpController,
                      icon: Icons.article_rounded,
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isSaving.value
                              ? null
                              : controller.updateVendorData,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: controller.isSaving.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Simpan Perubahan',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;

  const _EditField({
    required this.label,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
          ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          labelStyle: GoogleFonts.poppins(
            color: AppColors.textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}