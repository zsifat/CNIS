import '../../models/about.dart';

class AboutState {
  final About? about;
  final bool isLoading;

  AboutState({
    required this.about,
    required this.isLoading,
  });

  // Initial state when no data is loaded
  factory AboutState.initial() {
    return AboutState(
      about: null,
      isLoading: true,
    );
  }

  // State with updated about data and loading status
  AboutState copyWith({
    About? about,
    bool? isLoading,
  }) {
    return AboutState(
      about: about ?? this.about,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}