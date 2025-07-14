import 'package:dotto/feature/announcement/domain/news_model.dart';
import 'package:dotto/feature/announcement/repository/news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsListProvider =
    AsyncNotifierProvider<NewsListNotifier, List<News>>(NewsListNotifier.new);

final class NewsListNotifier extends AsyncNotifier<List<News>> {
  @override
  Future<List<News>> build() async {
    return NewsRepository().getNewsListFromFirestore();
  }
}
