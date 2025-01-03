import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:viovid/models/dto/sign_in_response.dart';

String url = const String.fromEnvironment("URL_ROOT");
Map<String, String> headers = {
  "Authorization": "Bearer ${localStorage.getItem('token')}"
};

Future<bool> signIn(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$url/api/Account/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Access the nested 'data' object
      final signInResponse = SignInResponse.fromJson(responseData);
      final result = signInResponse.result;

      localStorage.setItem('accessToken', result.accessToken);
      localStorage.setItem('refreshToken', result.refreshToken);

      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
