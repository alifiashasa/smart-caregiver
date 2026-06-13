class PatientRouteArgs {
  const PatientRouteArgs({
    required this.elderlyId,
    required this.name,
    required this.age,
    required this.gender,
    required this.image,
  });

  factory PatientRouteArgs.fromMap(Map<dynamic, dynamic> map) {
    return PatientRouteArgs(
      elderlyId: map['elderly_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      age: map['age']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      image: map['image']?.toString() ?? defaultImage,
    );
  }

  static const defaultImage = 'assets/images/patient_ibu_siti.png';

  final String elderlyId;
  final String name;
  final String age;
  final String gender;
  final String image;

  Map<String, dynamic> toMap() {
    return {
      'elderly_id': elderlyId,
      'name': name,
      'age': age,
      'gender': gender,
      'image': image,
    };
  }
}
