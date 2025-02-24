// ViewModel Class that extends StateNotifier
import 'package:chapainawabganjcity/viewmodels/states/category_state.dart';
import 'package:chapainawabganjcity/viewmodels/states/sub_category_state.dart';
import 'package:riverpod/riverpod.dart';

import '../service/api_service.dart';

class SubCategoryNotifier extends StateNotifier<SubCategoryState> {
  SubCategoryNotifier() : super(SubCategoryState.initial());

  final service = ApiService();

  // Fetch Categories from the API
  Future<void> fetchSubCategories() async {
    try {
      state = state.copyWith(isLoading: true); // Set loading state
      final subCategories = await service.fetchSubCategories();
      state = state.copyWith(subCategories: subCategories, isLoading: false); // Update state with fetched data
    } catch (e) {
      final subCategories = await service.getCachedSubCategories();
      state = state.copyWith(isLoading: false, subCategories: subCategories); // Use cached data on error
    }
  }
}

final subCategoryProvider = StateNotifierProvider<SubCategoryNotifier, SubCategoryState>((ref) {
  return SubCategoryNotifier()..fetchSubCategories();
});
