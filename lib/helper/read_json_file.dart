import 'dart:io';

import 'package:dotto/helper/local_repository.dart';

Future<String> readJsonFile(String fileName) async {
  final filePath = await LocalRepository().getApplicationFilePath(fileName);
  final file = File(filePath);

  // ファイルの存在確認
  if (file.existsSync()) {
    // ファイルの内容を文字列として読み込む
    final content = await file.readAsString();
    if (content == '') {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return readJsonFile(fileName);
    }
    return content;
  } else {
    throw Exception('File does not exist');
  }
}
