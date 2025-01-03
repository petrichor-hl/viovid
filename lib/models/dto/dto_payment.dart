class DtoPayment {
  final int month;
  final String type;
  final double amount;

  const DtoPayment({
    required this.month,
    required this.type,
    required this.amount,
  });

  factory DtoPayment.fromMap(int month, String type, double amount) {
    return DtoPayment(
      month: month,
      type: type,
      amount: amount,
    );
  }
}

List<DtoPayment> parsePayments(List<Map<String, dynamic>> response) {
  List<DtoPayment> payments = [];
  for (var paymentMap in response) {
    int month = paymentMap['month'];
    paymentMap.forEach((key, value) {
      if (key != 'month') {
        payments.add(DtoPayment.fromMap(month, key, value.toDouble()));
      }
    });
  }
  return payments;
}
