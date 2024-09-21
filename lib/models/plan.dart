class Plan {
  String planId;
  String name;
  int price;
  int duration;
  String timeUnit;
  bool recommended;

  Plan({
    required this.planId,
    required this.name,
    required this.price,
    required this.duration,
    required this.timeUnit,
    required this.recommended,
  });

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      planId: map['plan_id'] as String,
      name: map['name'] as String,
      price: map['price'] as int,
      duration: map['duration'] as int,
      timeUnit: map['time_unit'] as String,
      recommended: map['recommended'] as bool,
    );
  }

  static List<Plan> fromList(List<Map<String, dynamic>> list) {
    return list.map(Plan.fromMap).toList();
  }
}
