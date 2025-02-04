import '../../models/category.dart';

class CategoryState {
  final List<Category> categories;
  final bool isLoading;
  final String errorMessage;

  CategoryState({
    required this.categories,
    required this.isLoading,
    required this.errorMessage,
  });

  // Default state
  factory CategoryState.initial() {
    return CategoryState(
      categories: [],
      isLoading: false,
      errorMessage: '',
    );
  }

  // CopyWith method to update the state
  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}