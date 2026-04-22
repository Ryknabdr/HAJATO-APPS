import '../models/models.dart';

class DummyData {
  static final List<VendorModel> vendors = [
    VendorModel(
      id: 'v1',
      name: 'Lensa Pro Studio',
      category: 'Fotografer',
      description:
          'Studio fotografi profesional dengan pengalaman lebih dari 10 tahun. Kami mengabadikan momen berharga Anda dengan sentuhan artistik dan teknologi terkini. Tersedia untuk pernikahan, wisuda, dan acara spesial lainnya.',
      rating: 4.9,
      reviewCount: 128,
      imageUrl: 'https://picsum.photos/seed/foto1/400/300',
      gallery: [
        'https://picsum.photos/seed/foto2/400/300',
        'https://picsum.photos/seed/foto3/400/300',
        'https://picsum.photos/seed/foto4/400/300',
      ],
      packages: [
        ServicePackage(
          id: 'p1',
          name: 'Paket Basic',
          description: '4 jam sesi foto + 50 foto editan',
          price: 1500000,
          features: ['4 jam sesi', '50 foto editan', '1 fotografer', 'Soft file HD'],
        ),
        ServicePackage(
          id: 'p2',
          name: 'Paket Premium',
          description: '8 jam sesi foto + 150 foto editan + video highlight',
          price: 3500000,
          features: ['8 jam sesi', '150 foto editan', '2 fotografer', '1 videografer', 'Video highlight 5 menit', 'Album cetak'],
        ),
      ],
      reviews: [
        ReviewModel(id: 'r1', userName: 'Siti Rahma', userAvatar: 'https://picsum.photos/seed/ava1/50/50', rating: 5.0, comment: 'Hasilnya luar biasa! Sangat profesional dan ramah.', date: '12 Maret 2025'),
        ReviewModel(id: 'r2', userName: 'Budi Santoso', userAvatar: 'https://picsum.photos/seed/ava2/50/50', rating: 4.8, comment: 'Rekomendasikan banget! Foto-fotonya bagus sekali.', date: '5 Februari 2025'),
      ],
      location: 'Jakarta Selatan',
      startingPrice: 1500000,
      isFeatured: true,
    ),
    VendorModel(
      id: 'v2',
      name: 'Nusantara Catering',
      category: 'Catering',
      description:
          'Catering terpercaya untuk berbagai acara. Menu beragam dari masakan Indonesia hingga internasional. Melayani hingga 2000 tamu dengan standar kebersihan BPOM.',
      rating: 4.7,
      reviewCount: 94,
      imageUrl: 'https://picsum.photos/seed/catering1/400/300',
      gallery: [
        'https://picsum.photos/seed/catering2/400/300',
        'https://picsum.photos/seed/catering3/400/300',
      ],
      packages: [
        ServicePackage(
          id: 'p3',
          name: 'Paket 100 Orang',
          description: 'Menu buffet 15 hidangan untuk 100 tamu',
          price: 2500000,
          features: ['100 porsi', '15 jenis makanan', 'Peralatan makan', 'Tim server 3 orang'],
        ),
        ServicePackage(
          id: 'p4',
          name: 'Paket 500 Orang',
          description: 'Menu buffet premium untuk 500 tamu',
          price: 10000000,
          features: ['500 porsi', '20 jenis makanan', 'Dekorasi meja', 'Tim server 10 orang', 'Live cooking station'],
        ),
      ],
      reviews: [
        ReviewModel(id: 'r3', userName: 'Dewi Kartika', userAvatar: 'https://picsum.photos/seed/ava3/50/50', rating: 4.7, comment: 'Makannya enak dan tidak mengecewakan!', date: '20 April 2025'),
      ],
      location: 'Bandung',
      startingPrice: 2500000,
      isFeatured: true,
    ),
    VendorModel(
      id: 'v3',
      name: 'Elegance Tent & Dekor',
      category: 'Tenda',
      description: 'Penyedia tenda dan dekorasi premium untuk acara pernikahan, sunatan, dan gathering perusahaan. Tersedia berbagai pilihan tema.',
      rating: 4.6,
      reviewCount: 67,
      imageUrl: 'https://picsum.photos/seed/tenda1/400/300',
      gallery: ['https://picsum.photos/seed/tenda2/400/300'],
      packages: [
        ServicePackage(
          id: 'p5',
          name: 'Paket Intimate',
          description: 'Tenda 10x10m untuk acara kecil',
          price: 3000000,
          features: ['Tenda 10x10m', 'Dekorasi bunga', 'Lighting dasar', 'Setup & teardown'],
        ),
      ],
      reviews: [],
      location: 'Surabaya',
      startingPrice: 3000000,
      isFeatured: false,
    ),
    VendorModel(
      id: 'v4',
      name: 'Beauty Queen Makeup',
      category: 'Makeup',
      description: 'Makeup artist profesional berpengalaman untuk pengantin, wisuda, dan berbagai acara. Menggunakan produk high-end internasional.',
      rating: 4.8,
      reviewCount: 211,
      imageUrl: 'https://picsum.photos/seed/makeup1/400/300',
      gallery: ['https://picsum.photos/seed/makeup2/400/300', 'https://picsum.photos/seed/makeup3/400/300'],
      packages: [
        ServicePackage(
          id: 'p6',
          name: 'Paket Pengantin',
          description: 'Full makeup + hairdo pengantin',
          price: 2000000,
          features: ['Full makeup pengantin', 'Hairdo custom', 'Touch up kit', 'Tahan 12 jam'],
        ),
      ],
      reviews: [
        ReviewModel(id: 'r4', userName: 'Rina Ayu', userAvatar: 'https://picsum.photos/seed/ava4/50/50', rating: 5.0, comment: 'Makeupnya tahan lama dan cantik banget!', date: '1 Maret 2025'),
      ],
      location: 'Jakarta Barat',
      startingPrice: 800000,
      isFeatured: true,
    ),
    VendorModel(
      id: 'v5',
      name: 'ProSound Systems',
      category: 'Sound System',
      description: 'Penyewaan sound system profesional untuk berbagai skala acara. Dilengkapi teknisi berpengalaman selama acara berlangsung.',
      rating: 4.5,
      reviewCount: 45,
      imageUrl: 'https://picsum.photos/seed/sound1/400/300',
      gallery: ['https://picsum.photos/seed/sound2/400/300'],
      packages: [
        ServicePackage(
          id: 'p7',
          name: 'Paket Indoor',
          description: 'Sound system untuk acara indoor 200 orang',
          price: 1800000,
          features: ['Speaker utama 2 unit', 'Microphone wireless 4 unit', 'Mixer profesional', 'Teknisi 1 orang'],
        ),
      ],
      reviews: [],
      location: 'Bekasi',
      startingPrice: 1800000,
      isFeatured: false,
    ),
    VendorModel(
      id: 'v6',
      name: 'Mahkota Wedding Organizer',
      category: 'Wedding Organizer',
      description: 'Wedding organizer terpercaya dengan pengalaman menangani lebih dari 500 pernikahan. Kami mewujudkan impian pernikahan Anda menjadi kenyataan.',
      rating: 5.0,
      reviewCount: 176,
      imageUrl: 'https://picsum.photos/seed/wo1/400/300',
      gallery: ['https://picsum.photos/seed/wo2/400/300', 'https://picsum.photos/seed/wo3/400/300'],
      packages: [
        ServicePackage(
          id: 'p8',
          name: 'Paket Full Day',
          description: 'Koordinasi penuh selama hari H',
          price: 5000000,
          features: ['Koordinasi hari H', 'Tim 5 orang', 'Rundown acara', 'Koordinasi vendor'],
        ),
        ServicePackage(
          id: 'p9',
          name: 'Paket Full Package',
          description: 'Perencanaan lengkap dari awal hingga hari H',
          price: 20000000,
          features: ['Perencanaan 6 bulan', 'Vendor hunting', 'Dekorasi konsep', 'Koordinasi penuh', 'Dokumentasi', 'Tim 10 orang'],
        ),
      ],
      reviews: [
        ReviewModel(id: 'r5', userName: 'Andi Wijaya', userAvatar: 'https://picsum.photos/seed/ava5/50/50', rating: 5.0, comment: 'Pernikahan kami berjalan sempurna berkat tim ini!', date: '14 Mei 2025'),
      ],
      location: 'Jakarta Pusat',
      startingPrice: 5000000,
      isFeatured: true,
    ),
  ];

