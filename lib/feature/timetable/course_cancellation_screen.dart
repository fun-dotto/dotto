import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/timetable/controller/course_cancellation_controller.dart';
import 'package:dotto/feature/timetable/controller/is_filtered_only_taking_course_cancellation_controller.dart';
import 'package:dotto/feature/timetable/domain/course_cancellation.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class CourseCancellationScreen extends ConsumerWidget {
  const CourseCancellationScreen({super.key});

  Widget createListView(List<CourseCancellation> list) {
    if (list.isEmpty) {
      return const Center(child: Text('休講・補講はありません。'));
    }
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (_, _) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final item = list[index];
        return ListTile(
          title: Text(
            '${item.date} ${item.period}限',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${item.lessonName}\n'
            '${item.comment}',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('休講・補講')),
        body: const Center(child: Text('Googleアカウント(@fun.ac.jp)ログインが必要です。')),
      );
    }
    final courseCancellations = ref.watch(courseCancellationNotifierProvider);
    final isFilteredOnlyTakingCourseCancellation = ref.watch(
      isFilteredOnlyTakingCourseCancellationNotifierProvider,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('休講・補講'),
        actions: <Widget>[
          DottoButton(
            onPressed: () {
              ref
                  .read(
                    isFilteredOnlyTakingCourseCancellationNotifierProvider
                        .notifier,
                  )
                  .toggle();
            },
            type: DottoButtonType.text,
            child: Row(
              spacing: 4,
              children: [
                Icon(
                  isFilteredOnlyTakingCourseCancellation
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined,
                ),
                Text(isFilteredOnlyTakingCourseCancellation ? '履修中' : 'すべて'),
              ],
            ),
          ),
        ],
      ),
      body: courseCancellations.when(
        data: createListView,
        error: (error, stackTrace) =>
            const Center(child: Text('データの取得に失敗しました。')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
