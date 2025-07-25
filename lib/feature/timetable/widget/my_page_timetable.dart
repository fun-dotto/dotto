import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/kamoku_detail/kamoku_detail_page_view.dart';
import 'package:dotto/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/timetable/domain/timetable_course.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/theme/v1/color_fun.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:intl/intl.dart';

final class MyPageTimetable extends ConsumerWidget {
  const MyPageTimetable({super.key});

  Widget timeTableLessonButton(
    BuildContext context,
    TimeTableCourse? timeTableCourse,
    WidgetRef ref, {
    required bool loading,
  }) {
    final user = ref.watch(userProvider);
    var foregroundColor = Colors.black;
    if (timeTableCourse != null && user != null) {
      if (timeTableCourse.cancel) {
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
        onTap: (timeTableCourse == null)
            ? null
            : () async {
                final record = await TimetableRepository()
                    .fetchDB(timeTableCourse.lessonId);
                if (record == null) return;
                if (context.mounted) {
                  await Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return KamokuDetailPageScreen(
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
          elevation: 2,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 科目名表示など
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: loading
                        ? [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: LoadingCircular(),
                            )
                          ]
                        : [
                            Text(
                              (timeTableCourse != null)
                                  ? timeTableCourse.title
                                  : '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: foregroundColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (timeTableCourse != null)
                              Text(
                                timeTableCourse.resourseIds
                                    .map((resourceId) =>
                                        roomName.containsKey(resourceId)
                                            ? roomName[resourceId]
                                            : null)
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
                if (timeTableCourse != null && user != null)
                  if (timeTableCourse.cancel)
                    const Row(
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                        Text(
                          '休講',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    )
                  else if (timeTableCourse.sup)
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                        ),
                        Text(
                          '補講',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget timeTablePeriod(
      BuildContext context,
      int period,
      TimeOfDay beginTime,
      TimeOfDay finishTime,
      List<TimeTableCourse> timeTableCourseList,
      WidgetRef ref, {
      required bool loading,
    }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: timeTableCourseList.isEmpty
          ? 40
          : timeTableCourseList.length * 50 - 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 70,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$period限'),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${beginTime.format(context)} ~ '
                    '${finishTime.format(context)}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (timeTableCourseList.isEmpty)
                  timeTableLessonButton(context, null, ref, loading: loading)
                else
                  ...timeTableCourseList.map((timeTableCourse) =>
                      timeTableLessonButton(
                          context, timeTableCourse, ref, loading: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void setFocusTimeTableDay(DateTime dt, WidgetRef ref) {
    ref.read(focusTimeTableDayProvider.notifier).state = dt;
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
      Colors.red
    ];
    final deviceWidth = MediaQuery.of(context).size.width;
    const double buttonSize = 50;
    const double buttonPadding = 8;
    final deviceCenter = deviceWidth / 2 - (buttonSize / 2 + buttonPadding);
    final buttonPosition =
        (DateTime.now().weekday - 1) * (buttonSize + buttonPadding);
    final initialScrollOffset =
        (buttonPosition > deviceCenter) ? buttonPosition - deviceCenter : 0;
    final controller =
        ScrollController(initialScrollOffset: initialScrollOffset.toDouble());
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(saveTimetableProvider);
        final twoWeekTimeTableData = ref.watch(twoWeekTimeTableDataProvider);
        final focusTimeTableDay = ref.watch(focusTimeTableDayProvider);
        return Column(
          children: [
            SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: buttonPadding, horizontal: buttonPadding / 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: dates.map((date) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: buttonPadding / 2),
                      child: ElevatedButton(
                        onPressed: () async {
                          setFocusTimeTableDay(date, ref);
                        },
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Colors.white,
                          backgroundColor: focusTimeTableDay.day == date.day
                              ? customFunColor
                              : Colors.white,
                          foregroundColor: focusTimeTableDay.day == date.day
                              ? Colors.white
                              : Colors.black,
                          shape: const CircleBorder(
                            side: BorderSide(),
                          ),
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
                                fontWeight: (focusTimeTableDay.day == date.day)
                                    ? FontWeight.bold
                                    : null,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              weekString[date.weekday - 1],
                              style: TextStyle(
                                fontSize: 9,
                                color: focusTimeTableDay.day == date.day
                                    ? Colors.white
                                    : weekColors[date.weekday - 1],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // 時間割表示
            for (int i = 1; i <= 6; i++) ...{
              timeTablePeriod(
                  context,
                  i,
                  beginPeriod[i - 1],
                  finishPeriod[i - 1],
                  twoWeekTimeTableData != null
                      ? twoWeekTimeTableData.isNotEmpty
                          ? twoWeekTimeTableData[focusTimeTableDay]![i] ?? []
                          : []
                      : [],
                  ref,
                  loading: twoWeekTimeTableData == null)
            },
          ],
        );
      },
    );
  }
}
