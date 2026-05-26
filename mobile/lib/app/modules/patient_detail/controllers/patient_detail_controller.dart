import 'package:get/get.dart';
import '../../../data/elderly_api.dart';
import '../../../routes/app_pages.dart';

class PatientDetailController extends GetxController {
  final patientName = ''.obs;
  final patientAge = ''.obs;
  final patientGender = ''.obs;
  final patientPhotoUrl = ''.obs;
  final patientMobilityLevel = ''.obs;
  final patientMedicalHistory = ''.obs;
  final patientPhysicalCondition = ''.obs;
  final patientHobbiesInterests = ''.obs;
  final patientStatus = ''.obs;
  final isLoading = false.obs;

  int? elderlyId;

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

  final ElderlyApi _api = ElderlyApi();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      elderlyId = args['elderly_id'] is int
          ? args['elderly_id']
          : int.tryParse(args['elderly_id']?.toString() ?? '');

      elderlyId = args['elderly_id'] as int?;

      if (args['from'] != null) {
        currentIndex.value = args['from'];
      }

      patientName.value = args['name'] ?? '';
      if (patientName.value.isNotEmpty) {
        patientGender.value = args['gender'] ?? '';
        patientPhotoUrl.value = args['image'] ?? '';
      }
    }

    if (elderlyId != null) {
      loadDetail(elderlyId!);
    }
  }

  Future<void> loadDetail(int id) async {
    isLoading.value = true;

    final result = await _api.getById(id);

    isLoading.value = false;

    if (result['error'] == true) {
      // fallback to mock name if already set
      patientName.value = patientName.value.isNotEmpty
          ? patientName.value
          : 'Budi Santoso';
      return;
    }

    final data = result['data'] as Map<String, dynamic>?;
    if (data != null) {
      patientName.value = data['full_name'] ?? patientName.value;
      patientAge.value = data['age']?.toString() ?? '';
      patientGender.value = data['gender'] ?? '';
      patientPhotoUrl.value = data['photo_url'] ?? '';
      patientMobilityLevel.value = data['mobility_level'] ?? '';
      patientMedicalHistory.value = data['medical_history'] ?? '';
      patientPhysicalCondition.value = data['physical_condition'] ?? '';
      patientHobbiesInterests.value = data['hobbies_interests'] ?? '';
      patientStatus.value = data['status'] ?? '';
    }
  }

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
