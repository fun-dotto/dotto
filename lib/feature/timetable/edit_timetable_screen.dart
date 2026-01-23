import 'package:collection/collection.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/controller/selected_semester_controller.dart';
import 'package:dotto/feature/timetable/controller/timetable_view_style_controller.dart';
import 'package:dotto/feature/timetable/controller/week_period_all_records_controller.dart';
import 'package:dotto/feature/timetable/domain/period.dart';
import 'package:dotto/feature/timetable/domain/semester.dart';
import 'package:dotto/feature/timetable/select_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class EditTimetableScreen extends ConsumerStatefulWidget {
  const EditTimetableScreen({super.key});

  @override
  ConsumerState<EditTimetableScreen> createState() =>
      _EditTimetableScreenState();
}

class _EditTimetableScreenState extends ConsumerState<EditTimetableScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialSemester = ref.read(selectedSemesterProvider);
    _tabController = TabController(
      length: Semester.values.length,
      vsync: this,
      initialIndex: Semester.values.indexOf(initialSemester),
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      return;
    }
    final current = ref.read(selectedSemesterProvider);
    final selected = Semester.values[_tabController.index];
    if (current != selected) {
      ref.read(selectedSemesterProvider.notifier).value = selected;
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabSelection)
      ..dispose();
    super.dispose();
  }

  Widget _tableText(
    BuildContext context,
    DayOfWeek dayOfWeek,
    Period period,
    Semester semester,
    List<Map<String, dynamic>> records,
  ) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    return personalLessonIdList.when(
      data: (data) {
        final selectedLessonList = records.where((record) {
          return record['week'] == dayOfWeek.number &&
              record['period'] == period.number &&
              (record['開講時期'] == semester.number || record['開講時期'] == 0) &&
              data.contains(record['lessonId']);
        }).toList();
        return InkWell(
          // 表示
          child: Container(
            margin: const EdgeInsets.all(2),
            height: 100,
            child: selectedLessonList.isNotEmpty
                ? Column(
                    children: selectedLessonList
                        .map(
                          (lesson) => Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                lesson['授業名'] as String,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.grey.shade400),
                    ),
                  ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SelectCourseScreen(semester, dayOfWeek, period),
                settings: RouteSettings(
                  name:
                      '/home/edit_timetable/select_course?semester=${semester.number}&dayOfWeek=${dayOfWeek.number}&period=${period.number}',
                ),
              ),
            );
          },
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget _takingCourseTable(Semester semester) {
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: weekPeriodAllRecords.when(
          data: (data) => Table(
            columnWidths: const <int, TableColumnWidth>{
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FlexColumnWidth(),
              4: FlexColumnWidth(),
              5: FlexColumnWidth(),
              6: FlexColumnWidth(),
            },
            children: <TableRow>[
              TableRow(
                children: DayOfWeek.weekdays
                    .map(
                      (e) => TableCell(
                        child: Center(
                          child: Text(
                            e.label,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ...Period.values.map(
                (period) => TableRow(
                  children: DayOfWeek.weekdays
                      .map(
                        (dayOfWeek) => _tableText(
                          context,
                          dayOfWeek,
                          period,
                          semester,
                          data,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          error: (error, stackTrace) =>
              const Center(child: Text('データの取得に失敗しました')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _takingCourseList(Semester semester) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    final weekPeriodAllRecords = ref.watch(weekPeriodAllRecordsProvider);
    return weekPeriodAllRecords.when(
      data: (data) {
        return personalLessonIdList.when(
          data: (personalLessonIdListData) {
            final seasonList = data
                .where((record) {
                  return personalLessonIdListData.contains(
                        record['lessonId'],
                      ) &&
                      (record['開講時期'] == semester.number ||
                          record['開講時期'] == 0);
                })
                .toList()
                .sorted((a, b) {
                  final dayCompare = (a['week'] as int).compareTo(
                    b['week'] as int,
                  );
                  if (dayCompare != 0) {
                    return dayCompare;
                  }
                  return (a['period'] as int).compareTo(b['period'] as int);
                });
            return ListView.separated(
              itemCount: seasonList.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(seasonList[index]['授業名'] as String),
                  subtitle: Text(
                    '${DayOfWeek.fromNumber(seasonList[index]['week'] as int).label}'
                    '${Period.fromNumber(seasonList[index]['period'] as int).number}',
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) =>
              const Center(child: Text('データの取得に失敗しました')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget _timetable(Semester semester) {
    final timetableViewStyle = ref.watch(timetableViewStyleProvider);
    switch (timetableViewStyle) {
      case TimetableViewStyle.table:
        return _takingCourseTable(semester);
      case TimetableViewStyle.list:
        return _takingCourseList(semester);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timetableViewStyle = ref.watch(timetableViewStyleProvider);
    final selectedSemester = ref.watch(selectedSemesterProvider);
    final selectedIndex = Semester.values.indexOf(selectedSemester);
    if (_tabController.index != selectedIndex &&
        !_tabController.indexIsChanging) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        if (_tabController.index != selectedIndex) {
          _tabController.animateTo(selectedIndex);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('時間割'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(timetableViewStyleProvider.notifier).toggle();
            },
            icon: timetableViewStyle.icon,
          ),
        ],
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          tabs: Semester.values.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: Semester.values.map(_timetable).toList(),
      ),
    );
  }
}
