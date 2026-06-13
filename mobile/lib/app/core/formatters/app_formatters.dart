class AppFormatters {
  const AppFormatters._();

  static String healthStatusLabel(String? status) {
    switch (status) {
      case 'normal':
        return 'NORMAL';
      case 'warning':
        return 'WASPADA';
      case 'needs_attention':
        return 'PERHATIAN';
      case 'critical':
        return 'KRITIS';
      default:
        return 'NORMAL';
    }
  }

  static String healthStatusTitle(String? status) {
    switch (status) {
      case 'normal':
        return 'Normal';
      case 'warning':
        return 'Waspada';
      case 'needs_attention':
        return 'Perlu Perhatian';
      case 'critical':
        return 'Kritis';
      default:
        return 'Normal';
    }
  }

  static bool isAttentionStatus(String? status) {
    return status == 'critical' ||
        status == 'needs_attention' ||
        status == 'warning';
  }

  static String recommendationCategoryLabel(String? category) {
    switch (category) {
      case 'physical':
        return 'Fisik';
      case 'cognitive':
        return 'Kognitif';
      case 'social':
        return 'Sosial';
      case 'creative':
        return 'Kreatif';
      case 'relaxation':
        return 'Relaksasi';
      case 'nature':
        return 'Alam';
      case 'music':
        return 'Musik';
      default:
        return category ?? 'Umum';
    }
  }

  static String recommendationStatusLabel(String? status) {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  static String durationMinutesLabel(Object? minutes) {
    if (minutes == null) return '—';
    final value = minutes is int ? minutes : int.tryParse(minutes.toString());
    if (value == null) return '—';
    if (value >= 60) {
      final hours = value ~/ 60;
      final remainingMinutes = value % 60;
      return remainingMinutes > 0
          ? '$hours jam $remainingMinutes menit'
          : '$hours jam';
    }
    return '$value menit';
  }

  static String notificationTypeLabel(String? type) {
    switch (type) {
      case 'health_recorded':
        return 'Data Kesehatan';
      case 'critical_alert':
        return 'Peringatan Kritis';
      case 'weekly_summary':
        return 'Ringkasan Mingguan';
      case 'alarm_reminder':
        return 'Pengingat';
      case 'activity_recommendation':
        return 'Rekomendasi AI';
      default:
        return 'Notifikasi';
    }
  }

  static String relativeTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m yang lalu';
    if (diff.inHours < 24) return '${diff.inHours}j yang lalu';
    if (diff.inDays < 7) return '${diff.inDays}h yang lalu';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}';
  }
}
