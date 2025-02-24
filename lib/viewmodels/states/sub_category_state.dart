import '../../models/subCategory.dart';

class SubCategoryState {
  final List<SubCategory> subCategories;
  final bool isLoading;
  final String errorMessage;

  SubCategoryState({
    required this.subCategories,
    required this.isLoading,
    required this.errorMessage,
  });

  // Default state
  factory SubCategoryState.initial() {
    return SubCategoryState(
      subCategories: [],
      isLoading: false,
      errorMessage: '',
    );
  }

  // CopyWith method to update the state
  SubCategoryState copyWith({
    List<SubCategory>? subCategories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SubCategoryState(
      subCategories: subCategories ?? this.subCategories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}