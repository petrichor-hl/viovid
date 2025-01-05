import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viovid/config/api.config.dart';
import 'package:viovid/features/api_client.dart';
import 'package:viovid/features/dashboard_management/dtos/payment_dto.dart';

class PaymentListService {
  PaymentListService(this.dio);

  final Dio dio;

  Future<List<PaymentDto>> getPaymentsList(int year) async {
    try {
      final response = await ApiClient(dio).request<void, List<dynamic>>(
        url: '/Dashboard/payment-summary/$year',
        method: ApiMethod.get,
      );
      List<Map<String, dynamic>> paymentMaps =
          response.cast<Map<String, dynamic>>();
      return parsePayments(paymentMaps);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> getMostUsedPaymentType() async {
    try {
      List<PaymentDto> payments = await getPaymentsList(DateTime.now().year);
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
}

Future<List<PaymentDto>> fetchPayments(int year) async {
  try {
    final response = await http.get(
      Uri.parse('${dio.options.baseUrl}/Dashboard/payment-summary/$year'),
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
    List<PaymentDto> payments = await fetchPayments(DateTime.now().year);
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
