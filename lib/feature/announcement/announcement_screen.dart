import 'package:dotto/feature/announcement/announcement_view_state.dart';
import 'package:dotto/feature/announcement/announcement_viewmodel.dart';
import 'package:dotto/feature/announcement/widget/announcement_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  Widget _body(AsyncValue<AnnouncementViewState> viewModelAsync) {
    switch (viewModelAsync) {
      case AsyncData(:final value):
        return AnnouncementList(announcements: value.announcements);
      case AsyncError(:final error):
        return Center(child: Text('エラーが発生しました: $error'));
      case AsyncLoading():
        return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelAsync = ref.watch(announcementViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('お知らせ')),
      body: _body(viewModelAsync),
    );
  }
}
