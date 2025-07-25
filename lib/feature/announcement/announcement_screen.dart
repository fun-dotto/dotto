import 'package:dotto/feature/announcement/controller/announcements_controller.dart';
import 'package:dotto/feature/announcement/widget/announcement_list.dart';
import 'package:dotto/widget/loading_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('お知らせ'),
      ),
      body: announcements.when(
        data: (data) {
          return AnnouncementList(announcements: data);
        },
        error: (error, stackTrace) {
          return Container(
            alignment: Alignment.center,
            child: const Text('エラーが発生しました'),
          );
        },
        loading: () {
          return const LoadingCircular();
        },
      ),
    );
  }
}
