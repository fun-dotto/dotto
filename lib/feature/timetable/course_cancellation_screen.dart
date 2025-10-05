import 'dart:convert';

import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/feature/timetable/controller/is_filtered_only_taking_course_cancellation_controller.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:dotto/repository/read_json_file.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class CourseCancellationScreen extends ConsumerWidget {
  const CourseCancellationScreen({super.key});

  Future<List<dynamic>> loadData(WidgetRef ref) async {
    final isFilteredOnlyTakingCourseCancellation = ref.watch(
      isFilteredOnlyTakingCourseCancellationNotifierProvider,
    );
    try {
      final jsonData = await readJsonFile('home/cancel_lecture.json');
      final decodedData = jsonDecode(jsonData) as List<dynamic>;

      if (isFilteredOnlyTakingCourseCancellation) {
        final personalTimetableMap = await TimetableRepository()
            .loadPersonalTimetableMapString();
        final filteredData = decodedData.where((dynamic item) {
          final itemMap = item as Map<String, dynamic>;
          return personalTimetableMap.keys.contains(
            itemMap['lessonName'] as String,
          );
        }).toList();
        return filteredData;
      } else {
        return decodedData;
      }
    } on Exception {
      return [];
    }
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
      body: FutureBuilder<List<dynamic>>(
        future: loadData(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('エラー: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return createListView(snapshot.data!);
            }
          }
          return const Center(child: LoadingCircular());
        },
      ),
    );
  }

  Widget createListView(List<dynamic> data) {
    if (data.isNotEmpty) {
      return Expanded(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index] as Map<String, dynamic>;
            return ListTile(
              title: Text(
                '${item['date']} ${item['period']}限',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${item['lessonName']}\n'
                '${item['comment']}',
              ),
            );
          },
        ),
      );
    } else {
      return const Center(child: Text('休講・補講はありません。'));
    }
  }
}
