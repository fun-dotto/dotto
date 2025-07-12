import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/feature/announcement/domain/news_model.dart';

final class NewsRepository {
  factory NewsRepository() {
    return _instance;
  }
  NewsRepository._internal();
  static final NewsRepository _instance = NewsRepository._internal();

  Future<List<News>> getNewsListFromFirestore() async {
    final data = await FirebaseFirestore.instance
        .collection('news')
        .where('isactive', isEqualTo: true)
        .orderBy('date', descending: true)
        .get();
    return data.docs.map((snapshot) {
      final d = snapshot.data();
      final news = News(
          snapshot.id,
          d['title'] as String,
          List<String>.from(d['body'] as List),
          (d['date'] as Timestamp).toDate(),
          image: (d['image'] as bool?) ?? false);
      return news;
    }).toList();
  }
}
