final class TimeTableCourse {
  TimeTableCourse(this.lessonId, this.title, this.resourseIds,
      {this.cancel = false, this.sup = false});
  final int lessonId;
  final String title;
  final List<int> resourseIds;
  final bool cancel;
  final bool sup;

  /// Create a copy of this course with sup set to true
  TimeTableCourse withSup() {
    return TimeTableCourse(
      lessonId,
      title,
      resourseIds,
      cancel: cancel,
      sup: true,
    );
  }

  @override
  String toString() {
    return '$lessonId $title $resourseIds';
  }
}
