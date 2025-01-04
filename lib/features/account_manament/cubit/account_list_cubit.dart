import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid/features/account_manament/cubit/account_list_state.dart';
import 'package:viovid/features/account_manament/data/account_list_repository.dart';
import 'package:viovid/features/result_type.dart';

class AccountListCubit extends Cubit<AccountListState> {
  final AccountListRepository accountListRepository;

  AccountListCubit(this.accountListRepository) : super(AccountListState());

  Future<void> getAccountList({String? searchText}) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await accountListRepository.getAccountList(
      searchText: searchText,
    );
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            accounts: result.data,
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

  Future<void> deleteAccount(String userId) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await accountListRepository.deleteAccount(userId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            accounts: state.accounts
                ?.where((account) => account.applicationUserId != userId)
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
}
