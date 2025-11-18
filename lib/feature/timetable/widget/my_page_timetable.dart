import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_screen.dart';
import 'package:dotto/feature/timetable/controller/focused_timetable_date_controller.dart';
import 'package:dotto/feature/timetable/controller/timetable_period_style_controller.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/domain/period.dart';
import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/feature/timetable/domain/timetable_period_style.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final class MyPageTimetable extends ConsumerWidget {
  const MyPageTimetable({super.key});

  Widget timetableLessonButton(
    BuildContext context,
    WidgetRef ref,
    TimetableCourse? timetableCourse,
  ) {
    final user = ref.watch(userProvider);
    var foregroundColor = Colors.black;
    if (timetableCourse != null && user != null) {
      if (timetableCourse.cancel) {
        foregroundColor = Colors.grey;
      }
    }
    final roomName = <int, String>{
      1: '講堂',
      2: '大講義室',
      3: '493',
      4: '593',
      5: '594',
      6: '595',
      7: 'R791',
      8: '494C&D',
      9: '495C&D',
      10: '484',
      11: '583',
      12: '584',
      13: '585',
      14: 'R781',
      15: 'R782',
      16: '363',
      17: '364',
      18: '365',
      19: '483',
      50: 'アトリエ',
      51: '体育館',
      90: 'その他',
      99: 'オンライン',
    };
    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: (timetableCourse == null)
            ? null
            : () async {
                final record = await TimetableRepository().fetchDB(
                  timetableCourse.lessonId,
                );
                if (record == null) return;
                if (context.mounted) {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => KamokuDetailScreen(
                        lessonId: record['LessonId'] as int,
                        lessonName: record['授業名'] as String,
                        kakomonLessonId: record['過去問'] as int?,
                      ),
                      settings: RouteSettings(
                        name:
                            '/course_detail?lessonId=${record['LessonId'] as int}&lessonName=${record['授業名'] as String}&kakomonLessonId=${record['過去問'] as int?}',
                      ),
                    ),
                  );
                }
              },
        child: Material(
          elevation: 1,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 科目名表示など
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (timetableCourse != null) ? timetableCourse.title : '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (timetableCourse != null)
                        Text(
                          timetableCourse.resourseIds
                              .map(
                                (resourceId) => roomName.containsKey(resourceId)
                                    ? roomName[resourceId]
                                    : null,
                              )
                              .toList()
                              .join(', '),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                // 休講情報など
                if (timetableCourse != null && user != null)
                  if (timetableCourse.cancel)
                    _canceledLabel()
                  else if (timetableCourse.sup)
                    _madeUpLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _canceledLabel() {
    return const Row(
      children: [
        Icon(Icons.cancel_outlined, color: Colors.red),
        Text('休講', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _madeUpLabel() {
    return const Row(
      children: [
        Icon(Icons.info_outline, color: Colors.orange),
        Text('補講', style: TextStyle(color: Colors.orange)),
      ],
    );
  }

  Widget timetablePeriod(
    BuildContext context,
    WidgetRef ref,
    Period period,
    List<TimetableCourse> timetableCourseList,
  ) {
    final timetablePeriodStyle = ref.watch(
      timetablePeriodStyleNotifierProvider,
    );
    return timetablePeriodStyle.when(
      data: (style) {
        return Row(
          spacing: 8,
          children: [
            SizedBox(
              width: style == TimetablePeriodStyle.numberOnly ? 24 : 64,
              child: Column(
                spacing: 4,
                children: [
                  Text(period.number.toString()),
                  if (style == TimetablePeriodStyle.numberAndTime)
                    Text(
                      '${period.startTime.format(context)} - ${period.endTime.format(context)}',
                      style: const TextStyle(fontSize: 10),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 8,
                children: [
                  if (timetableCourseList.isEmpty)
                    timetableLessonButton(context, ref, null)
                  else
                    ...timetableCourseList.map(
                      (timetableCourse) =>
                          timetableLessonButton(context, ref, timetableCourse),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }

  Widget _datePicker(BuildContext context, WidgetRef ref) {
    final dates = TimetableRepository().getDateRange();
    final deviceWidth = MediaQuery.of(context).size.width;
    const double buttonSize = 50;
    const double buttonPadding = 8;
    final deviceCenter = deviceWidth / 2 - (buttonSize / 2 + buttonPadding);
    final buttonPosition =
        (DateTime.now().weekday - 1) * (buttonSize + buttonPadding);
    final initialScrollOffset = (buttonPosition > deviceCenter)
        ? buttonPosition - deviceCenter
        : 0;
    final controller = ScrollController(
      initialScrollOffset: initialScrollOffset.toDouble(),
    );
    final focusTimetableDay = ref.watch(focusedTimetableDateNotifierProvider);
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: buttonPadding / 2,
          children: dates.map((date) {
            return ElevatedButton(
              onPressed: () async {
                ref.read(focusedTimetableDateNotifierProvider.notifier).value =
                    date;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: focusTimetableDay.day == date.day
                    ? customFunColor
                    : Colors.white,
                foregroundColor: focusTimetableDay.day == date.day
                    ? Colors.white
                    : Colors.black,
                shape: const CircleBorder(
                  side: BorderSide(style: BorderStyle.none),
                ),
                minimumSize: const Size(buttonSize, buttonSize),
                fixedSize: const Size(buttonSize, buttonSize),
                padding: EdgeInsets.zero,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      fontWeight: (focusTimetableDay.day == date.day)
                          ? FontWeight.w600
                          : null,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 10,
                      color: focusTimetableDay.day == date.day
                          ? Colors.white
                          : DayOfWeek.fromDateTime(date).color,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _timetableColumn(BuildContext context, WidgetRef ref) {
    final twoWeekTimetable = ref.watch(twoWeekTimetableNotifierProvider);
    final focusTimetableDay = ref.watch(focusedTimetableDateNotifierProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 8,
        children: List.generate(6, (index) {
          final period = Period.values[index];
          return twoWeekTimetable.when(
            data: (data) {
              return timetablePeriod(
                context,
                ref,
                period,
                data[focusTimetableDay]![index + 1] ?? [],
              );
            },
            error: (error, stackTrace) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 8,
      children: [_datePicker(context, ref), _timetableColumn(context, ref)],
    );
  }
}
