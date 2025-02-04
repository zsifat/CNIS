// ViewModel Class that extends StateNotifier
import 'package:chapainawabganjcity/viewmodels/states/category_state.dart';
import 'package:riverpod/riverpod.dart';

import '../service/api_service.dart';

class CategoryNotifier extends StateNotifier<CategoryState> {
  CategoryNotifier() : super(CategoryState.initial());

  final service = ApiService();

  // Fetch Categories from the API
  Future<void> fetchCategories() async {
    try {
      state = state.copyWith(isLoading: true); // Set loading state
      final categories = await service.fetchCategories();
      state = state.copyWith(categories: categories, isLoading: false); // Update state with fetched data
    } catch (e) {
      final categories = await service.getCachedCategories();
      state = state.copyWith(isLoading: false, categories: categories); // Use cached data on error
    }
  }
}

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, CategoryState>((ref) {
  return CategoryNotifier()..fetchCategories();
});
