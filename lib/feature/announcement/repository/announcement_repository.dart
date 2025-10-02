import 'dart:convert';

import 'package:dotto/feature/announcement/domain/announcement.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

//
// ignore: one_member_abstracts
abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements(Uri url);
}

final class AnnouncementRepositoryImpl implements AnnouncementRepository {
  @override
  Future<List<Announcement>> getAnnouncements(Uri url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode < 200 || response.statusCode > 299) {
        return [];
      }
      final json = response.body;
      final list = jsonDecode(json) as List<dynamic>;
      final announcements = list
          .map<Announcement>(
              (e) => Announcement.fromJson(e as Map<String, dynamic>))
          .toList();
      return announcements;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
