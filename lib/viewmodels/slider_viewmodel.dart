// SliderViewModel using StateNotifier
import 'package:chapainawabganjcity/viewmodels/states/carousal_images_sate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/slider.dart';
import '../service/api_service.dart';

class SliderViewModel extends StateNotifier<SliderState> {
  SliderViewModel() : super(SliderState.initial());

  final service = ApiService();

  // Method to fetch slider data (simulated API call)
  Future<void> fetchSliders() async {
    try {
      state = state.copyWith(isLoading: true); // Set loading state
      final List<Slider> images = await service.fetchSliderImages();
      state = state.copyWith(sliders: images, isLoading: false); // Update state with fetched data
    } catch (e) {
      final List<Slider> images = await service.getCachedSliderImages();
      state = state.copyWith(sliders: images, isLoading: false); // Use cached data on error
    }
  }
}


// StateNotifierProvider for SliderViewModel
final sliderViewModelProvider = StateNotifierProvider<SliderViewModel, SliderState>((ref) {
  return SliderViewModel();
});

