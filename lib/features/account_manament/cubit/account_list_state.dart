import 'package:viovid/features/account_manament/dtos/account_dto.dart';

class AccountListState {
  final bool isLoading;
  final List<AccountDto>? accounts;
  final String errorMessage;

  AccountListState({
    this.isLoading = false,
    this.accounts,
    this.errorMessage = "",
  });

  AccountListState copyWith({
    bool? isLoading,
    List<AccountDto>? accounts,
    String? errorMessage,
  }) {
    return AccountListState(
      isLoading: isLoading ?? this.isLoading,
      accounts: accounts ?? this.accounts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
