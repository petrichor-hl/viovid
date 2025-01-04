class Paging<T> {
  final int totalCount;
  final List<T> items;
  final int pageIndex;
  final int pageSize;

  Paging({
    required this.totalCount,
    required this.items,
    required this.pageIndex,
    required this.pageSize,
  });

  factory Paging.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return Paging<T>(
      totalCount: json['totalCount'],
      items: (json['items'] as List).map((item) => fromJsonT(item)).toList(),
      pageIndex: json['pageIndex'],
      pageSize: json['pageSize'],
    );
  }
}
