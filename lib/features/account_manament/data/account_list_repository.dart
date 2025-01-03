import 'dart:developer';

import 'package:viovid/features/account_manament/data/account_list_api_service.dart';
import 'package:viovid/features/account_manament/dtos/account_dto.dart';
import 'package:viovid/features/result_type.dart';

class AccountListRepository {
  final AccountListApiService accountListApiService;

  AccountListRepository({
    required this.accountListApiService,
  });

  Future<Result<List<AccountDto>>> getAccountList({String? searchText}) async {
    try {
      return Success(await accountListApiService.getAccountList(
        searchText: searchText,
      ));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> deleteAccount(String userId) async {
    try {
      return Success(await accountListApiService.deleteAccount(userId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
