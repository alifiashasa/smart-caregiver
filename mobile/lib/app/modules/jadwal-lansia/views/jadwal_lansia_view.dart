import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/jadwal_lansia_controller.dart';

class JadwalLansiaView extends GetView<JadwalLansiaController> {
  const JadwalLansiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.80),
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F4), width: 1),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Jadwal Oleh Caregiver',
          style: TextStyle(
            color: Color(0xFF1C1917),
            fontSize: 19,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.40,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF5F5F4), width: 1),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/caregiver_profile.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 884),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 48),
            decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 672),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 32,
                        left: 20,
                        right: 20,
                        bottom: 66,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama Aktivitas',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTitleField(),
                          const SizedBox(height: 24),
                          const Text(
                            'Tipe',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                runSpacing: 8,
                                children: [
                                  _buildTypeChip(
                                    'Medis',
                                    Icons.medical_services,
                                    controller.selectedType == 'medication',
                                    () => controller.selectType(
                                      'medication',
                                      'Medis',
                                    ),
                                  ),
                                  _buildTypeChip(
                                    'Pemeriksaan',
                                    Icons.assignment,
                                    controller.selectedType ==
                                        'routine_checkup',
                                    () => controller.selectType(
                                      'routine_checkup',
                                      'Pemeriksaan',
                                    ),
                                  ),
                                  _buildTypeChip(
                                    'Aktivitas',
                                    Icons.directions_run,
                                    controller.selectedType == 'daily_activity',
                                    () => controller.selectType(
                                      'daily_activity',
                                      'Aktivitas',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tanggal',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => _buildInputField(
                              controller.dateDisplay,
                              Icons.calendar_today,
                              onTap: _pickDate,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Waktu',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => _buildInputField(
                              controller.timeDisplay,
                              Icons.access_time,
                              onTap: _pickTime,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Mengulang',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                              letterSpacing: 0.14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => _buildInputField(
                              controller.recurrenceLabel,
                              Icons.keyboard_arrow_down,
                              onTap: _pickRecurrence,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildAlarmSection(),
                          const SizedBox(height: 48),
                          Obx(
                            () => GestureDetector(
                              onTap: controller.isLoading
                                  ? null
                                  : controller.saveSchedule,
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                decoration: ShapeDecoration(
                                  color: controller.isLoading
                                      ? const Color(0xFF999999)
                                      : const Color(0xFF192126),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x0F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: controller.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Simpan Jadwal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFC8C5CB)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller.titleController,
        decoration: const InputDecoration(
          hintText: 'Contoh: Jalan Pagi, Minum Obat',
          hintStyle: TextStyle(
            color: Color(0xFF77767B),
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          color: Color(0xFF1C1B1C),
          fontSize: 16,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF192126) : const Color(0xFFFDF8F8),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected
                  ? const Color(0xFF192126)
                  : const Color(0xFFC8C5CB),
            ),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF47464B),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF47464B),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String displayText,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFC8C5CB)),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayText,
              style: const TextStyle(
                color: Color(0xFF1C1B1C),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            Icon(icon, size: 20, color: const Color(0xFF47464B)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmSection() {
    return GestureDetector(
      onTap: () => controller.toggleAlarm(!controller.alarmEnabled),
      child: Obx(
        () => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: const Color(0x4CC8C5CB)),
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0A18181B),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF1FFD4),
                        shape: CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        color: Color(0xFF576755),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pemberitahuan Alarm',
                            style: TextStyle(
                              color: Color(0xFF1C1B1C),
                              fontSize: 14,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Dapatkan pemberitahuan \n15 menit sebelumnya',
                            style: TextStyle(
                              color: Color(0xFF47464B),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 44,
                height: 24,
                child: Switch.adaptive(
                  value: controller.alarmEnabled,
                  onChanged: controller.toggleAlarm,
                  activeThumbColor: const Color(0xFF192126),
                  activeTrackColor: const Color(0xFFBBF246),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E5E5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: controller.selectedTime,
    );
    if (picked != null) {
      controller.selectTime(picked);
    }
  }

  void _pickRecurrence() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frekuensi Pengulangan',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(height: 16),
              ...JadwalLansiaController.recurrenceOptions.map((opt) {
                final value = opt['value'] as String;
                final label = opt['label'] as String;
                final isSelected = controller.selectedRecurrence == value;
                return ListTile(
                  title: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? const Color(0xFF192126)
                          : const Color(0xFF47464B),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFF192126))
                      : null,
                  onTap: () {
                    controller.selectRecurrence(value);
                    Get.back();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
