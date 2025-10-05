import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_screen.dart';
import 'package:dotto/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/timetable/controller/two_week_timetable_controller.dart';
import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/theme/v1/animation.dart';
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
                    PageRouteBuilder<void>(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return KamokuDetailScreen(
                          lessonId: record['LessonId'] as int,
                          lessonName: record['授業名'] as String,
                          kakomonLessonId: record['過去問'] as int?,
                        );
                      },
                      transitionsBuilder: fromRightAnimation,
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
    int period,
    TimeOfDay beginTime,
    TimeOfDay finishTime,
    List<TimetableCourse> timetableCourseList,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: timetableCourseList.isEmpty
          ? 40
          : timetableCourseList.length * 50 - 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          Container(alignment: Alignment.center, child: Text('$period')),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ),
    );
  }

  void setFocusTimetableDay(DateTime dt, WidgetRef ref) {
    ref.read(focusTimetableDayProvider.notifier).state = dt;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const beginPeriod = <TimeOfDay>[
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 40),
      TimeOfDay(hour: 13, minute: 10),
      TimeOfDay(hour: 14, minute: 50),
      TimeOfDay(hour: 16, minute: 30),
      TimeOfDay(hour: 18, minute: 10),
    ];
    const finishPeriod = <TimeOfDay>[
      TimeOfDay(hour: 10, minute: 30),
      TimeOfDay(hour: 12, minute: 10),
      TimeOfDay(hour: 14, minute: 40),
      TimeOfDay(hour: 16, minute: 20),
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 19, minute: 40),
    ];
    final dates = TimetableRepository().getDateRange();
    final weekString = <String>['月', '火', '水', '木', '金', '土', '日'];
    final weekColors = <Color>[
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.blue,
      Colors.red,
    ];
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
    final twoWeekTimetable = ref.watch(twoWeekTimetableNotifierProvider);
    final focusTimetableDay = ref.watch(focusTimetableDayProvider);
    return Column(
      spacing: 8,
      children: [
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: buttonPadding / 2,
              children: dates.map((date) {
                return ElevatedButton(
                  onPressed: () async {
                    setFocusTimetableDay(date, ref);
                  },
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.white,
                    backgroundColor: focusTimetableDay.day == date.day
                        ? customFunColor
                        : Colors.white,
                    foregroundColor: focusTimetableDay.day == date.day
                        ? Colors.white
                        : Colors.black,
                    shape: const CircleBorder(side: BorderSide()),
                    minimumSize: const Size(buttonSize, buttonSize),
                    fixedSize: const Size(buttonSize, buttonSize),
                    padding: EdgeInsets.zero,
                  ),
                  // 日付表示
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          fontWeight: (focusTimetableDay.day == date.day)
                              ? FontWeight.bold
                              : null,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        weekString[date.weekday - 1],
                        style: TextStyle(
                          fontSize: 9,
                          color: focusTimetableDay.day == date.day
                              ? Colors.white
                              : weekColors[date.weekday - 1],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(6, (index) {
              return twoWeekTimetable.when(
                data: (data) {
                  return timetablePeriod(
                    context,
                    ref,
                    index + 1,
                    beginPeriod[index],
                    finishPeriod[index],
                    data.isNotEmpty
                        ? data[focusTimetableDay]![index + 1] ?? []
                        : [],
                  );
                },
                error: (_, _) => const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
              );
            }),
          ),
        ),
      ],
    );
  }
}
