import 'dart:developer';
import 'package:viovid/features/dashboard_management/data/user_register/user_register_list_api_service.dart';
import 'package:viovid/features/result_type.dart';

class UserRegisterListRepository {
  final UserRegisterListService userRegisterListService;

  UserRegisterListRepository({
    required this.userRegisterListService,
  });

  Future<Result<List<int>>> getUserRegist(int year) async {
    try {
      return Success(await userRegisterListService.getUserRegist(year));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
