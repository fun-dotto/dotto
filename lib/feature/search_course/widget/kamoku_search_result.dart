import 'package:dotto/feature/kamoku_detail/kamoku_detail_page_view.dart';
import 'package:dotto/feature/search_course/controller/kamoku_search_controller.dart';
import 'package:dotto/feature/search_course/repository/kamoku_search_repository.dart';
import 'package:dotto/feature/timetable/controller/timetable_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:dotto/importer.dart';
import 'package:dotto/theme/v1/animation.dart';
import 'package:dotto/widget/loading_circular.dart';

final class KamokuSearchResults extends ConsumerWidget {
  const KamokuSearchResults({required this.records, super.key});
  final List<Map<String, dynamic>> records;

  Future<Map<int, String>> getWeekPeriod(List<int> lessonIdList) async {
    final records =
        await KamokuSearchRepository().fetchWeekPeriodDB(lessonIdList);
    final weekPeriodMap = <int, Map<int, List<int>>>{};
    for (final record in records) {
      final lessonId = record['lessonId'] as int;
      final week = record['week'] as int;
      final period = record['period'] as int;
      if (weekPeriodMap.containsKey(lessonId)) {
        if (weekPeriodMap[lessonId]!.containsKey(week)) {
          weekPeriodMap[lessonId]![week]!.add(period);
        } else {
          weekPeriodMap[lessonId]![week] = [period];
        }
      } else {
        weekPeriodMap[lessonId] = {
          week: [period]
        };
      }
    }
    final weekPeriodStringMap = weekPeriodMap.map((lessonId, value) {
      final weekString = <String>['', '月', '火', '水', '木', '金', '土', '日'];
      final s = <String>[];
      value.forEach(
        (week, periodList) {
          if (week != 0) {
            s.add('${weekString[week]}${periodList.join()}');
          }
        },
      );
      return MapEntry(lessonId, s.join(','));
    });
    return weekPeriodStringMap;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalLessonIdList = ref.watch(personalLessonIdListProvider);
    final kamokuSearchController = ref.watch(kamokuSearchControllerProvider);
    return FutureBuilder(
      future: getWeekPeriod(records.map((e) => e['LessonId'] as int).toList()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final weekPeriodStringMap = snapshot.data!;
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final lessonId = record['LessonId'] as int;
              return ListTile(
                title: Text(record['授業名'] as String? ?? ''),
                subtitle: Text(weekPeriodStringMap[lessonId] ?? ''),
                onTap: () async {
                  await Navigator.of(context).push(
                    PageRouteBuilder<void>(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return KamokuDetailPageScreen(
                          lessonId: lessonId,
                          lessonName: record['授業名'] as String,
                          kakomonLessonId: record['過去問'] as int?,
                        );
                      },
                      transitionsBuilder: fromRightAnimation,
                    ),
                  );
                  kamokuSearchController.searchBoxFocusNode.unfocus();
                },
                trailing: const Icon(Icons.chevron_right),
                leading: IconButton(
                  icon: Icon(Icons.playlist_add,
                      color: personalLessonIdList.contains(lessonId)
                          ? Colors.green
                          : Colors.black),
                  onPressed: () async {
                    if (!personalLessonIdList.contains(lessonId)) {
                      if (await TimetableRepository()
                          .isOverSeleted(lessonId, ref)) {
                        if (context.mounted) {
                          timetableIsOverSelectedSnackBar(context);
                        }
                      } else {
                        TimetableRepository()
                            .addPersonalTimeTableList(lessonId, ref)
                            .ignore();
                      }
                    } else {
                      TimetableRepository()
                          .removePersonalTimeTableList(lessonId, ref)
                          .ignore();
                    }
                    ref.read(twoWeekTimeTableDataProvider.notifier).state =
                        await TimetableRepository().get2WeekLessonSchedule(ref);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: 0,
            ),
          );
        } else {
          return const Center(
            child: LoadingCircular(),
          );
        }
      },
    );
  }
}
