import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/template_jadwal/controllers/template_jadwal_controller.dart';
import '../test_helpers.dart';

void main() {
  late TemplateJadwalController controller;
  late MockScheduleRepository mockScheduleRepository;

  setUp(() {
    mockScheduleRepository = MockScheduleRepository();
    Get.testMode = true;
    controller = TemplateJadwalController(scheduleRepository: mockScheduleRepository);
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Initial state', () {
    test('should load 4 templates on init', () {
      expect(controller.templates.length, 4);
    });

    test('templates should have correct structure', () {
      final first = controller.templates[0];
      expect(first.id, '1');
      expect(first.title, 'Cek Tensi Darah');
      expect(first.time, '07:30');
      expect(first.description, isNotEmpty);
    });

    test('only second template should be enabled by default', () {
      expect(controller.templates[1].isEnabled.value, true);
      for (int i = 0; i < controller.templates.length; i++) {
        if (i != 1) {
          expect(controller.templates[i].isEnabled.value, false);
        }
      }
    });
  });

  group('TemplateJadwal model', () {
    test('should create model correctly', () {
      final template = TemplateJadwal(
        id: 'test',
        title: 'Test Title',
        time: '12:00',
        description: 'Test description',
      );
      expect(template.id, 'test');
      expect(template.title, 'Test Title');
      expect(template.time, '12:00');
      expect(template.description, 'Test description');
      expect(template.isEnabled.value, false);
    });

    test('should allow enabling template', () {
      final template = TemplateJadwal(
        id: 'test',
        title: 'Test',
        time: '12:00',
        description: 'Desc',
        isEnabled: true,
      );
      expect(template.isEnabled.value, true);
    });
  });
}
