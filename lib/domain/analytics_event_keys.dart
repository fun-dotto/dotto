enum AnalyticsEventKeys {
  assignmentSetup(key: 'assignment_setup'),
  assignmentFetch(key: 'assignment_fetch'),
  assignmentMarkAsDone(key: 'assignment_mark_as_done'),
  assignmentMarkAsNotDone(key: 'assignment_mark_as_not_done'),
  assignmentTurnOnNotification(key: 'assignment_turn_on_notification'),
  assignmentTurnOffNotification(key: 'assignment_turn_off_notification'),
  assignmentMarkAsShown(key: 'assignment_mark_as_shown'),
  assignmentMarkAsHidden(key: 'assignment_mark_as_hidden'),

  timetablePeriodStyleBuilt(key: 'timetable_period_style_built'),
  timetablePeriodStyleChanged(key: 'timetable_period_style_changed');

  const AnalyticsEventKeys({required this.key});

  final String key;
}
