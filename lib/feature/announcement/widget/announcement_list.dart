import 'package:dotto/feature/announcement/domain/announcement.dart';
import 'package:dotto/feature/announcement/utility/date_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final class AnnouncementList extends StatelessWidget {
  const AnnouncementList({
    required this.announcements,
    super.key,
  });

  final List<Announcement> announcements;

  Future<void> launchUrlInAppBrowserView(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return ListTile(
          title: Text(announcement.title),
          subtitle: Text(
            DateFormatExtension.formatter.format(announcement.date),
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () => launchUrlInAppBrowserView(Uri.parse(announcement.url)),
          trailing: const Icon(Icons.chevron_right_outlined),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 0,
      ),
    );
  }
}
