import 'package:dotto/feature/announcement/domain/news_model.dart';
import 'package:dotto/importer.dart';

final newsFromPushNotificationProvider =
    NotifierProvider<NewsFromPushNotificationNotifier, String?>(() {
  return NewsFromPushNotificationNotifier();
});
final newsListProvider = NotifierProvider<NewsListNotifier, List<News>?>(() {
  return NewsListNotifier();
});

final class NewsFromPushNotificationNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  String? get newsId => state;
  
  set newsId(String? value) {
    state = value;
  }

  void reset() {
    state = null;
  }
}

final class NewsListNotifier extends Notifier<List<News>?> {
  @override
  List<News>? build() {
    return null;
  }

  List<News>? get news => state;
  
  set news(List<News>? value) {
    state = value;
  }
}
