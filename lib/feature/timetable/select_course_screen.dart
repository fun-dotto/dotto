import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/controller/week_period_all_records_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SelectCourseScreen extends StatelessWidget {
  const SelectCourseScreen(this.term, this.week, this.period, {super.key});

  final int term;
  final int week;
  final int period;

  @override
  Widget build(BuildContext context) {
    final weekString = ['月', '火', '水', '木', '金'];
    final termString = {10: '前期', 20: '後期'};

    return Scaffold(
      appBar: AppBar(
        title: Text('${termString[term]} ${weekString[week - 1]}曜$period限'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final personalLessonIdList = ref.watch(
            personalLessonIdListNotifierProvider,
          );
          final weekPeriodAllRecords = ref.watch(
            weekPeriodAllRecordsNotifierProvider,
          );
          return weekPeriodAllRecords.when(
            data: (data) {
              return personalLessonIdList.when(
                data: (personalLessonIdListData) {
                  final termList = data.where((record) {
                    return record['week'] == week &&
                        record['period'] == period &&
                        (record['開講時期'] == term || record['開講時期'] == 0);
                  }).toList();
                  if (termList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: termList.length,
                      itemBuilder: (context, index) {
                        final lessonId = termList[index]['lessonId'] as int;
                        return ListTile(
                          title: Text(termList[index]['授業名'] as String),
                          trailing:
                              personalLessonIdListData.contains(
                                termList[index]['lessonId'],
                              )
                              ? DottoButton(
                                  onPressed: () async {
                                    await TimetableRepository()
                                        .removePersonalTimetableList(
                                          lessonId,
                                          ref,
                                        );
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  type: DottoButtonType.outlined,
                                  child: const Text('削除'),
                                )
                              : DottoButton(
                                  onPressed: () async {
                                    if (await TimetableRepository()
                                        .isOverSeleted(
                                          termList[index]['lessonId'] as int,
                                          ref,
                                        )) {
                                      if (context.mounted) {
                                        timetableIsOverSelectedSnackBar(
                                          context,
                                        );
                                      }
                                    } else {
                                      await TimetableRepository()
                                          .addPersonalTimetableList(
                                            lessonId,
                                            ref,
                                          );
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
                                  child: const Text('追加'),
                                ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('対象の科目はありません'));
                  }
                },
                error: (_, _) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              );
            },
            error: (error, stackTrace) =>
                const Center(child: Text('データを取得できませんでした。')),
            loading: () => const Center(child: LoadingCircular()),
          );
        },
      ),
    );
  }
}
