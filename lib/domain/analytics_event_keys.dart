enum AnalyticsEventKeys {
  assignmentSetup(name: 'assignment_setup'),
  assignmentFetch(name: 'assignment_fetch'),
  assignmentMarkAsDone(name: 'assignment_mark_as_done'),
  assignmentMarkAsNotDone(name: 'assignment_mark_as_not_done'),
  assignmentTurnOnNotification(name: 'assignment_turn_on_notification'),
  assignmentTurnOffNotification(name: 'assignment_turn_off_notification'),
  assignmentMarkAsShown(name: 'assignment_mark_as_shown'),
  assignmentMarkAsHidden(name: 'assignment_mark_as_hidden'),

  timetablePeriodStyleBuiltWithNumberOnly(
    name: 'timetable_period_style_built_with_number_only',
  ),
  timetablePeriodStyleBuiltWithNumberAndTime(
    name: 'timetable_period_style_built_with_number_and_time',
  ),
  timetablePeriodStyleChangedToNumberOnly(
    name: 'timetable_period_style_changed_to_number_only',
  ),
  timetablePeriodStyleChangedToNumberAndTime(
    name: 'timetable_period_style_changed_to_number_and_time',
  );

  const AnalyticsEventKeys({required this.name});

  final String name;
}
