import 'dart:convert';

// 補講の情報を仕分け
Future<Map<String, dynamic>> sortSupplementaryLectures(
    String jsonString) async {
  // JSON文字列をデコードしてMapに変換
  final jsonData = jsonDecode(jsonString);

  // 補講情報を保持するためのMapを初期化
  final sortedCourse = <String, List<dynamic>>{
    'あり': [],
    'なし': [],
    '未定': [],
  };

  for (final course in jsonData as List) {
    final String comment = course['comment'] as String? ?? ''; // nullの場合

    // コメントの内容に応じて分類
    if (comment.contains('補講あり')) {
      sortedCourse['あり']!.add(course);
    } else if (comment.contains('補講なし')) {
      sortedCourse['なし']!.add(course);
    } else if (comment.contains('補講未定')) {
      sortedCourse['未定']!.add(course);
    }
  }

  return sortedCourse;
}
