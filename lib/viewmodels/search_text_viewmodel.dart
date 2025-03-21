import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchTextNotifier extends StateNotifier<String> {
  SearchTextNotifier() : super('');

  // Method to update search text
  void updateSearchText(String newText) {
    state = newText;
  }

  // Method to clear the search text
  void clearSearchText() {
    state = '';
  }

  @override
  void dispose() {
    super.dispose();
    clearSearchText();  // Reset the search text
  }
}

// Define the provider for the SearchTextNotifier
final searchTextProvider = StateNotifierProvider<SearchTextNotifier, String>((ref) {
  return SearchTextNotifier();
});
