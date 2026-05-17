import '../models/models.dart';

class DummyData {
  static final List<VendorModel> vendors = [
    VendorModel(
      id: 'v1',
      name: 'Lensa Pro Studio',
      category: 'Fotografer',
      description:
          'Studio fotografi profesional dengan pengalaman lebih dari 10 tahun. Kami mengabadikan momen berharga Anda dengan sentuhan artistik dan teknologi terkini.',
      rating: 4.9,
      reviewCount: 128,
      imageUrl: 'assets/images/lunatic.png',
      gallery: [
        'assets/images/lunatic1.jpeg',
        'assets/images/lunatic2.jpeg',
        'assets/images/lunatic3.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p1',
          name: 'Paket Basic',
          description: '4 jam sesi foto + 50 foto editan',
          price: 1500000,
          features: [
            '4 jam sesi',
            '50 foto editan',
            '1 fotografer',
            'Soft file HD',
          ],
        ),
        ServicePackage(
          id: 'p2',
          name: 'Paket Premium',
          description: '8 jam sesi + video highlight',
          price: 3500000,
          features: [
            '8 jam sesi',
            '150 foto editan',
            '2 fotografer',
            'Video highlight',
          ],
        ),
      ],
      reviews: [],
      location: 'Jakarta Selatan',
      startingPrice: 1500000,
      isFeatured: true,
    ),

    VendorModel(
      id: 'v2',
      name: 'Nusantara Catering',
      category: 'Catering',
      description:
          'Catering terpercaya untuk berbagai acara dengan menu nusantara dan internasional.',
      rating: 4.7,
      reviewCount: 94,
      imageUrl: 'assets/images/ctr1.jpeg',
      gallery: [
        'assets/images/ctr1.jpeg',
        'assets/images/ctr2.jpeg',
        'assets/images/ctr3.jpg',
      ],
      packages: [
        ServicePackage(
          id: 'p3',
          name: 'Paket 100 Orang',
          description: 'Menu buffet premium',
          price: 2500000,
          features: [
            '100 porsi',
            '15 menu',
            'Tim server',
          ],
        ),
      ],
      reviews: [],
      location: 'Bandung',
      startingPrice: 2500000,
      isFeatured: true,
    ),

    VendorModel(
      id: 'v3',
      name: 'Elegance Tent & Dekor',
      category: 'Tenda',
      description:
          'Penyedia tenda dan dekorasi premium untuk acara besar maupun kecil.',
      rating: 4.6,
      reviewCount: 67,
      imageUrl: 'assets/images/tnd.jpeg',
      gallery: [
        'assets/images/tnd1.jpg',
        'assets/images/tnd2.jpg',
        'assets/images/tnd.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p4',
          name: 'Paket Intimate',
          description: 'Tenda acara lengkap',
          price: 3000000,
          features: [
            'Tenda',
            'Lighting',
            'Dekorasi',
          ],
        ),
      ],
      reviews: [],
      location: 'Surabaya',
      startingPrice: 3000000,
      isFeatured: false,
    ),

    VendorModel(
      id: 'v4',
      name: 'Mawar Jambon',
      category: 'Makeup',
      description:
          'Makeup artist profesional untuk wedding, wisuda, dan acara formal.',
      rating: 4.8,
      reviewCount: 211,
      imageUrl: 'assets/images/mwr.jpg',
      gallery: [
        'assets/images/hajato1.jpeg',
        'assets/images/hajato2.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p5',
          name: 'Paket Pengantin',
          description: 'Makeup + hairdo premium',
          price: 2000000,
          features: [
            'Full makeup',
            'Hairdo',
            'Touch up',
          ],
        ),
      ],
      reviews: [],
      location: 'Jakarta Barat',
      startingPrice: 800000,
      isFeatured: true,
    ),

    VendorModel(
      id: 'v5',
      name: 'Vendorindo',
      category: 'Sound System',
      description:
          'Penyewaan sound system profesional untuk acara indoor maupun outdoor.',
      rating: 4.5,
      reviewCount: 45,
      imageUrl: 'assets/images/son.jpeg',
      gallery: [
        'assets/images/gpy.png',
        'assets/images/google.png',
      ],
      packages: [
        ServicePackage(
          id: 'p6',
          name: 'Paket Indoor',
          description: 'Sound system indoor',
          price: 1800000,
          features: [
            'Speaker',
            'Mixer',
            'Mic wireless',
          ],
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
      description:
          'Wedding organizer terpercaya dengan pengalaman ratusan acara.',
      rating: 5.0,
      reviewCount: 176,
      imageUrl: 'assets/images/hajato.png',
      gallery: [
        'assets/images/hajato1.jpeg',
        'assets/images/hajato2.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p7',
          name: 'Paket Full Day',
          description: 'Koordinasi penuh hari H',
          price: 5000000,
          features: [
            'Koordinasi vendor',
            'Tim WO',
            'Rundown acara',
          ],
        ),
      ],
      reviews: [],
      location: 'Jakarta Pusat',
      startingPrice: 5000000,
      isFeatured: true,
    ),
  ];

  static final List<GuestModel> sampleGuests = [
    GuestModel(
      id: 'g1',
      nama: 'Ahmad Fauzi',
      nomorHP: '081234567890',
      hadir: true,
      checkedIn: true,
      qrData: 'HAJATO-g1-Ahmad Fauzi',
    ),
    GuestModel(
      id: 'g2',
      nama: 'Siti Rahayu',
      nomorHP: '082345678901',
      hadir: true,
      checkedIn: false,
      qrData: 'HAJATO-g2-Siti Rahayu',
    ),
    GuestModel(
      id: 'g3',
      nama: 'Budi Prasetyo',
      nomorHP: '083456789012',
      hadir: false,
      checkedIn: false,
      qrData: 'HAJATO-g3-Budi Prasetyo',
    ),
  ];
}