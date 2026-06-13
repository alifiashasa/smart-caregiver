class HealthLogResultArgs {
  const HealthLogResultArgs({
    required this.status,
    required this.message,
    required this.cardioScore,
    required this.metabolicScore,
    required this.infectionScore,
    this.elderlyId,
    this.patientName,
  });

  factory HealthLogResultArgs.fromMap(Map<dynamic, dynamic> map) {
    return HealthLogResultArgs(
      status: map['status']?.toString() ?? 'Normal',
      message: map['message']?.toString() ?? 'Data kesehatan berhasil dicatat.',
      cardioScore: _readScore(map['cardio_score']),
      metabolicScore: _readScore(map['metabolic_score']),
      infectionScore: _readScore(map['infection_score']),
      elderlyId: map['elderly_id']?.toString(),
      patientName: map['name']?.toString(),
    );
  }

  final String status;
  final String message;
  final double cardioScore;
  final double metabolicScore;
  final double infectionScore;
  final String? elderlyId;
  final String? patientName;

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'cardio_score': cardioScore,
      'metabolic_score': metabolicScore,
      'infection_score': infectionScore,
      'elderly_id': elderlyId,
      'name': patientName,
    };
  }

  static double _readScore(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
