import 'api_client.dart';

class ElderlyApi {
  final ApiClient _client = ApiClient();

  // ---------------------------------------------------------------------------
  // CRUD for elderly profiles
  // ---------------------------------------------------------------------------

  /// POST /elderly
  Future<Map<String, dynamic>> create({
    required String fullName,
    required int age,
    String? gender,
    String? photoUrl,
    String? medicalHistory,
    String? physicalCondition,
    String? mobilityLevel,
    String? hobbiesInterests,
    String? allergies,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    final response = await _client.post(
      '/elderly',
      body: {
        'full_name': fullName,
        'age': age,
        if (gender != null) 'gender': gender,
        if (photoUrl != null) 'photo_url': photoUrl,
        if (medicalHistory != null) 'medical_history': medicalHistory,
        if (physicalCondition != null) 'physical_condition': physicalCondition,
        if (mobilityLevel != null) 'mobility_level': mobilityLevel,
        if (hobbiesInterests != null) 'hobbies_interests': hobbiesInterests,
        if (allergies != null) 'allergies': allergies,
        if (emergencyContactName != null)
          'emergency_contact_name': emergencyContactName,
        if (emergencyContactPhone != null)
          'emergency_contact_phone': emergencyContactPhone,
      },
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /elderly
  Future<Map<String, dynamic>> getAll() async {
    final response = await _client.get(
      '/elderly',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// GET /elderly/{id}
  Future<Map<String, dynamic>> getById(int id) async {
    final response = await _client.get(
      '/elderly/$id',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// PUT /elderly/{id}
  Future<Map<String, dynamic>> update(
    int id, {
    String? fullName,
    int? age,
    String? gender,
    String? photoUrl,
    String? medicalHistory,
    String? physicalCondition,
    String? mobilityLevel,
    String? hobbiesInterests,
    String? allergies,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (age != null) body['age'] = age;
    if (gender != null) body['gender'] = gender;
    if (photoUrl != null) body['photo_url'] = photoUrl;
    if (medicalHistory != null) body['medical_history'] = medicalHistory;
    if (physicalCondition != null) body['physical_condition'] = physicalCondition;
    if (mobilityLevel != null) body['mobility_level'] = mobilityLevel;
    if (hobbiesInterests != null) body['hobbies_interests'] = hobbiesInterests;
    if (allergies != null) body['allergies'] = allergies;
    if (emergencyContactName != null) body['emergency_contact_name'] = emergencyContactName;
    if (emergencyContactPhone != null) body['emergency_contact_phone'] = emergencyContactPhone;

    final response = await _client.put(
      '/elderly/$id',
      body: body,
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }

  /// DELETE /elderly/{id}
  Future<Map<String, dynamic>> delete(int id) async {
    final response = await _client.delete(
      '/elderly/$id',
      authenticated: true,
    );

    if (response['error'] == true) {
      return response;
    }

    return {
      'error': false,
      'statusCode': response['statusCode'],
      'data': response['data'],
    };
  }
}
