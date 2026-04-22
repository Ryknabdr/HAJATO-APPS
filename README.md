# HAJATO — Hajatan Organizer
## Dokumentasi Proyek Flutter

---

## 📱 Tentang Aplikasi

**HAJATO** adalah platform mobile berbasis Flutter yang menghubungkan **penyelenggara acara** dengan **vendor penyedia jasa**, dilengkapi sistem manajemen tamu cerdas menggunakan QR Code dan chatbot AI.

---

## 🏗️ Arsitektur Proyek

```
lib/
├── main.dart
└── app/
    ├── core/
    │   ├── theme/
    │   │   └── app_theme.dart          # AppColors + AppTheme
    │   └── widgets/
    │       └── shared_widgets.dart     # Komponen kondivisi
    ├── data/
    │   ├── models/
    │   │   └── models.dart             # VendorModel, GuestModel, dll
    │   └── repositories/
    │       └── dummy_data.dart         # Data sampel
    ├── routes/
    │   ├── app_routes.dart             # Nama-nama route
    │   └── app_pages.dart              # GetPage definitions
    └── modules/
        ├── onboarding/                 # Halaman selamat datang
        ├── home/                       # Beranda pengguna
        ├── vendor/                     # Daftar & detail vendor
        ├── booking/                    # Pemesanan vendor
        ├── chat/                       # Chat user ↔ vendor
        ├── event/                      # Buat acara & undangan
        ├── guest/                      # RSVP & daftar tamu
        ├── qr/                         # Generate & scan QR
        ├── dashboard/                  # Dashboard pengguna
        ├── vendor_dashboard/           # Dashboard vendor
        └── chatbot/                    # AI Chatbot
```

Setiap modul memiliki struktur **Clean Architecture**:
```
modul/
├── views/          → UI (Widget)
├── controllers/    → Logika bisnis (GetxController)
└── bindings/       → Dependency injection (Bindings)
```

---

## 📦 Dependencies Utama

| Package | Versi | Kegunaan |
|---------|-------|----------|
| `get` | ^4.6.6 | State management & navigation |
| `google_fonts` | ^6.2.1 | Tipografi Poppins |
| `qr_flutter` | ^4.1.0 | Generate QR Code |
| `mobile_scanner` | ^5.2.3 | Scan QR via kamera |
| `fl_chart` | ^0.68.0 | Grafik di dasbor |
| `intl` | ^0.19.0 | Format tanggal Bahasa Indonesia |
| `image_picker` | ^1.1.2 | Upload foto layanan |
| `uuid` | ^4.4.0 | ID unik untuk entitas |
| `shimmer` | ^3.0.0 | Loading skeleton |
| `lottie` | ^3.1.2 | Animasi JSON |

---

## 🗺️ Halaman & Route

| Route | Halaman | Keterangan |
|-------|---------|------------|
| `/` | OnboardingPage | Splash + tombol Masuk/Daftar |
| `/home` | HomePage | Beranda, kategori, vendor unggulan |
| `/vendor-list` | VendorListPage | List/grid vendor + filter |
| `/vendor-detail` | VendorDetailPage | Carousel + paket + ulasan |
| `/booking` | BookingPage | Date picker + konfirmasi |
| `/chat` | ChatPage | Chat gelembung user ↔ vendor |
| `/event` | EventPage | Form buat acara |
| `/invitation` | InvitationPage | Link undangan digital |
| `/guest-registration` | GuestRegistrationPage | RSVP form |
| `/guest-list` | GuestListPage | Daftar tamu + status |
| `/qr-code` | QRCodePage | Tampilkan QR per tamu |
| `/qr-scanner` | QRScannerPage | Kamera scan + overlay |
| `/dashboard` | DashboardPage | Statistik + grafik |
| `/vendor-dashboard` | VendorDashboardPage | Dasbor vendor |
| `/manage-service` | ManageServicePage | CRUD layanan vendor |
| `/vendor-chat` | VendorChatPage | Chat vendor → user |
| `/chatbot` | ChatbotPage | AI chatbot asisten |

---

## 🎨 Desain System

### Palet Warna
```dart
primary       = Color(0xFF4F6AF5)   // Biru utama
primaryLight  = Color(0xFF7B93F8)
secondary     = Color(0xFFFF8A65)   // Oranye aksen
background    = Color(0xFFF8F9FE)   // Abu terang
surface       = Color(0xFFFFFFFF)
success       = Color(0xFF34D399)   // Hijau
warning       = Color(0xFFFBBF24)   // Kuning
error         = Color(0xFFF87171)   // Merah
```

### Tipografi
- **Font**: Poppins (Google Fonts)
- **Heading**: 700-800 weight
- **Body**: 400-500 weight
- **Label**: 600 weight

---

## 🔁 GetX Controllers

| Controller | Modul | Tanggung Jawab |
|------------|-------|----------------|
| `OnboardingController` | onboarding | Navigasi ke home/register |
| `HomeController` | home | Search, kategori, nav |
| `VendorController` | vendor | Filter, sort, detail |
| `BookingController` | booking | Date picker, konfirmasi |
| `ChatController` | chat | Kirim/terima pesan |
| `EventController` | event | Form acara, generate link |
| `GuestController` | guest | RSVP, check-in, filter |
| `QrController` | qr | Generate & scan QR |
| `DashboardController` | dashboard | Statistik, grafik |
| `VendorDashboardController` | vendor_dashboard | CRUD layanan, pesanan |
| `ChatbotController` | chatbot | AI conversation logic |

---

## 🚀 Cara Menjalankan

```bash
# Install dependencies
flutter pub get

# Jalankan di emulator/device
flutter run

# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release
```

---

## 📋 Fitur Utama

### 👤 Pengguna (Penyelenggara Acara)
- ✅ Onboarding dengan animasi gradient
- ✅ Cari & filter vendor per kategori
- ✅ Lihat detail vendor (carousel foto, paket harga, ulasan)
- ✅ Pesan vendor dengan date picker
- ✅ Chat langsung dengan vendor
- ✅ Buat acara & generate link undangan digital
- ✅ RSVP & daftar tamu
- ✅ Generate QR Code per tamu
- ✅ Dasbor statistik tamu + grafik
- ✅ Chatbot AI asisten acara

### 🏪 Vendor (Penyedia Jasa)
- ✅ Dashboard vendor dengan statistik
- ✅ Tambah/edit/hapus layanan
- ✅ Upload foto layanan
- ✅ Kelola daftar pesanan
- ✅ Chat dengan pelanggan

### 🤖 QR & Chatbot
- ✅ QR Scanner dengan animasi scan line
- ✅ Feedback "Check-in Berhasil" / "QR Tidak Valid"
- ✅ Chatbot multi-step dengan quick chips
- ✅ Floating chatbot button di semua halaman

---

## 📝 Catatan Teknis

- `withOpacity()` dinonaktifkan di `analysis_options.yaml` (deprecated di Flutter 3.27+, diganti `.withValues()`)  
- Semua teks UI menggunakan **Bahasa Indonesia**
- Orientasi dikunci ke **portrait mode**
- Mendukung Android & iOS
- update by rofiq