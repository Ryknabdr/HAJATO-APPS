import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../data/models/models.dart';
import '../../../routes/app_routes.dart';

const _kOrange = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFD94F10);
const _kOrangeLight = Color(0xFFFF9A5C);

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2EE),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(child: _SearchFloat()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(child: _Body()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          const _FloatingChatBtn(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => _BottomNav(
          currentIndex: controller.currentNavIndex.value,
          onTap: controller.changeNav,
        ),
      ),
    );
  }
}

// ─── HEADER ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C42), Color(0xFFD94F10)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Halo, Pengguna! 👋',
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rencanakan Acaramu',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Temukan vendor terbaik untuk hajatanmu',
                    style: GoogleFonts.dmSans(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _HeaderIconBtn(
                    icon: Icons.notifications_outlined,
                    onTap: () {},
                  ),
                  // const SizedBox(width: 8),
                  // _HeaderIconBtn(
                  //   icon: Icons.person_outline_rounded,
                  //   onTap: () => Get.toNamed(AppRoutes.profile),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.2),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: const Icon(
        Icons.notifications_outlined,
        color: Colors.white,
        size: 20,
      ),
    ),
  );
}

// ─── SEARCH FLOAT ─────────────────────────────────────────────────────────────

class _SearchFloat extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.onSearch,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: const Color(0xFF18130A),
          ),
          decoration: InputDecoration(
            hintText: 'Cari vendor hajatan...',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFFB5B0A8),
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [_kOrangeLight, _kOrangeDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(10),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _kOrange.withOpacity(0.08),
              ),
              child: Icon(Icons.tune_rounded, color: _kOrange, size: 17),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

// ─── BODY ─────────────────────────────────────────────────────────────────────

class _Body extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle('Kategori'),
          const SizedBox(height: 14),
          _Categories(),
          const SizedBox(height: 24),
          _PromoCard(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle('Vendor Unggulan'),
              GestureDetector(
                onTap: () => Get.find<HomeController>().goToVendorList(null),
                child: Text(
                  'Lihat Semua →',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: _kOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Obx(() {
            final ctrl = Get.find<HomeController>();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ctrl.featuredVendors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _VendorCard(
                vendor: ctrl.featuredVendors[i],
                onTap: () => ctrl.goToVendorDetail(ctrl.featuredVendors[i]),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF18130A),
      letterSpacing: -0.3,
    ),
  );
}

// ─── CATEGORIES ───────────────────────────────────────────────────────────────

class _Categories extends GetView<HomeController> {
  final _icons = [
    Icons.photo_camera_rounded,
    Icons.restaurant_rounded,
    Icons.park_rounded,
    Icons.face_retouching_natural,
    Icons.music_note_rounded,
    Icons.favorite_rounded,
  ];

  final _colors = [
    _kOrange,
    const Color(0xFF2ECC71),
    const Color(0xFF5B8FF9),
    const Color(0xFFFF6B9D),
    const Color(0xFF9B59B6),
    _kOrangeDark,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final cat = controller.categories[i];
          final color = _colors[i % _colors.length];
          return Obx(() {
            final isSelected =
                controller.selectedCategory.value == cat['label'];
            return GestureDetector(
              onTap: () => controller.selectCategory(cat['label']!),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? color : const Color(0xFFEDE9E1),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Icon(
                      _icons[i],
                      color: isSelected ? color : const Color(0xFF8A8278),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label']!.length > 8
                        ? '${cat['label']!.substring(0, 7)}…'
                        : cat['label']!,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : const Color(0xFF8A8278),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}

// ─── PROMO CARD ───────────────────────────────────────────────────────────────

class _PromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C42), Color(0xFFD94F10)],
        ),
        boxShadow: [
          BoxShadow(
            color: _kOrange.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Text(
                      '✨  Penawaran Spesial',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Diskon 20%\nVendor Pilihan',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Berlaku hingga akhir bulan ini',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.promo),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Lihat Promo →',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _kOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── VENDOR CARD ──────────────────────────────────────────────────────────────

class _VendorCard extends StatefulWidget {
  final VendorModel vendor;
  final VoidCallback onTap;
  const _VendorCard({required this.vendor, required this.onTap});

  @override
  State<_VendorCard> createState() => _VendorCardState();
}

class _VendorCardState extends State<_VendorCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: Image.network(
                  widget.vendor.imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 110,
                    height: 110,
                    color: _kOrange.withOpacity(0.08),
                    child: Icon(
                      Icons.image_outlined,
                      color: _kOrange.withOpacity(0.4),
                      size: 32,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _kOrange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.vendor.category.toUpperCase(),
                          style: GoogleFonts.dmSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _kOrangeDark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        widget.vendor.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF18130A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: Color(0xFFB5B0A8),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              widget.vendor.location,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: const Color(0xFF8A8278),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: _kOrange,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${widget.vendor.rating}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF18130A),
                                ),
                              ),
                              Text(
                                ' (${widget.vendor.reviewCount})',
                                style: GoogleFonts.dmSans(
                                  fontSize: 10,
                                  color: const Color(0xFF8A8278),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            formatRupiah(widget.vendor.startingPrice),
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _kOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FLOATING CHATBOT BUTTON ──────────────────────────────────────────────────

class _FloatingChatBtn extends StatelessWidget {
  const _FloatingChatBtn();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.chatbot),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [_kOrangeLight, _kOrangeDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _kOrange.withOpacity(0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// ─── BOTTOM NAV ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Beranda'},
      {'icon': Icons.store_rounded, 'label': 'Vendor'},
      {'icon': Icons.event_note_rounded, 'label': 'Acara'},
      {'icon': Icons.person_rounded, 'label': 'Profil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 24),
      child: Row(
        children: List.generate(items.length, (i) {
          final isActive = currentIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: isActive
                          ? const LinearGradient(
                              colors: [_kOrangeLight, _kOrangeDark],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: _kOrange.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      items[i]['icon'] as IconData,
                      color: isActive ? Colors.white : const Color(0xFFB5B0A8),
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i]['label'] as String,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isActive ? _kOrange : const Color(0xFFB5B0A8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
