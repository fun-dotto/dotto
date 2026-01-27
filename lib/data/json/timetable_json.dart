import 'dart:convert';

import 'package:dotto/helper/read_json_file.dart';

final class TimetableJSON {
  /// 1週間分の授業スケジュールを取得
  static Future<List<dynamic>> fetchOneWeekSchedule() async {
    try {
      final jsonString = await readJsonFile('map/oneweek_schedule.json');
      return json.decode(jsonString) as List<dynamic>;
    } on Exception {
      return [];
    }
  }

  /// 休講情報を取得
  static Future<List<dynamic>> fetchCancelLectures() async {
    try {
      final jsonData = await readJsonFile('home/cancel_lecture.json');
      return jsonDecode(jsonData) as List<dynamic>;
    } on Exception {
      return [];
    }
  }

  /// 補講情報を取得
  static Future<List<dynamic>> fetchSupLectures() async {
    try {
      final jsonData = await readJsonFile('home/sup_lecture.json');
      return jsonDecode(jsonData) as List<dynamic>;
    } on Exception {
      return [];
    }
  }
}
