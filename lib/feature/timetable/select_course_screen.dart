import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/feature/timetable/controller/personal_lesson_id_list_controller.dart';
import 'package:dotto/feature/timetable/controller/week_period_all_records_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SelectCourseScreen extends ConsumerWidget {
  const SelectCourseScreen(
    this.semester,
    this.dayOfWeek,
    this.period, {
    super.key,
  });

  final Semester semester;
  final DayOfWeek dayOfWeek;
  final Period period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalLessonIdList = ref.watch(
      personalLessonIdListNotifierProvider,
    );
    final weekPeriodAllRecords = ref.watch(
      weekPeriodAllRecordsNotifierProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${semester.label} ${dayOfWeek.label}曜${period.number}限'),
      ),
      body: weekPeriodAllRecords.when(
        data: (data) {
          return personalLessonIdList.when(
            data: (personalLessonIdListData) {
              final termList = data.where((record) {
                return record['week'] ==
                        dayOfWeek.number && // Use dayOfWeek.number
                    record['period'] == period.number && // Use period.number
                    (record['開講時期'] == semester.number || record['開講時期'] == 0);
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
                                    .removePersonalTimetableList(lessonId, ref);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              type: DottoButtonType.outlined,
                              child: const Text('削除'),
                            )
                          : DottoButton(
                              onPressed: () async {
                                if (await TimetableRepository().isOverSeleted(
                                  termList[index]['lessonId'] as int,
                                  ref,
                                )) {
                                  if (context.mounted) {
                                    timetableIsOverSelectedSnackBar(context);
                                  }
                                } else {
                                  await TimetableRepository()
                                      .addPersonalTimetableList(lessonId, ref);
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
      ),
    );
  }
}
