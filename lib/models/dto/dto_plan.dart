class DtoPlan {
  String? id;
  String name;
  int price;
  int duration;
  dynamic payments;

  DtoPlan({
    this.id,
    required this.name,
    required this.price,
    required this.duration,
    this.payments,
  });

  factory DtoPlan.fromMap(Map<String, dynamic> map) {
    return DtoPlan(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      duration: map['duration'],
      payments: map['payments'],
    );
  }
}
