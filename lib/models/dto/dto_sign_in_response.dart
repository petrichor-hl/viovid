class SignInResponse {
  final bool succeeded;
  final Result result;
  final List<dynamic> errors;

  SignInResponse({
    required this.succeeded,
    required this.result,
    required this.errors,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      succeeded: json['succeeded'],
      result: Result.fromJson(json['result']),
      errors: json['errors'],
    );
  }
}

class Result {
  final String email;
  final String accessToken;
  final String refreshToken;

  Result({
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      email: json['email'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
