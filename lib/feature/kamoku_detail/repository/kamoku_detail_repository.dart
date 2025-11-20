import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/feature/search_course/repository/syllabus_database_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

final class KamokuDetailRepository {
  factory KamokuDetailRepository() {
    return _instance;
  }
  KamokuDetailRepository._internal();
  static final KamokuDetailRepository _instance =
      KamokuDetailRepository._internal();

  Stream<QuerySnapshot<Map<String, dynamic>>> getFeedbackListFromFirestore(
    int lessonId,
  ) {
    return FirebaseFirestore.instance
        .collection('feedback')
        .where('lessonId', isEqualTo: lessonId)
        .snapshots();
  }

  Future<bool> postFeedback(
    int lessonId,
    double? selectedScore,
    String text,
  ) async {
    final userKey = FirebaseAuth.instance.currentUser?.uid;
    if (userKey != '' && selectedScore != null) {
      // Firestoreで同じUserKeyとlessonIdを持つフィードバックを検索
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .where('User', isEqualTo: userKey)
          .where('lessonId', isEqualTo: lessonId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 既存のフィードバックが存在してたらそれを更新
        final docId = querySnapshot.docs[0].id;
        FirebaseFirestore.instance.collection('feedback').doc(docId).update({
          'score': selectedScore,
          'detail': text,
        }).ignore();
      } else {
        // 既存のフィードバックが存在しなかったら新しいドキュメントを作成
        FirebaseFirestore.instance.collection('feedback').add({
          'User': userKey,
          'lessonId': lessonId,
          'score': selectedScore,
          'detail': text,
        }).ignore();
      }
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchDetails(int lessonId) async {
    final dbPath = await SyllabusDatabaseConfig().getDBPath();
    final database = await openDatabase(dbPath);
    final List<Map<String, dynamic>> details = await database.query(
      'detail',
      where: 'LessonId = ?',
      whereArgs: [lessonId],
    );

    if (details.isNotEmpty) {
      return details.first;
    } else {
      throw Exception();
    }
  }
}
