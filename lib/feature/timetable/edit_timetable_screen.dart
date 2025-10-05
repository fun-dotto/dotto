import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/controller/week_period_all_records_controller.dart';
import 'package:dotto/feature/timetable/select_course_screen.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class EditTimetableScreen extends ConsumerWidget {
  const EditTimetableScreen({super.key});

  Future<void> seasonTimetable(BuildContext context, WidgetRef ref) async {
    final personalLessonIdList = ref.watch(
      personalLessonIdListNotifierProvider,
    );
    final weekPeriodAllRecords = ref.watch(
      weekPeriodAllRecordsNotifierProvider,
    );
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('履修中の科目'),
            content: SizedBox(
              width: double.maxFinite,
              child: weekPeriodAllRecords.when(
                data: (data) {
                  return personalLessonIdList.when(
                    data: (personalLessonIdListData) {
                      final seasonList = data.where((record) {
                        return personalLessonIdListData.contains(
                          record['lessonId'],
                        );
                      }).toList();
                      return ListView.builder(
                        itemCount: seasonList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(seasonList[index]['授業名'] as String),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return const Center(child: Text('データを取得できませんでした'));
                    },
                    loading: () {
                      return const Center(child: LoadingCircular());
                    },
                  );
                },
                error: (_, _) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              ),
            ),
          );
        },
      );
    }
  }

  Widget tableText(
    BuildContext context,
    WidgetRef ref,
    String name,
    int week,
    int period,
    int term,
    List<Map<String, dynamic>> records,
  ) {
    final personalLessonIdList = ref.watch(
      personalLessonIdListNotifierProvider,
    );
    return personalLessonIdList.when(
      data: (data) {
        final selectedLessonList = records.where((record) {
          return record['week'] == week &&
              record['period'] == period &&
              (record['開講時期'] == term || record['開講時期'] == 0) &&
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
                                border: Border.all(color: Colors.grey),
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                lesson['授業名'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 8),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.grey.shade400),
                    ),
                  ),
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder<void>(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SelectCourseScreen(term, week, period),
                transitionsBuilder: fromRightAnimation,
              ),
            );
          },
        );
      },
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget seasonTimetableList(
    BuildContext context,
    WidgetRef ref,
    int seasonnumber,
  ) {
    final weekPeriodAllRecords = ref.watch(
      weekPeriodAllRecordsNotifierProvider,
    );
    final weekString = ['月', '火', '水', '木', '金'];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                children: weekString
                    .map(
                      (e) => TableCell(
                        child: Center(
                          child: Text(e, style: const TextStyle(fontSize: 10)),
                        ),
                      ),
                    )
                    .toList(),
              ),
              for (int i = 1; i <= 6; i++) ...{
                TableRow(
                  children: [
                    for (int j = 1; j <= 5; j++) ...{
                      tableText(
                        context,
                        ref,
                        '${weekString[j - 1]}曜$i限',
                        j,
                        i,
                        seasonnumber,
                        data,
                      ),
                    },
                  ],
                ),
              },
            ],
          ),
          error: (error, stackTrace) =>
              const Center(child: Text('データを取得できませんでした。')),
          loading: () => const Center(child: LoadingCircular()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('時間割'),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                return IconButton(
                  onPressed: () {
                    seasonTimetable(context, ref);
                  },
                  icon: const Icon(Icons.list),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '前期'),
              Tab(text: '後期'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            seasonTimetableList(context, ref, 10),
            seasonTimetableList(context, ref, 20),
          ],
        ),
      ),
    );
  }
}
