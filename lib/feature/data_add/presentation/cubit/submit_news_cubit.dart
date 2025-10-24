import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'submit_news_state.dart';
import '../../data/repository/data_post_repository.dart';

class SubmitNewsCubit extends Cubit<SubmitNewsState> {
  final DataPostRepository repository = DataPostRepository();

  SubmitNewsCubit() : super(SubmitNewsInitial());

  Future<void> submitNews({
    required String title,
    required int catId,
    required String description,
    File? image,
  }) async {
    emit(SubmitNewsLoading());

    try {
      await repository.postNews(
        title: title,
        description: description,
        catId: catId,
        image: image,
      );
      emit(SubmitNewsSuccess());
    } catch (e) {
      emit(SubmitNewsFailure(e.toString()));
    }
  }
}
