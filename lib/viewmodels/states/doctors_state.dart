import '../../models/data.dart';

class DataState {
  final List<Data> dataList;
  final bool isLoading;

  DataState({
    required this.dataList,
    required this.isLoading,
  });

  // Initial state with no doctor and loading set to true
  factory DataState.initial() {
    return DataState(
      dataList: [],
      isLoading: true,
    );
  }

  // Update state with new doctor data or loading state
  DataState copyWith({
    List<Data>? doctorList,
    bool? isLoading,
  }) {
    return DataState(
      dataList: doctorList ?? this.dataList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
