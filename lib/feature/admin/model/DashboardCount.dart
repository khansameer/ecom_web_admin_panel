class DashboardCount {
  final String name;
  final int count;

  DashboardCount({required this.name, required this.count});

  factory DashboardCount.fromJson(String key, dynamic value) {
    return DashboardCount(
      name: key,
      count: value as int,
    );
  }
}