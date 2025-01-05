class PaymentDto {
  final int month;
  final String type;
  final double amount;

  const PaymentDto({
    required this.month,
    required this.type,
    required this.amount,
  });

  factory PaymentDto.fromMap(int month, String type, double amount) {
    return PaymentDto(
      month: month,
      type: type,
      amount: amount,
    );
  }
}

List<PaymentDto> parsePayments(List<Map<String, dynamic>> response) {
  List<PaymentDto> payments = [];
  for (var paymentMap in response) {
    int month = paymentMap['month'];
    paymentMap.forEach((key, value) {
      if (key != 'month') {
        payments.add(PaymentDto.fromMap(month, key, value.toDouble()));
      }
    });
  }
  return payments;
}
