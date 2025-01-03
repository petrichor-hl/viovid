import 'package:dio/dio.dart';
import 'package:viovid/features/account_manament/dtos/account_dto.dart';
import 'package:viovid/features/api_client.dart';

class AccountListApiService {
  AccountListApiService(this.dio);

  final Dio dio;

  Future<List<AccountDto>> getAccountList({String? searchText}) async {
    try {
      return await ApiClient(dio).request<void, List<AccountDto>>(
        url: '/Account',
        method: ApiMethod.get,
        queryParameters: {
          "searchText": searchText,
        },
        fromJson: (resultJson) => (resultJson as List)
            .map((account) => AccountDto.fromJson(account))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> deleteAccount(String userId) async {
    try {
      return await ApiClient(dio).request<void, String>(
        url: '/Account/$userId',
        method: ApiMethod.delete,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
