enum AnalyticsEventKeys {
  assignmentSetup('assignment_setup'),
  assignmentFetch('assignment_fetch'),
  assignmentMarkAsDone('assignment_mark_as_done'),
  assignmentMarkAsNotDone('assignment_mark_as_not_done'),
  assignmentTurnOnNotification('assignment_turn_on_notification'),
  assignmentTurnOffNotification('assignment_turn_off_notification'),
  assignmentMarkAsShown('assignment_mark_as_shown'),
  assignmentMarkAsHidden('assignment_mark_as_hidden');

  const AnalyticsEventKeys(this.name);

  final String name;
}
