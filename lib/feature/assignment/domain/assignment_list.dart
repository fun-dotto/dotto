import 'package:dotto/feature/assignment/domain/assignment.dart';

final class AssignmentList {
  AssignmentList(
    this.courseId,
    this.courseName,
    this.endtime,
    this.assignments,
  );

  final int courseId;
  final String courseName;
  final DateTime? endtime;
  List<Assignment> assignments;

  bool isListLength1() {
    return assignments.length == 1;
  }

  Assignment getFirstAssignment() {
    return assignments.first;
  }

  List<Assignment> hiddenAssignment(List<int> deleteList) {
    final returnList = <Assignment>[];
    for (final assignment in assignments) {
      if (!deleteList.contains(assignment.id)) {
        returnList.add(assignment);
      }
    }
    return returnList;
  }
}
