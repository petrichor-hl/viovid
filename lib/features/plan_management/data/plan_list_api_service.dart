import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/plan_management/dtos/plan_dto.dart';

class PlanListApiService {
  PlanListApiService(this.dio);

  final Dio dio;

  Future<List<PlanDto>> getPlanList() async {
    try {
      return await ApiClient(dio).request<void, List<PlanDto>>(
        url: '/Plan',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((plant) => PlanDto.fromJson(plant))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<PlanDto> addNewPlan(PlanDto plan) async {
    try {
      return await ApiClient(dio).request<void, PlanDto>(
        url: '/Plan',
        method: ApiMethod.post,
        payload: {
          'name': plan.name,
          'price': plan.price,
          'duration': plan.duration,
        },
        fromJson: (resultJson) => PlanDto.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<bool> editPlan(PlanDto plan, String editedPlanId) async {
    try {
      final response = await ApiClient(dio).request<void, Map<String, dynamic>>(
        url: '/Plan/$editedPlanId',
        method: ApiMethod.put,
        payload: {
          'name': plan.name,
          'price': plan.price,
          'duration': plan.duration,
        },
      );
      print("response $response");
      if (response.containsKey('id')) {
        return true;
      } else {
        throw Exception('Failed to edit plan');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> deletePlan(String id) async {
    try {
      return await ApiClient(dio).request<void, String>(
        url: '/Plan/$id',
        method: ApiMethod.delete,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
