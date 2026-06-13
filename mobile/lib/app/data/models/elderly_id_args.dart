class ElderlyIdArgs {
  const ElderlyIdArgs({required this.elderlyId});

  factory ElderlyIdArgs.fromMap(Map<dynamic, dynamic> map) {
    return ElderlyIdArgs(elderlyId: map['elderly_id']?.toString() ?? '');
  }

  final String elderlyId;

  bool get isValid => elderlyId.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {'elderly_id': elderlyId};
  }
}