  static final List<GuestModel> sampleGuests = [
    GuestModel(id: 'g1', nama: 'Ahmad Fauzi', nomorHP: '081234567890', hadir: true, checkedIn: true, qrData: 'HAJATO-g1-Ahmad Fauzi'),
    GuestModel(id: 'g2', nama: 'Siti Rahayu', nomorHP: '082345678901', hadir: true, checkedIn: false, qrData: 'HAJATO-g2-Siti Rahayu'),
    GuestModel(id: 'g3', nama: 'Budi Prasetyo', nomorHP: '083456789012', hadir: false, checkedIn: false, qrData: 'HAJATO-g3-Budi Prasetyo'),
    GuestModel(id: 'g4', nama: 'Dewi Lestari', nomorHP: '084567890123', hadir: true, checkedIn: true, qrData: 'HAJATO-g4-Dewi Lestari'),
    GuestModel(id: 'g5', nama: 'Eko Santoso', nomorHP: '085678901234', hadir: true, checkedIn: false, qrData: 'HAJATO-g5-Eko Santoso'),
    GuestModel(id: 'g6', nama: 'Fitria Nurul', nomorHP: '086789012345', hadir: false, checkedIn: false, qrData: 'HAJATO-g6-Fitria Nurul'),
    GuestModel(id: 'g7', nama: 'Gunawan Hadi', nomorHP: '087890123456', hadir: true, checkedIn: true, qrData: 'HAJATO-g7-Gunawan Hadi'),
  ];
}
