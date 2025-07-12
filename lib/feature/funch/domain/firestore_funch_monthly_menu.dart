final class FirestoreFunchMonthlyMenu {
  final int year;
  final int month;
  final List<int> commonMenuIds;
  final List<String> originalMenuIds;

  FirestoreFunchMonthlyMenu({
    required this.year,
    required this.month,
    required this.commonMenuIds,
    required this.originalMenuIds,
  });

  factory FirestoreFunchMonthlyMenu.fromJson(Map<String, dynamic> json) {
    return FirestoreFunchMonthlyMenu(
      year: json['year'],
      month: json['month'],
      commonMenuIds: json['common_menu_ids'],
      originalMenuIds: json['original_menu_ids'],
    );
  }
}
