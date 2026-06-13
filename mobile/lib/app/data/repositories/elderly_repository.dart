import '../../core/api_result.dart';
import '../elderly_api.dart';
import '../models/elderly_profile_model.dart';

class ElderlyRepository {
  final ElderlyApi _api;

  ElderlyRepository() : _api = ElderlyApi();

  Future<Map<String, dynamic>> getElderlyList() => _api.getAll();

  Future<Map<String, dynamic>> getById(String id) => _api.getById(id);

  Future<ApiResult<ElderlyProfileModel>> getProfile(String id) async {
    final response = await _api.getById(id);
    final result = response.toApiResult();

    return result.when(
      success: (data) => ApiResult.success(ElderlyProfileModel.fromJson(data)),
      failure: (failure) => ApiResult.failure(
        failure.message,
        statusCode: failure.statusCode,
        sessionExpired: failure.sessionExpired,
        detailBody: failure.detailBody,
      ),
    );
  }

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
  }) => _api.create(
    fullName: fullName,
    age: age,
    gender: gender,
    photoUrl: photoUrl,
    medicalHistory: medicalHistory,
    physicalCondition: physicalCondition,
    mobilityLevel: mobilityLevel,
    hobbiesInterests: hobbiesInterests,
    allergies: allergies,
    emergencyContactName: emergencyContactName,
    emergencyContactPhone: emergencyContactPhone,
  );

  Future<Map<String, dynamic>> update(
    String id, {
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
  }) => _api.update(
    id,
    fullName: fullName,
    age: age,
    gender: gender,
    photoUrl: photoUrl,
    medicalHistory: medicalHistory,
    physicalCondition: physicalCondition,
    mobilityLevel: mobilityLevel,
    hobbiesInterests: hobbiesInterests,
    allergies: allergies,
    emergencyContactName: emergencyContactName,
    emergencyContactPhone: emergencyContactPhone,
  );

  Future<Map<String, dynamic>> delete(String id) => _api.delete(id);
}
