class ModelCategory {
  final String category;
  final String date;
  final double budget;
  final double paid;

  const ModelCategory(
      {required this.category,
      required this.date,
      required this.budget,
      required this.paid});

  Map<String, dynamic> toMap() {
    return {'category': category, 'date': date, 'budget': budget, 'paid': paid};
  }
}
