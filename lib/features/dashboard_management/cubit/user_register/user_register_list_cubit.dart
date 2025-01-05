import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/dashboard_management/cubit/user_register/user_register_list_state.dart';
import 'package:viovid/features/dashboard_management/data/user_register/user_register_list_repository.dart';
import 'package:viovid/features/result_type.dart';

class UserRegisterListCubit extends Cubit<UserRegisterListState> {
  final UserRegisterListRepository dashboardManagementRepository;

  UserRegisterListCubit(this.dashboardManagementRepository)
      : super(UserRegisterListState());

  Future<void> getUserRegist(int year) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await dashboardManagementRepository.getUserRegist(year);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            usersRegistered: result.data,
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
