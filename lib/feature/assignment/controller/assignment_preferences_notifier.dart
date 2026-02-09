import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/assignment/domain/assignment_state.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'assignment_preferences_notifier.g.dart';

@Riverpod(keepAlive: true)
class AssignmentPreferencesNotifier extends _$AssignmentPreferencesNotifier {
  Future<void>? _initialization;

  @override
  AssignmentState build() {
    _initialization ??= _loadLists();
    return AssignmentState();
  }

  Future<void> ensureInitialized() async {
    if (_initialization != null) {
      await _initialization;
      return;
    }
    _initialization = _loadLists();
    await _initialization;
  }

  Future<void> reload() {
    _initialization = _loadLists();
    return _initialization!;
  }

  Future<void> _loadLists() async {
    final done = await _loadList(UserPreferenceKeys.kadaiFinishList);
    final alerts = await _loadList(UserPreferenceKeys.kadaiAlertList);
    final hidden = await _loadList(UserPreferenceKeys.kadaiDeleteList);
    state = state.copyWith(doneAssignmentIds: done, alertAssignmentIds: alerts, hiddenAssignmentIds: hidden);
  }

  Future<List<int>> _loadList(UserPreferenceKeys key) async {
    final jsonString = await UserPreferenceRepository.getString(key);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    final decoded = json.decode(jsonString);
    if (decoded is List) {
      return decoded.map((e) => e is int ? e : int.tryParse(e.toString())).whereType<int>().toList()..sort();
    }
    return [];
  }

  Future<void> _saveList(UserPreferenceKeys key, List<int> values) async {
    await UserPreferenceRepository.setString(key, json.encode(values));
  }

  List<int> _sorted(Iterable<int> ids) {
    final list = ids.toList()..sort();
    return list;
  }

  Future<bool> addDone(int id) async {
    await ensureInitialized();
    final updated = {...state.doneAssignmentIds};
    final added = updated.add(id);
    if (!added) return false;
    final list = _sorted(updated);
    state = state.copyWith(doneAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiFinishList, list);
    await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isDone: true);
    return true;
  }

  Future<bool> removeDone(int id) async {
    await ensureInitialized();
    final updated = {...state.doneAssignmentIds};
    final removed = updated.remove(id);
    if (!removed) return false;
    final list = _sorted(updated);
    state = state.copyWith(doneAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiFinishList, list);
    await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isDone: false);
    return true;
  }

  Future<List<int>> setDoneStatus(Iterable<int> ids, bool isDone) async {
    await ensureInitialized();
    final updated = {...state.doneAssignmentIds};
    final changed = <int>[];
    for (final id in ids) {
      if (isDone) {
        if (updated.add(id)) changed.add(id);
      } else {
        if (updated.remove(id)) changed.add(id);
      }
    }
    if (changed.isEmpty) return changed;
    final list = _sorted(updated);
    state = state.copyWith(doneAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiFinishList, list);
    for (final id in changed) {
      await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isDone: isDone);
    }
    return changed;
  }

  Future<bool> addAlert(int id) async {
    await ensureInitialized();
    final updated = {...state.alertAssignmentIds};
    final added = updated.add(id);
    if (!added) return false;
    final list = _sorted(updated);
    state = state.copyWith(alertAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiAlertList, list);
    await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isAlertScheduled: true);
    return true;
  }

  Future<bool> removeAlert(int id) async {
    await ensureInitialized();
    final updated = {...state.alertAssignmentIds};
    final removed = updated.remove(id);
    if (!removed) return false;
    final list = _sorted(updated);
    state = state.copyWith(alertAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiAlertList, list);
    await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isAlertScheduled: false);
    return true;
  }

  Future<List<int>> enableAlerts(Iterable<int> ids) async {
    await ensureInitialized();
    final updated = {...state.alertAssignmentIds};
    final added = <int>[];
    for (final id in ids) {
      if (updated.add(id)) {
        added.add(id);
      }
    }
    if (added.isEmpty) return added;
    final list = _sorted(updated);
    state = state.copyWith(alertAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiAlertList, list);
    for (final id in added) {
      await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isAlertScheduled: true);
    }
    return added;
  }

  Future<List<int>> disableAlerts(Iterable<int> ids) async {
    await ensureInitialized();
    final updated = {...state.alertAssignmentIds};
    final removed = <int>[];
    for (final id in ids) {
      if (updated.remove(id)) {
        removed.add(id);
      }
    }
    if (removed.isEmpty) return removed;
    final list = _sorted(updated);
    state = state.copyWith(alertAssignmentIds: list);
    await _saveList(UserPreferenceKeys.kadaiAlertList, list);
    for (final id in removed) {
      await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isAlertScheduled: false);
    }
    return removed;
  }

  Future<List<int>> hideAssignments(Iterable<int> ids) async {
    await ensureInitialized();
    final hidden = {...state.hiddenAssignmentIds};
    final alerts = {...state.alertAssignmentIds};
    final removedAlerts = <int>[];
    var hiddenChanged = false;
    for (final id in ids) {
      if (hidden.add(id)) {
        hiddenChanged = true;
      }
      if (alerts.remove(id)) {
        removedAlerts.add(id);
      }
    }
    if (!hiddenChanged && removedAlerts.isEmpty) {
      return removedAlerts;
    }
    final hiddenList = _sorted(hidden);
    final alertList = _sorted(alerts);
    state = state.copyWith(hiddenAssignmentIds: hiddenList, alertAssignmentIds: alertList);
    await Future.wait([
      _saveList(UserPreferenceKeys.kadaiDeleteList, hiddenList),
      _saveList(UserPreferenceKeys.kadaiAlertList, alertList),
    ]);
    for (final id in removedAlerts) {
      await ref.read(loggerProvider).logSetAssignmentStatus(assignmentId: id.toString(), isHidden: true);
    }
    return removedAlerts;
  }
}
