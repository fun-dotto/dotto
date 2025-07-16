import 'dart:io';
import 'dart:typed_data';
import 'package:dotto/repository/get_application_path.dart';
import 'package:firebase_storage/firebase_storage.dart';

final class FirebaseStorageRepository {
  factory FirebaseStorageRepository() {
    return _instance;
  }
  FirebaseStorageRepository._internal();
  static final FirebaseStorageRepository _instance =
      FirebaseStorageRepository._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _baseUrl = 'gs://swift2023groupc.appspot.com';

  Future<void> download(String path) async {
    final ref = _storage.refFromURL('$_baseUrl/$path');
    final localPath = await getApplicationFilePath(path);
    final file = File(localPath);
    if (!file.existsSync()) {
      await file.create();
    }
    await ref.writeToFile(file);
  }

  Future<Uint8List?> getData(String path) async {
    final ref = _storage.refFromURL('$_baseUrl/$path');
    return ref.getData();
  }
}
