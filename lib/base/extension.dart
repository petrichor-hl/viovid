import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const _ethCurExchangeApi = String.fromEnvironment('ETH_CURRENCY_EXCHANGE_API');
const _vndCurExchangeApi = String.fromEnvironment('VND_CURRENCY_EXCHANGE_API');

extension DateTimeExtensions on DateTime {
  String toVnFormat() {
    return '${day.twoDigits()}/${month.twoDigits()}/${year.twoDigits()}';
  }
}

extension IntExtension on int {
  String toVnCurrencyFormat() {
    return NumberFormat.currency(locale: 'vi_VN').format(this);
  }

  String toVnCurrencyWithoutSymbolFormat() {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '')
        .format(this)
        .trim();
  }

  String twoDigits() {
    if (this >= 10) return "$this";
    return "0$this";
  }
}

String formatBytes(int bytes) {
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  int i = 0;
  double fileSize = bytes.toDouble();

  while (fileSize >= 1024 && i < sizes.length - 1) {
    fileSize /= 1024;
    i++;
  }

  return '${fileSize.toInt()} ${sizes[i]}';
}

Future<double> fetchUsdToVndRate() async {
  final response = await http.get(Uri.parse(_vndCurExchangeApi));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return double.parse(jsonResponse['rates']['VND']['rate']);
  } else {
    throw Exception('Failed to load exchange rate');
  }
}

Future<int> convertToVND(double amount) async {
  double usdToVndRate = await fetchUsdToVndRate();
  double result = amount * usdToVndRate;
  return result.round();
}

Future<double> fetchUsdToEthRate() async {
  final response = await http.get(Uri.parse(_ethCurExchangeApi));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['ETH'].toDouble();
  } else {
    throw Exception('Failed to load exchange rate');
  }
}

Future<String> convertVndToEth(double vndAmount) async {
  double usdToVndRate = await fetchUsdToVndRate();
  double usdToEthRate = await fetchUsdToEthRate();
  double usdAmount = vndAmount / usdToVndRate;
  double ethAmount = usdAmount / usdToEthRate;
  int ethAmountInt = ethAmount.round();
  String ethHexString = ethAmountInt.toRadixString(16).padLeft(4, '0');

  return '0x$ethHexString';
}
