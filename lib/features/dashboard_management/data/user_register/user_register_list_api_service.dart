import 'package:dio/dio.dart';
import 'package:viovid/features/api_client.dart';

class UserRegisterListService {
  UserRegisterListService(this.dio);

  final Dio dio;

  Future<List<int>> getUserRegist(int year) async {
    try {
      return await ApiClient(dio).request<void, List<int>>(
        url: '/Dashboard/registration-stats/$year',
        method: ApiMethod.get,
        fromJson: (resultJson) =>
            (resultJson as List<dynamic>).map((e) => e as int).toList(),
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
