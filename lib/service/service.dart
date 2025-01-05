import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:viovid/config/api.config.dart';
import 'package:viovid/models/dto/dto_film.dart';
import 'package:viovid/models/dto/dto_payment.dart';
import 'package:viovid/models/dto/dto_sign_in_response.dart';
import 'package:viovid/models/dto/dto_top_view_film.dart';
import 'package:viovid/models/dto/dto_topic.dart';

String url = dio.options.baseUrl;
final headers = {'Content-Type': 'application/json'};

Future<bool> signIn(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$url/Account/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Access the nested 'data' object
      final signInResponse = SignInResponse.fromJson(responseData);
      final result = signInResponse.result;

      print(response.statusCode);

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

Future<List<DtoTopic>> fetchTopics() async {
  try {
    final response = await http.get(
      Uri.parse('$url/Topic'),
    );

    if (response.statusCode == 200) {
      // print("Fetch topics success");
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      var topicsList = responseData['result'] as List;
      List<DtoTopic> topics = topicsList.map((topic) {
        var filmsList = topic['films'] as List;
        List<DtoFilms> films = filmsList.map((film) {
          return DtoFilms(
            filmId: film['filmId'] ?? '',
            name: film['name'] ?? '',
            posterPath: film['posterPath'] ?? '',
          );
        }).toList();

        return DtoTopic(
          name: topic['name'],
          films: films,
        );
      }).toList();
      return topics;
    } else {
      throw Exception('Failed to load topics');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load topics');
  }
}

Future<List<int>> fetchUserRegist(int year) async {
  try {
    // return [5, 7, 10, 90, 80, 12, 14, 13, 11, 10, 70, 60];
    final response = await http.get(
      Uri.parse('$url/Dashboard/registration-stats/$year'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData['succeeded'] == true) {
        List<dynamic> result = responseData['result'];
        return result.map((e) => e as int).toList();
      } else {
        throw Exception('Failed to load user registration data');
      }
    } else {
      throw Exception('Failed to load user registration data');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load user registration data');
  }
}

Future<List<DtoPayment>> fetchPayments(int year) async {
  try {
    final response = await http.get(
      Uri.parse('$url/Dashboard/payment-summary/$year'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData['succeeded'] == true) {
        List<dynamic> result = responseData['result'];
        List<Map<String, dynamic>> paymentMaps =
            result.cast<Map<String, dynamic>>();
        return parsePayments(paymentMaps);
      } else {
        throw Exception('Failed to load payments');
      }
    } else {
      throw Exception('Failed to load payments');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load payments');
  }
}

Future<String> getMostUsedPaymentType() async {
  try {
    List<DtoPayment> payments = await fetchPayments(DateTime.now().year);
    Map<String, double> paymentTypeTotals = {};

    for (var payment in payments) {
      if (!paymentTypeTotals.containsKey(payment.type)) {
        paymentTypeTotals[payment.type] = 0;
      }
      paymentTypeTotals[payment.type] =
          paymentTypeTotals[payment.type]! + payment.amount;
    }
    String mostUsedPaymentType = paymentTypeTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return mostUsedPaymentType;
  } catch (e) {
    print(e);
    throw Exception('Failed to determine the most used payment type');
  }
}

Future<List<DtoTopViewFilm>> fetchTopViewFilms(int num) async {
  try {
    final response = await http.get(
      Uri.parse('$url/Dashboard/top-views?Count=$num'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData['succeeded'] == true) {
        List<dynamic> result = responseData['result'];
        return result.map((e) => DtoTopViewFilm.fromMap(e)).toList();
      } else {
        throw Exception('Failed to load top view films');
      }
    } else {
      throw Exception('Failed to load top view films');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load top view films');
  }
}
