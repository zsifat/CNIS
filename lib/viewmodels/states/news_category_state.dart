import 'package:chapainawabganjcity/models/news_category.dart';

import '../../models/category.dart';

class NewsCategoryState {
  final List<NewsCategory> newsCategories;
  final bool isLoading;
  final String errorMessage;

  NewsCategoryState({
    required this.newsCategories,
    required this.isLoading,
    required this.errorMessage,
  });

  // Default state
  factory NewsCategoryState.initial() {
    return NewsCategoryState(
      newsCategories: [],
      isLoading: false,
      errorMessage: '',
    );
  }

  // CopyWith method to update the state
  NewsCategoryState copyWith({
    List<NewsCategory>? newsCategories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NewsCategoryState(
      newsCategories: newsCategories ?? this.newsCategories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}