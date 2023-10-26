part of 'history_cubit.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  List<HistoryData>? historyData;
  HistorySuccess({@required this.historyData});
}

class HistoryFailed extends HistoryState {
  final String? message;
  HistoryFailed({@required this.message});
}

class HistoryError extends HistoryState {
  final String? message;
  HistoryError({@required this.message});
}
