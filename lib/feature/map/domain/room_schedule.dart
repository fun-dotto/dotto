final class RoomSchedule {
  const RoomSchedule(this.begin, this.end, this.title);

  factory RoomSchedule.fromFirebase(Map<String, dynamic> map) {
    final beginDatetime = DateTime.parse(map['begin_datetime'] as String);
    final endDatetime = DateTime.parse(map['end_datetime'] as String);
    final title = map['title'];
    return RoomSchedule(beginDatetime, endDatetime, title as String);
  }
  final DateTime begin;
  final DateTime end;
  final String title;
}
