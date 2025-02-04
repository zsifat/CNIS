import 'package:chapainawabganjcity/models/data.dart';
import 'package:chapainawabganjcity/viewmodels/states/doctors_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/api_service.dart';


class DataNotifier extends StateNotifier<DataState> {
  DataNotifier() : super(DataState.initial());

  final service = ApiService();

  // Method to fetch doctor data (simulated API call)
  Future<void> fetchData(String id) async {
    try {
      state = state.copyWith(isLoading: true); // Set loading state
      final List<Data> doctorList = await service.fetchData(id);
      state = state.copyWith(doctorList: doctorList, isLoading: false); // Update state with fetched doctor list
    } catch (e) {
      final List<Data> doctorList = await service.getCachedData(id);
      state = state.copyWith(doctorList: doctorList, isLoading: false); // Use cached data on error
    }
  }
}


final dataNotifierProvider = StateNotifierProvider<DataNotifier, DataState>((ref) {
  return DataNotifier();
});
