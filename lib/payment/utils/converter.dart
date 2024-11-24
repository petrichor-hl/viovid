import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;

const _ethCurExchangeApi = String.fromEnvironment(
    'https://min-api.cryptocompare.com/data/price?fsym=USD&tsyms=ETH');

BigInt toBase(Decimal amount, int decimals) {
  Decimal baseUnit = Decimal.fromInt(10).pow(decimals) as Decimal;
  print("baseUnit: $baseUnit");
  Decimal inbase = amount * baseUnit;
  print("inbase: $inbase");
  return BigInt.parse(inbase.toString());
}

Decimal toDecimal(BigInt amount, int decimals) {
  Decimal baseUnit = Decimal.fromInt(10).pow(decimals) as Decimal;
  print("baseUnit: $baseUnit");
  var d = Decimal.parse(amount.toString());
  d = (d / baseUnit) as Decimal;
  print("todec: $d");
  return d;
}

// Function to fetch the current USD to ETH exchange rate from a public API
Future<double> fetchEthToUsdRate() async {
  final response = await http.get(Uri.parse(_ethCurExchangeApi));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['USD'].toDouble();
  } else {
    throw Exception('Failed to load exchange rate');
  }
}

// Function to convert USD to ETH
Future<EtherAmount> convertUsdToEth(int usdAmount) async {
  double ethToUsdRate = await fetchEthToUsdRate();
  double ethAmount = usdAmount / ethToUsdRate;
  BigInt weiAmount = BigInt.from(ethAmount * 1000000000000000000);
  EtherAmount etherAmount = EtherAmount.fromBigInt(EtherUnit.wei, weiAmount);

  return etherAmount;
}
