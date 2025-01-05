import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/plan_management/cubit/plan_list_state.dart';
import 'package:viovid/features/plan_management/data/plan_list_repository.dart';
import 'package:viovid/features/plan_management/dtos/plan_dto.dart';
import 'package:viovid/features/result_type.dart';

class PlanListCubit extends Cubit<PlanListState> {
  final PlanListRepository planListRepository;

  PlanListCubit(this.planListRepository) : super(PlanListState());

  Future<void> getPlanList({String? searchText}) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await planListRepository.getPlanList(
      searchText: searchText,
    );
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            plans: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> addNewPlan(PlanDto plan) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await planListRepository.addNewPlan(plan);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            plans: [...?state.plans, result.data],
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> editPlan(PlanDto editedPlan, String editedPlanId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await planListRepository.editPlan(editedPlan, editedPlanId);
    print("edit plan cubit: $result");
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            plans: state.plans
                ?.map((plan) => plan.id == editedPlanId
                    ? PlanDto(
                        name: editedPlan.name,
                        price: editedPlan.price,
                        duration: editedPlan.duration,
                      )
                    : plan)
                .toList(),
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> deletePlan(String planId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await planListRepository.deletePlan(planId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            plans: state.plans?.where((plan) => plan.id != planId).toList(),
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }
}
