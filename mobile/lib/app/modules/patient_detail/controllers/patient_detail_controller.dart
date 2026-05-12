import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class PatientDetailController extends GetxController {
  final patientName = 'Budi Santoso'.obs;

  final records = [
    {
      'status': 'Perlu Perhatian',
      'date': '24 Oktober 2026',
      'tensi': '135/88',
      'suhu': '36.5°C',
      'notes':
          'Pasien melaporkan merasa sedikit pusing setelah minum obat pagi.\nLatihan fisioterapi ditunda.\nDiberikan tambahan cairan dan dipantau selama satu jam.\nKondisi kembali normal pada pukul 10.00',
      'color': 0xFFE2E2E2,
      'textColor': 0xFF192126,
      'symptoms': ['Pusing Ringan', 'Kelelahan'],
    },
    {
      'status': 'Normal',
      'date': '23 Oktober 2026',
      'tensi': '120/80',
      'suhu': '36°C',
      'notes': '',
      'color': 0xFFBBF246,
      'textColor': 0xFF1C1B1C,
      'symptoms': <String>[],
    },
    {
      'status': 'Normal',
      'date': '22 Oktober 2026',
      'tensi': '120/80',
      'suhu': '36°C',
      'notes': '',
      'color': 0xFFBBF246,
      'textColor': 0xFF1C1B1C,
      'symptoms': <String>[],
    },
    {
      'status': 'Normal',
      'date': '21 Oktober 2026',
      'tensi': '120/80',
      'suhu': '36°C',
      'notes': '',
      'color': 0xFFBBF246,
      'textColor': 0xFF1C1B1C,
      'symptoms': <String>[],
    },
  ].obs;

  final currentIndex = 2.obs;

  void changePage(int index) {
    if (currentIndex.value == index) return;

    int previousIndex = currentIndex.value;
    currentIndex.value = index;

    if (index == 0) {
      Get.offNamed(Routes.DASHBOARD, arguments: {'from': previousIndex});
    } else if (index == 1) {
      Get.offNamed(Routes.CALENDAR, arguments: {'from': previousIndex});
    } else if (index == 2) {
      Get.offNamed(Routes.PATIENT_DETAIL, arguments: {'from': previousIndex});
    } else if (index == 3) {
      Get.offNamed(Routes.PROFIL_LANSIA, arguments: {'from': previousIndex});
    }
  }
}
