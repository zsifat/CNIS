import 'package:chapainawabganjcity/viewmodels/states/aboutState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/about.dart';
import '../service/api_service.dart';

class AboutNotifier extends StateNotifier<AboutState> {
  AboutNotifier() : super(AboutState.initial());

  final service = ApiService();

  // Method to fetch the About data (simulated API call)
  Future<void> fetchAboutData() async {
    try {
      state = state.copyWith(isLoading: true); // Set loading state
      About fetchedAbout = await service.fetchAbout();
      state = state.copyWith(about: fetchedAbout, isLoading: false); // Update state with fetched data
    } catch (e) {
      About fetchedAbout = await service.getCachedAbout();
      state = state.copyWith(about: fetchedAbout, isLoading: false); // Use cached data on error
    }
  }
}


// StateNotifierProvider for AboutViewModel
final aboutViewModelProvider = StateNotifierProvider<AboutNotifier, AboutState>((ref) {
  return AboutNotifier();
});
