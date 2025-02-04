import 'package:chapainawabganjcity/viewmodels/states/news_category_state.dart';
import 'package:riverpod/riverpod.dart';

import '../service/api_service.dart';

class NewsCategoryNotifier extends StateNotifier<NewsCategoryState> {
  NewsCategoryNotifier() : super(NewsCategoryState.initial());

  final service = ApiService();

  // Fetch Categories from the API
  Future<void> fetchNewsCategories() async {
    try {
      state = state.copyWith(isLoading: true); // Set loading state
      final newsCategories = await service.fetchNewsCategories();
      state = state.copyWith(newsCategories: newsCategories, isLoading: false); // Update state with fetched data
    } catch (e) {
      throw Exception(e);
    }
  }
}

final newsCategoryProvider = StateNotifierProvider<NewsCategoryNotifier, NewsCategoryState>((ref) {
  return NewsCategoryNotifier()..fetchNewsCategories();
});
