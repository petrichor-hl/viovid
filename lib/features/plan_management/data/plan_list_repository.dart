import 'dart:developer';

import 'package:viovid/features/plan_management/data/plan_list_api_service.dart';
import 'package:viovid/features/plan_management/dtos/plan_dto.dart';
import 'package:viovid/features/result_type.dart';

class PlanListRepository {
  final PlanListApiService planListApiService;

  PlanListRepository({
    required this.planListApiService,
  });

  Future<Result<List<PlanDto>>> getPlanList({String? searchText}) async {
    try {
      return Success(await planListApiService.getPlanList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<PlanDto>> addNewPlan(PlanDto plan) async {
    try {
      return Success(
        await planListApiService.addNewPlan(plan),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> editPlan(PlanDto editedPlan, String editedPlanId) async {
    try {
      return Success(
        await planListApiService.editPlan(editedPlan, editedPlanId),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> deletePlan(String planId) async {
    try {
      return Success(await planListApiService.deletePlan(planId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
