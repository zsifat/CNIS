import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chapainawabganjcity/models/news.dart';

import '../service/api_service.dart';

class advertisementViewModel extends StateNotifier<AsyncValue<List<News>>> {

  advertisementViewModel() : super(const AsyncValue.loading());
  final service = ApiService();

  // Simulate data fetching (could be replaced with an API call)
  Future<void> fetchAdvertisement() async {
    try {
      final List<News> news = await service.fetchNewsByCategories(0.toString());
      state = AsyncValue.data(news); // Update state with fetched doctor list

    } catch (e,sr) {
      state = AsyncValue.error(e,sr);
    }
  }
}

final advertisementProvider = StateNotifierProvider<advertisementViewModel, AsyncValue<List<News>>>((ref) {
  return advertisementViewModel();
});