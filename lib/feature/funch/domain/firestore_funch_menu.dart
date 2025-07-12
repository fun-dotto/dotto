import 'package:cloud_firestore/cloud_firestore.dart';

final class FirestoreFunchMenu {

  FirestoreFunchMenu({
    required this.date,
    required this.commonMenuIds,
    required this.originalMenuIds,
  });

  factory FirestoreFunchMenu.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw ArgumentError('JSON cannot be empty');
    }
    if (!json.containsKey('date') ||
        !json.containsKey('common_menu_ids') ||
        !json.containsKey('original_menu_ids')) {
      throw ArgumentError('JSON must contain date, common_menu_ids, and original_menu_ids keys');
    }
    final timestamp = json['date'];
    if (timestamp is! Timestamp) {
      throw ArgumentError('date must be a Timestamp');
    }
    return FirestoreFunchMenu(
      date: timestamp.toDate(),
      commonMenuIds: List<int>.from(json['common_menu_ids']),
      originalMenuIds: List<String>.from(json['original_menu_ids']),
    );
  }
  final DateTime date; // Monthly: 当月の1日 (JST), Daily: 当日の0時 (JST)
  final List<int> commonMenuIds;
  final List<String> originalMenuIds;
}
