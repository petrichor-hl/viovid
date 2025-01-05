class PlanDto {
  String? id;
  String name;
  int price;
  int duration;
  dynamic payments;

  PlanDto({
    this.id,
    required this.name,
    required this.price,
    required this.duration,
    this.payments,
  });

  factory PlanDto.fromMap(Map<String, dynamic> map) {
    return PlanDto(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      duration: map['duration'],
      payments: map['payments'],
    );
  }
  factory PlanDto.fromJson(Map<String, dynamic> json) => PlanDto(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        duration: json['duration'],
        payments: json['payments'],
      );
}
