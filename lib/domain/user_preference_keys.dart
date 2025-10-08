enum UserPreferenceKeys {
  grade(key: 'grade', type: String),
  course(key: 'course', type: String),
  userKey(key: 'userKey', type: String),
  kadaiFinishList(key: 'finishListKey', type: String),
  kadaiAlertList(key: 'alertListKey', type: String),
  kadaiDeleteList(key: 'deleteListKey', type: String),
  personalTimetableListKey(key: 'personalTimetableListKey2025', type: String),
  personalTimetableLastUpdateKey(
    key: 'personalTimetableLastUpdateKey',
    type: int,
  ),
  isAppTutorialComplete(key: 'isAppTutorialCompleted', type: bool),
  isKadaiTutorialComplete(key: 'isKadaiTutorialCompleted', type: bool),
  myBusStop(key: 'myBusStop', type: int),
  didSaveFCMToken(key: 'didSaveFCMToken', type: bool),
  timetablePeriodStyle(key: 'timetablePeriodStyle', type: int);

  const UserPreferenceKeys({required this.key, required this.type});

  final String key;
  final Type type;
}
