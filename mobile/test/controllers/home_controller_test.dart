import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/modules/home/controllers/home_controller.dart';

void main() {
  group('HomeController.statusLabel', () {
    test('returns Indonesian labels for known health statuses', () {
      expect(HomeController.statusLabel('normal'), 'NORMAL');
      expect(HomeController.statusLabel('warning'), 'WASPADA');
      expect(HomeController.statusLabel('needs_attention'), 'PERHATIAN');
      expect(HomeController.statusLabel('critical'), 'KRITIS');
    });

    test('falls back to normal for unknown status', () {
      expect(HomeController.statusLabel('unknown'), 'NORMAL');
      expect(HomeController.statusLabel(null), 'NORMAL');
    });
  });
}
