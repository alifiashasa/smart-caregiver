// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';

import '../modules/patient_shell/bindings/patient_shell_binding.dart';
import '../modules/patient_shell/views/patient_shell_view.dart';
import '../modules/detail-history/bindings/detail_history_binding.dart';
import '../modules/detail-history/views/detail_history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/jadwal-lansia/bindings/jadwal_lansia_binding.dart';
import '../modules/jadwal-lansia/views/jadwal_lansia_view.dart';
import '../modules/log-kesehatan/bindings/log_kesehatan_binding.dart';
import '../modules/log-kesehatan/views/log_kesehatan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/profil-caregiver/bindings/profil_caregiver_binding.dart';
import '../modules/profil-caregiver/views/profil_caregiver_view.dart';
import '../modules/edit-profile/bindings/edit_profile_binding.dart';
import '../modules/edit-profile/views/edit_profile_view.dart';
import '../modules/rekomendasi_ai/bindings/rekomendasi_ai_binding.dart';
import '../modules/rekomendasi_ai/views/rekomendasi_ai_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/success_log_kesehatan/bindings/success_log_kesehatan_binding.dart';
import '../modules/success_log_kesehatan/views/success_log_kesehatan_view.dart';
import '../modules/tambah_lansia/bindings/tambah_lansia_binding.dart';
import '../modules/tambah_lansia/views/tambah_lansia_view.dart';
import '../modules/template_jadwal/bindings/template_jadwal_binding.dart';
import '../modules/template_jadwal/views/template_jadwal_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/face_register/bindings/face_register_binding.dart';
import '../modules/face_register/views/face_register_view.dart';
import '../modules/face_verify/bindings/face_verify_binding.dart';
import '../modules/face_verify/views/face_verify_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PATIENT_DETAIL,
      page: () => PatientShellView(initialTab: 2),
      binding: PatientShellBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_LANSIA,
      page: () => const TambahLansiaView(),
      binding: TambahLansiaBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => PatientShellView(initialTab: 0),
      binding: PatientShellBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => PatientShellView(initialTab: 1),
      binding: PatientShellBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.LOG_KESEHATAN,
      page: () => const LogKesehatanView(),
      binding: LogKesehatanBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_HISTORY,
      page: () => const DetailHistoryView(),
      binding: DetailHistoryBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL_LANSIA,
      page: () => PatientShellView(initialTab: 3),
      binding: PatientShellBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.JADWAL_LANSIA,
      page: () => const JadwalLansiaView(),
      binding: JadwalLansiaBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL_CAREGIVER,
      page: () => const ProfilCaregiverView(),
      binding: ProfilCaregiverBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFIKASI,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.TEMPLATE_JADWAL,
      page: () => const TemplateJadwalView(),
      binding: TemplateJadwalBinding(),
    ),
    GetPage(
      name: _Paths.REKOMENDASI_AI,
      page: () => const RekomendasiAiView(),
      binding: RekomendasiAiBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS_LOG_KESEHATAN,
      page: () => const SuccessLogKesehatanView(),
      binding: SuccessLogKesehatanBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FACE_REGISTER,
      page: () => const FaceRegisterView(),
      binding: FaceRegisterBinding(),
    ),
    GetPage(
      name: _Paths.FACE_VERIFY,
      page: () => const FaceVerifyView(),
      binding: FaceVerifyBinding(),
    ),
  ];
}
