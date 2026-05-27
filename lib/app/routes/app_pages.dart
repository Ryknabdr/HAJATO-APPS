import 'package:get/get.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/vendor/bindings/vendor_binding.dart';
import '../modules/vendor/views/vendor_list_view.dart';
import '../modules/vendor/views/vendor_detail_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/event/bindings/event_binding.dart';
import '../modules/event/views/event_view.dart';
import '../modules/event/views/invitation_view.dart';
import '../modules/guest/bindings/guest_binding.dart';
import '../modules/guest/views/guest_registration_view.dart';
import '../modules/guest/views/guest_list_view.dart';
import '../modules/qr/bindings/qr_binding.dart';
import '../modules/qr/views/qr_code_view.dart';
import '../modules/qr/views/qr_scanner_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/vendor_dashboard/bindings/vendor_dashboard_binding.dart';
import '../modules/vendor_dashboard/views/vendor_dashboard_view.dart';
import '../modules/vendor_dashboard/views/manage_service_view.dart';
import '../modules/vendor_dashboard/views/vendor_chat_view.dart';
// import '../modules/chatbot/bindings/chatbot_binding.dart';
// import '../modules/chatbot/views/chatbot_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/views/change_password_view.dart';
import '../modules/profile/views/notification_setting_view.dart';
import '../modules/promo/bindings/promo_binding.dart';
import '../modules/promo/views/promo_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/vendor_registration/bindings/vendor_registration_binding.dart';
import '../modules/vendor_registration/views/vendor_registration_view.dart';
import '../modules/vendor_profile/views/vendor_profile_view.dart';
import '../modules/vendor_profile/bindings/vendor_profile_binding.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/verify_otp/views/verify_otp_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/my_bookings/bindings/my_bookings_binding.dart';
import '../modules/my_bookings/views/my_bookings_view.dart';
import '../modules/booking_detail/bindings/booking_detail_binding.dart';
import '../modules/booking_detail/views/booking_detail_view.dart';
import '../modules/vendor_bookings/bindings/vendor_bookings_binding.dart';
import '../modules/vendor_bookings/views/vendor_bookings_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.vendorList,
      page: () => const VendorListView(),
      binding: VendorBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorDetail,
      page: () => const VendorDetailView(),
      binding: VendorBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.booking,
      page: () => const BookingView(),
      binding: BookingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.event,
      page: () => const EventView(),
      binding: EventBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.invitation,
      page: () => const InvitationView(),
      binding: EventBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.guestRegistration,
      page: () => const GuestRegistrationView(),
      binding: GuestBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.guestList,
      page: () => const GuestListView(),
      binding: GuestBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.qrCode,
      page: () => const QrCodeView(),
      binding: QrBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => const QrScannerView(),
      binding: QrBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorDashboard,
      page: () => const VendorDashboardView(),
      binding: VendorDashboardBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.manageService,
      page: () => const ManageServiceView(),
      binding: VendorDashboardBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorChat,
      page: () => const VendorChatView(),
      binding: VendorDashboardBinding(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: AppRoutes.chatbot,
    //   page: () => const ChatbotView(),
    //   binding: ChatbotBinding(),
    //   transition: Transition.downToUp,
    // ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profileEdit,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profileChangePass,
      page: () => const ChangePasswordView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profileNotifications,
      page: () => const NotificationSettingView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.promo,
      page: () => const PromoView(),
      binding: PromoBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorRegistration,
      page: () => const VendorRegistrationView(),
      binding: VendorRegistrationBinding(),
      transition: Transition.rightToLeft,
    ),
    // tambah di dalam pages list
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.vendorProfile,
      page: () => const VendorProfileView(),
      binding: VendorProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingDetail,
      page: () => const BookingDetailView(),
      binding: BookingDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.vendorBookings,
      page: () => const VendorBookingsView(),
      binding: VendorBookingsBinding(),
    ),
  ];
}
