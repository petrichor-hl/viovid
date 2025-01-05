import 'package:viovid/features/plan_management/dtos/plan_dto.dart';

class PlanListState {
  final bool isLoading;
  final List<PlanDto>? plans;
  final String errorMessage;

  PlanListState({
    this.isLoading = false,
    this.plans,
    this.errorMessage = "",
  });

  PlanListState copyWith({
    bool? isLoading,
    List<PlanDto>? plans,
    String? errorMessage,
  }) {
    return PlanListState(
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
