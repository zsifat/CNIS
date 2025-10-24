abstract class SubmitNewsState {}

class SubmitNewsInitial extends SubmitNewsState {}

class SubmitNewsLoading extends SubmitNewsState {}

class SubmitNewsSuccess extends SubmitNewsState {}

class SubmitNewsFailure extends SubmitNewsState {
  final String error;

  SubmitNewsFailure(this.error);
}
