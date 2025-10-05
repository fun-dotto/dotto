import 'package:dotto/feature/announcement/domain/announcement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class AnnouncementList extends StatelessWidget {
  const AnnouncementList({required this.announcements, super.key});

  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: announcements.length,
      separatorBuilder: (_, _) => const Divider(height: 0),
      itemBuilder: (_, index) {
        final announcement = announcements[index];
        return ListTile(
          title: Text(
            announcement.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            DateFormat.yMMMd().add_jm().format(announcement.date),
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () {
            launchUrlString(announcement.url);
          },
          trailing: const Icon(Icons.chevron_right_outlined),
        );
      },
    );
  }
}
