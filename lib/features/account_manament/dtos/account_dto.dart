class AccountDto {
  final String applicationUserId;
  final String email;
  final String name;
  final String avatar;
  final bool emailConfirmed;

  AccountDto({
    required this.applicationUserId,
    required this.email,
    required this.name,
    required this.avatar,
    required this.emailConfirmed,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) => AccountDto(
        applicationUserId: json["applicationUserId"],
        email: json["email"],
        name: json["name"],
        avatar: json["avatar"],
        emailConfirmed: json["emailConfirmed"],
      );
}
