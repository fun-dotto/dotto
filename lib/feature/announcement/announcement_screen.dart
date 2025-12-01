import 'package:dotto/domain/announcement.dart';
import 'package:dotto/feature/announcement/announcement_view_state.dart';
import 'package:dotto/feature/announcement/announcement_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class AnnouncementScreen extends ConsumerWidget {
  const AnnouncementScreen({super.key});

  Widget _announcementListRow(Announcement announcement) {
    return ListTile(
      title: Text(
        announcement.title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        DateFormat.yMMMd().add_jm().format(announcement.date),
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () => launchUrlString(announcement.url),
      trailing: const Icon(Icons.chevron_right_outlined),
    );
  }

  Widget _body(
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
              return _announcementListRow(announcement);
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
        viewModelAsync,
        onRefresh: () async {
          await ref.read(announcementViewModelProvider.notifier).onRefresh();
        },
      ),
    );
  }
}
