import 'package:dotto/domain/announcement.dart';
import 'package:dotto/feature/announcement/announcement_viewmodel.dart';
import 'package:dotto/feature/announcement/announcement_viewstate.dart';
import 'package:dotto/helper/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  Widget _announcementListRow(BuildContext context, Announcement announcement) {
    return ListTile(
      title: Text(announcement.title, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(DateFormatter.full(announcement.date), style: Theme.of(context).textTheme.labelMedium),
      onTap: () => launchUrlString(announcement.url),
      trailing: const Icon(Icons.chevron_right_outlined),
    );
  }

  Widget _body(
    BuildContext context,
    AsyncValue<AnnouncementViewState> viewModelAsync, {
    required Future<void> Function() onRefresh,
  }) {
    switch (viewModelAsync) {
      case AsyncData(:final value):
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.separated(
            itemCount: value.announcements.length,
            separatorBuilder: (_, _) => const Divider(height: 0),
            itemBuilder: (_, index) {
              final announcement = value.announcements[index];
              return _announcementListRow(context, announcement);
            },
          ),
        );
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
      body: _body(
        context,
        viewModelAsync,
        onRefresh: () async {
          await ref.read(announcementViewModelProvider.notifier).onRefresh();
        },
      ),
    );
  }
}
