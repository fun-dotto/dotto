final class Assignment {
  Assignment(
    this.id,
    this.courseId,
    this.courseName,
    this.name,
    this.url,
    this.starttime,
    this.endtime,
  );

  factory Assignment.fromFirebase(String id, Map<String, dynamic> data) {
    return Assignment(
        int.parse(id),
        data['course_id'] as int?,
        data['course_name'] as String?,
        data['name'] as String?,
        data['url'] as String?,
        data['starttime'] == 0
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                (data['starttime'] as int) * 1000),
        data['endtime'] == 0
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                (data['endtime'] as int) * 1000));
  }
  final int? id;
  final int? courseId;
  final String? courseName;
  final String? name;
  final String? url;
  final DateTime? starttime;
  final DateTime? endtime;
}
