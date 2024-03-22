class ModelMonth {
  final String date;
  double savings;

  ModelMonth({required this.date, this.savings = 0});

  Map<String, dynamic> toMap() {
    return {'date': date};
  }
}
