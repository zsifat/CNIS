import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chapainawabganjcity/models/news.dart';

import '../service/api_service.dart';

class NewsViewModel extends StateNotifier<AsyncValue<List<News>>> {

  NewsViewModel() : super(const AsyncValue.loading());
  final service = ApiService();

  // Simulate data fetching (could be replaced with an API call)
  Future<void> fetchNews(int? categoryID) async {
    try {
      if(categoryID!=null){
        final List<News> news = await service.fetchNewsByCategories(categoryID.toString());
        state = AsyncValue.data(news); // Update state with fetched doctor list
      } else {
        final List<News> news = await service.fetchAllNews();
        state = AsyncValue.data(news); // Update state with fetched doctor list

      }

    } catch (e,sr) {
      state = AsyncValue.error(e,sr);
    }
  }
}

final newsProvider = StateNotifierProvider<NewsViewModel, AsyncValue<List<News>>>((ref) {
  return NewsViewModel();
});