import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedUpazilaNotifier extends StateNotifier<int>{
  SelectedUpazilaNotifier():super(0);

  void setUpazila(int index){
    state = index;
  }
}

final selectedUpazilaProvider = StateNotifierProvider<SelectedUpazilaNotifier,int>((ref) => SelectedUpazilaNotifier(),);