class UserRegisterListState {
  final bool isLoading;
  final List<int>? usersRegistered;
  final String errorMessage;

  UserRegisterListState({
    this.isLoading = false,
    this.usersRegistered,
    this.errorMessage = "",
  });

  UserRegisterListState copyWith({
    bool? isLoading,
    List<int>? usersRegistered,
    String? errorMessage,
  }) {
    return UserRegisterListState(
      isLoading: isLoading ?? this.isLoading,
      usersRegistered: usersRegistered ?? this.usersRegistered,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
