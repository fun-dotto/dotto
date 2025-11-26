import 'package:dotto/feature/announcement/announcement_viewmodel.dart';
import 'package:dotto/feature/announcement/widget/announcement_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(announcementViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('お知らせ')),
      body: viewModel.when(
        data: (data) => AnnouncementList(announcements: data.announcements),
        error: (error, stackTrace) => const Center(child: Text('エラーが発生しました')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
