import 'dart:io';
import 'package:dotto/feature/assignment/assignment_date_formatter.dart';
import 'package:dotto/feature/assignment/controller/assignment_preferences_notifier.dart';
import 'package:dotto/feature/assignment/controller/assignments_controller.dart';
import 'package:dotto/feature/assignment/domain/assignment_state.dart';
import 'package:dotto/feature/assignment/domain/kadai.dart';
import 'package:dotto/feature/assignment/hidden_assignment_list_screen.dart';
import 'package:dotto/feature/assignment/setup_hope_continuity_screen.dart';
import 'package:dotto/feature/setting/controller/settings_controller.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher_string.dart';

final class AssignmentListScreen extends ConsumerStatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  ConsumerState<AssignmentListScreen> createState() =>
      _AssignmentListScreenState();
}

final class _AssignmentListScreenState
    extends ConsumerState<AssignmentListScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _requestIOSPermission();
    } else if (Platform.isAndroid) {
      _requestAndroidPermission();
    }
    _initNotifications();
    // Ensure preferences are loaded once the widget mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(assignmentPreferencesNotifierProvider.notifier)
          .ensureInitialized();
    });
  }

  void _requestIOSPermission() {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _requestAndroidPermission() {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  Future<void> _initNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('payload:${details.payload}');
      },
    );
  }

  Future<void> _zonedScheduleNotification(Kadai kadai) async {
    final end = kadai.endtime;
    final id = kadai.id;
    if (end == null || id == null) return;
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      end.month,
      end.day,
      end.hour,
      end.minute,
    ).subtract(const Duration(days: 1));
    if (scheduledDate.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        id,
        '${kadai.courseName}',
        '${kadai.name}\n締切1日前です',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> _cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> _showDeleteConfirmation(Kadai kadai) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('非表示にしますか？'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(kadai.name ?? ''), Text(kadai.courseName ?? '')],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final id = kadai.id;
                if (id == null) return;
                final removedAlerts = await ref
                    .read(assignmentPreferencesNotifierProvider.notifier)
                    .hideAssignments([id]);
                if (removedAlerts.contains(id)) {
                  await _cancelNotification(id);
                }
              },
              child: const Text('非表示にする'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBulkDeleteConfirmation(KadaiList listKadai) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('非表示にしますか？'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${listKadai.kadaiList.length}個の課題'),
              Text(listKadai.courseName),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final visible = listKadai
                    .hiddenKadai(
                      ref
                          .read(assignmentPreferencesNotifierProvider)
                          .hiddenAssignmentIds,
                    )
                    .map((kadai) => kadai.id)
                    .whereType<int>()
                    .toList();
                final removedAlerts = await ref
                    .read(assignmentPreferencesNotifierProvider.notifier)
                    .hideAssignments(visible);
                for (final id in removedAlerts) {
                  await _cancelNotification(id);
                }
              },
              child: const Text('非表示にする'),
            ),
          ],
        );
      },
    );
  }

  bool _listAllCheck(
    List<int> checklist,
    KadaiList listKadai,
    List<int> hiddenList,
  ) {
    final unchecked = listKadai.hiddenKadai(checklist);
    if (unchecked.isEmpty) {
      return true;
    }
    for (final kadai in unchecked) {
      if (!hiddenList.contains(kadai.id)) {
        return false;
      }
    }
    return true;
  }

  int _unFinishedCount(
    KadaiList listKadai,
    List<int> finishList,
    List<int> hiddenList,
  ) {
    final unfinished = listKadai.hiddenKadai(finishList);
    if (unfinished.isEmpty) {
      return 0;
    }
    var count = 0;
    for (final kadai in unfinished) {
      if (!hiddenList.contains(kadai.id)) {
        count++;
      }
    }
    return count;
  }

  bool _hasUpcomingDeadline(KadaiList listKadai) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 2));
    for (final kadai in listKadai.listKadai) {
      final end = kadai.endtime;
      if (end != null && end.isAfter(today) && end.isBefore(tomorrow)) {
        return true;
      }
    }
    return false;
  }

  bool _canStartActionPane(DateTime? endtime) {
    final threshold = DateTime.now().subtract(const Duration(days: 1));
    if (endtime == null) {
      return false;
    }
    return !endtime.isBefore(threshold);
  }

  TextStyle _titleTextStyle(bool isDone) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: isDone ? Colors.green : null,
    );
  }

  TextStyle _subtitleTextStyle(bool isDone) {
    return TextStyle(fontSize: 12, color: isDone ? Colors.green : null);
  }

  ActionPane _singleStartActionPane(
    AssignmentState assignmentState,
    Kadai kadai,
  ) {
    final notifier = ref.read(assignmentPreferencesNotifierProvider.notifier);
    final isAlertOn = assignmentState.alertAssignmentIds.contains(kadai.id);
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          label: isAlertOn ? '通知 OFF' : '通知 ON',
          backgroundColor: isAlertOn ? Colors.red : Colors.green,
          icon: isAlertOn
              ? Icons.notifications_off_outlined
              : Icons.notifications_active_outlined,
          onPressed: (_) async {
            final id = kadai.id;
            if (id == null) return;
            if (isAlertOn) {
              final removed = await notifier.removeAlert(id);
              if (removed) {
                await _cancelNotification(id);
              }
            } else {
              final added = await notifier.addAlert(id);
              if (added) {
                await _zonedScheduleNotification(kadai);
              }
            }
          },
        ),
      ],
    );
  }

  ActionPane _singleEndActionPane(
    AssignmentState assignmentState,
    Kadai kadai,
  ) {
    final notifier = ref.read(assignmentPreferencesNotifierProvider.notifier);
    final isDone = assignmentState.doneAssignmentIds.contains(kadai.id);
    return ActionPane(
      motion: const StretchMotion(),
      dismissible: DismissiblePane(
        onDismissed: () async {
          final id = kadai.id;
          if (id == null) return;
          final removedAlerts = await notifier.hideAssignments([id]);
          if (removedAlerts.contains(id)) {
            await _cancelNotification(id);
          }
        },
      ),
      children: [
        SlidableAction(
          label: isDone ? '未完了' : '完了',
          backgroundColor: isDone ? Colors.blue : Colors.green,
          icon: Icons.check,
          onPressed: (_) async {
            final id = kadai.id;
            if (id == null) return;
            if (isDone) {
              await notifier.removeDone(id);
            } else {
              await notifier.addDone(id);
            }
          },
        ),
        SlidableAction(
          label: '非表示',
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (_) => _showDeleteConfirmation(kadai),
        ),
      ],
    );
  }

  ActionPane _groupStartActionPane(
    AssignmentState assignmentState,
    KadaiList kadaiList,
  ) {
    final notifier = ref.read(assignmentPreferencesNotifierProvider.notifier);
    final hidden = assignmentState.hiddenAssignmentIds;
    final visible = kadaiList.hiddenKadai(hidden);
    final isAlertOn = _listAllCheck(
      assignmentState.alertAssignmentIds,
      kadaiList,
      hidden,
    );
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: 0.25,
      children: [
        SlidableAction(
          label: isAlertOn ? '通知 OFF' : '通知 ON',
          backgroundColor: isAlertOn ? Colors.red : Colors.green,
          icon: isAlertOn
              ? Icons.notifications_off_outlined
              : Icons.notifications_active_outlined,
          onPressed: (_) async {
            final ids = visible.map((k) => k.id).whereType<int>().toList();
            if (ids.isEmpty) return;
            if (isAlertOn) {
              final removed = await notifier.disableAlerts(ids);
              for (final id in removed) {
                await _cancelNotification(id);
              }
            } else {
              final added = await notifier.enableAlerts(ids);
              for (final kadai in visible) {
                if (kadai.id != null && added.contains(kadai.id)) {
                  await _zonedScheduleNotification(kadai);
                }
              }
            }
          },
        ),
      ],
    );
  }

  ActionPane _groupEndActionPane(
    AssignmentState assignmentState,
    KadaiList kadaiList,
  ) {
    final notifier = ref.read(assignmentPreferencesNotifierProvider.notifier);
    final hidden = assignmentState.hiddenAssignmentIds;
    final visible = kadaiList.hiddenKadai(hidden);
    final isDone = _listAllCheck(
      assignmentState.doneAssignmentIds,
      kadaiList,
      hidden,
    );
    return ActionPane(
      motion: const StretchMotion(),
      dismissible: DismissiblePane(
        onDismissed: () async {
          final ids = visible.map((k) => k.id).whereType<int>().toList();
          if (ids.isEmpty) return;
          final removedAlerts = await notifier.hideAssignments(ids);
          for (final id in removedAlerts) {
            await _cancelNotification(id);
          }
        },
      ),
      children: [
        SlidableAction(
          label: isDone ? '未完了' : '完了',
          backgroundColor: isDone ? Colors.blue : Colors.green,
          icon: Icons.check,
          onPressed: (_) async {
            final ids = visible.map((k) => k.id).whereType<int>().toList();
            if (ids.isEmpty) return;
            await notifier.setDoneStatus(ids, !isDone);
          },
        ),
        SlidableAction(
          label: '非表示',
          backgroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (_) => _showBulkDeleteConfirmation(kadaiList),
        ),
      ],
    );
  }

  Widget _buildList(List<KadaiList> data, AssignmentState state) {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final kadaiList = data[index];
        final hidden = state.hiddenAssignmentIds;
        final visible = kadaiList.hiddenKadai(hidden);
        if (visible.isEmpty) {
          return const SizedBox.shrink();
        }
        if (visible.length == 1) {
          final kadai = visible.first;
          final isDone = state.doneAssignmentIds.contains(kadai.id);
          final hasAlert = state.alertAssignmentIds.contains(kadai.id);
          return Slidable(
            key: ValueKey('single_${kadai.id}_${kadaiList.courseId}'),
            startActionPane: _canStartActionPane(kadai.endtime)
                ? _singleStartActionPane(state, kadai)
                : null,
            endActionPane: _singleEndActionPane(state, kadai),
            child: ListTile(
              title: Text(kadai.name ?? '', style: _titleTextStyle(isDone)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kadai.courseName ?? '',
                    style: _subtitleTextStyle(isDone),
                  ),
                  if (kadai.endtime != null)
                    Text(
                      '${AssignmentDateFormatter.string(kadai.endtime!)} まで',
                      style: _subtitleTextStyle(isDone).copyWith(
                        color: isDone
                            ? Colors.green
                            : _hasUpcomingDeadline(kadaiList)
                            ? Colors.red
                            : null,
                      ),
                    ),
                ],
              ),
              trailing: Icon(
                hasAlert ? Icons.notifications_active : null,
                size: 20,
                color: Colors.green,
              ),
              onTap: () {
                launchUrlString(
                  kadai.url ?? '',
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          );
        }

        final isDoneGroup = _listAllCheck(
          state.doneAssignmentIds,
          kadaiList,
          hidden,
        );
        return Slidable(
          key: ValueKey('group_${kadaiList.courseId}_${kadaiList.endtime}'),
          startActionPane: _canStartActionPane(kadaiList.endtime)
              ? _groupStartActionPane(state, kadaiList)
              : null,
          endActionPane: _groupEndActionPane(state, kadaiList),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                kadaiList.courseName,
                style: _titleTextStyle(isDoneGroup),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_unFinishedCount(kadaiList, state.doneAssignmentIds, hidden)}個の課題',
                    style: _subtitleTextStyle(isDoneGroup),
                  ),
                  if (kadaiList.endtime != null)
                    Text(
                      '${AssignmentDateFormatter.string(kadaiList.endtime!)} まで',
                      style: _subtitleTextStyle(isDoneGroup),
                    )
                  else
                    Text('期限なし', style: _subtitleTextStyle(isDoneGroup)),
                ],
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: visible.map((kadai) {
                    final isDone = state.doneAssignmentIds.contains(kadai.id);
                    final hasAlert = state.alertAssignmentIds.contains(
                      kadai.id,
                    );
                    return Column(
                      children: [
                        const Divider(height: 1),
                        Slidable(
                          key: ValueKey(
                            'child_${kadai.id}_${kadaiList.courseId}',
                          ),
                          startActionPane: _canStartActionPane(kadai.endtime)
                              ? _singleStartActionPane(state, kadai)
                              : null,
                          endActionPane: _singleEndActionPane(state, kadai),
                          child: ListTile(
                            title: Text(
                              kadai.name ?? '',
                              style: _titleTextStyle(isDone),
                            ),
                            trailing: Icon(
                              hasAlert ? Icons.notifications_active : null,
                              size: 20,
                              color: Colors.green,
                            ),
                            onTap: () {
                              launchUrlString(
                                kadai.url ?? '',
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsUserKeyProvider);
    final assignmentState = ref.watch(assignmentPreferencesNotifierProvider);
    final assignments = ref.watch(assignmentsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('課題'),
        centerTitle: false,
        actions: [
          DottoButton(
            onPressed: () async {
              final data = assignments.value;
              if (data == null) return;
              final result = await Navigator.of(context).push(
                MaterialPageRoute<String?>(
                  builder: (_) =>
                      HiddenAssignmentListScreen(deletedKadaiLists: data),
                  settings: const RouteSettings(
                    name: '/hidden_assignment_list',
                  ),
                ),
              );
              if (result == 'back') {
                await ref
                    .read(assignmentPreferencesNotifierProvider.notifier)
                    .reload();
                await ref.read(assignmentsNotifierProvider.notifier).refresh();
              }
            },
            type: DottoButtonType.text,
            child: const Text('非表示リスト'),
          ),
        ],
      ),
      body: RefreshIndicator(
        edgeOffset: 50,
        onRefresh: () async {
          await ref.read(assignmentsNotifierProvider.notifier).refresh();
        },
        child: GestureDetector(
          onPanDown: (_) => Slidable.of(context)?.close(),
          child: assignments.when(
            data: (data) => _buildList(data, assignmentState),
            error: (error, stackTrace) => SetupHopeContinuityScreen(
              onUserKeySaved: () async {
                await ref.read(assignmentsNotifierProvider.notifier).refresh();
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
