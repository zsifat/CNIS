// Slider state that holds the list of sliders and loading state
import '../../models/slider.dart';

class SliderState {
  final List<Slider> sliders;
  final bool isLoading;

  SliderState({
    required this.sliders,
    required this.isLoading,
  });

  // Initial state when no sliders are loaded
  factory SliderState.initial() {
    return SliderState(
      sliders: [],
      isLoading: true,
    );
  }

  // State with updated sliders and loading status
  SliderState copyWith({
    List<Slider>? sliders,
    bool? isLoading,
  }) {
    return SliderState(
      sliders: sliders ?? this.sliders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}