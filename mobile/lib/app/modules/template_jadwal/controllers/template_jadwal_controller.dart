import 'package:get/get.dart';
import '../../../core/logger.dart';
import '../../../core/ui/app_feedback.dart';
import '../../../data/models/elderly_id_args.dart';
import '../../../data/repositories/schedule_repository.dart';

class TemplateJadwal {
  final String id;
  final String title;
  final String time;
  final String description;
  final String scheduleType;
  final RxBool isEnabled;

  TemplateJadwal({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    this.scheduleType = 'daily_activity',
    bool isEnabled = false,
  }) : isEnabled = isEnabled.obs;
}

class TemplateJadwalController extends GetxController {
  final ScheduleRepository _scheduleRepository;

  TemplateJadwalController({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository;

  // ── Reactive state ──
  final _templates = <TemplateJadwal>[].obs;
  final _isLoading = false.obs;

  // ── Public getters ──
  List<TemplateJadwal> get templates => _templates;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadTemplates();
  }

  void _loadTemplates() {
    _templates.addAll([
      TemplateJadwal(
        id: '1',
        title: 'Cek Tensi Darah',
        time: '07:30',
        description: 'Pemeriksaan tensi darah pagi hari',
        scheduleType: 'routine_checkup',
      ),
      TemplateJadwal(
        id: '2',
        title: 'Minum Obat Pagi',
        time: '08:00',
        description: 'Aspirin & Vitamin, sesudah makan',
        scheduleType: 'medication',
        isEnabled: true,
      ),
      TemplateJadwal(
        id: '3',
        title: 'Latihan Fisik Ringan',
        time: '10:00',
        description: 'Peregangan sendi selama 15 menit',
        scheduleType: 'daily_activity',
      ),
      TemplateJadwal(
        id: '4',
        title: 'Makan Siang & Obat',
        time: '13:00',
        description: 'Makan siang dan obat penurun kolesterol',
        scheduleType: 'medication',
      ),
    ]);
  }

  String? get _elderlyId {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      log.info(
        'TemplateJadwalController._elderlyId',
        data: {
          'args_keys': args.keys.toList(),
          'elderly_id_raw': args['elderly_id'],
        },
      );
      final parsedArgs = ElderlyIdArgs.fromMap(args);
      return parsedArgs.isValid ? parsedArgs.elderlyId : null;
    }
    log.info('TemplateJadwalController._elderlyId: no args');
    return null;
  }

  Future<void> saveTemplateSchedule() async {
    final elderlyId = _elderlyId;
    if (elderlyId == null) {
      AppFeedback.error(
        'Error',
        'Data lansia tidak ditemukan. Silakan pilih lansia dari halaman utama.',
      );
      return;
    }

    final enabledTemplates = _templates
        .where((t) => t.isEnabled.value)
        .toList();
    if (enabledTemplates.isEmpty) {
      AppFeedback.info('Info', 'Pilih minimal satu template');
      return;
    }

    _isLoading.value = true;
    int successCount = 0;

    for (final template in enabledTemplates) {
      final timeParts = template.time.split(':');
      final now = DateTime.now();
      final scheduledAt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      final result = await _scheduleRepository.create(
        elderlyId: elderlyId,
        title: template.title,
        scheduleType: template.scheduleType,
        scheduledAt: scheduledAt,
        description: template.description,
        durationMinutes: 15,
        reminderMinutes: [15],
      );

      if (!result['error']) {
        successCount++;
      }
    }

    _isLoading.value = false;

    Get.back(result: successCount > 0);

    if (successCount > 0) {
      AppFeedback.success(
        'Sukses',
        '$successCount jadwal dari template berhasil ditambahkan',
      );
    } else {
      AppFeedback.error('Error', 'Gagal menambahkan jadwal template');
    }
  }
}
