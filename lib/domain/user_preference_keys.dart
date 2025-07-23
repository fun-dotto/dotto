enum UserPreferenceKeys {
  grade(keyName: 'grade', type: String),
  course(keyName: 'course', type: String),
  userKey(keyName: 'userKey', type: String),
  kadaiFinishList(keyName: 'finishListKey', type: String),
  kadaiAlertList(keyName: 'alertListKey', type: String),
  kadaiDeleteList(keyName: 'deleteListKey', type: String),
  personalTimetableListKey(
      keyName: 'personalTimeTableListKey2025', type: String),
  personalTimetableLastUpdateKey(
      keyName: 'personalTimeTableLastUpdateKey', type: int),
  isAppTutorialComplete(keyName: 'isAppTutorialCompleted', type: bool),
  isKadaiTutorialComplete(keyName: 'isKadaiTutorialCompleted', type: bool),
  myBusStop(keyName: 'myBusStop', type: int),
  didSaveFCMToken(keyName: 'didSaveFCMToken', type: bool);

  const UserPreferenceKeys({
    required this.keyName,
    required this.type,
  });

  final String keyName;
  final Type type;
}
