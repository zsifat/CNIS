import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chapainawabganjcity/models/news.dart';

import '../service/api_service.dart';

class AllNewsViewModel extends StateNotifier<AsyncValue<List<News>>> {

  AllNewsViewModel() : super(const AsyncValue.loading());
  final service = ApiService();

  // Simulate data fetching (could be replaced with an API call)
  Future<void> fetchAllNews() async {
    try {
      final List<News> news = await service.fetchAllNews();
      state = AsyncValue.data(news); // Update state with fetched doctor list
    } catch (e,sr) {
      state = AsyncValue.error(e,sr);
    }
  }
}

final allNewsProvider = StateNotifierProvider<AllNewsViewModel, AsyncValue<List<News>>>((ref) {
  return AllNewsViewModel();
});