import '../models/models.dart';

class DummyData {
  static final List<VendorModel> vendors = [
    VendorModel(
      id: 'v1',
      name: 'Lensa Pro Studio',
      category: 'Fotografer',
      description:
          'Studio fotografi profesional dengan pengalaman lebih dari 10 tahun.',
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
          category: 'Fotografer',
          description: '4 jam sesi foto + 50 foto editan',
          price: 1500000,
          features: [
            '4 jam sesi',
            '50 foto editan',
            '1 fotografer',
          ],
        ),

        ServicePackage(
          id: 'p2',
          name: 'Paket Premium',
          category: 'Fotografer',
          description: '8 jam sesi + video highlight',
          price: 3500000,
          features: [
            '8 jam sesi',
            '150 foto editan',
            '2 fotografer',
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
      description: 'Catering terpercaya untuk berbagai acara.',
      rating: 4.7,
      reviewCount: 94,
      imageUrl: 'assets/images/ctr1.jpeg',
      gallery: [
        'assets/images/ctr1.jpeg',
        'assets/images/ctr2.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p3',
          name: 'Paket 100 Orang',
          category: 'Catering',
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
      description: 'Penyedia tenda dan dekorasi premium.',
      rating: 4.6,
      reviewCount: 67,
      imageUrl: 'assets/images/tnd.jpeg',
      gallery: [
        'assets/images/tnd1.jpg',
        'assets/images/tnd2.jpg',
      ],
      packages: [
        ServicePackage(
          id: 'p4',
          name: 'Paket Intimate',
          category: 'Tenda',
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
      description: 'Makeup artist profesional.',
      rating: 4.8,
      reviewCount: 211,
      imageUrl: 'assets/images/mwr.jpg',
      gallery: [
        'assets/images/hajato1.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p5',
          name: 'Paket Pengantin',
          category: 'Makeup',
          description: 'Makeup + hairdo premium',
          price: 2000000,
          features: [
            'Full makeup',
            'Hairdo',
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
      description: 'Penyewaan sound system profesional.',
      rating: 4.5,
      reviewCount: 45,
      imageUrl: 'assets/images/son.jpeg',
      gallery: [
        'assets/images/gpy.png',
      ],
      packages: [
        ServicePackage(
          id: 'p6',
          name: 'Paket Indoor',
          category: 'Sound System',
          description: 'Sound system indoor',
          price: 1800000,
          features: [
            'Speaker',
            'Mixer',
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
      description: 'Wedding organizer terpercaya.',
      rating: 5.0,
      reviewCount: 176,
      imageUrl: 'assets/images/hajato.png',
      gallery: [
        'assets/images/hajato1.jpeg',
      ],
      packages: [
        ServicePackage(
          id: 'p7',
          name: 'Paket Full Day',
          category: 'Wedding Organizer',
          description: 'Koordinasi penuh hari H',
          price: 5000000,
          features: [
            'Koordinasi vendor',
            'Tim WO',
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
      qrData: 'HAJATO-g1',
    ),
  ];
}