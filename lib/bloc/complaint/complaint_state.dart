part of 'complaint_cubit.dart';

@immutable
abstract class ComplaintState {}

class ComplaintInitial extends ComplaintState {}

class ComplaintLoading extends ComplaintState {}

class ComplaintSuccess extends ComplaintState {
  List<ComplaintsData>? ComplaintList;
  ComplaintSuccess({@required this.ComplaintList});
}

class ComplaintFailed extends ComplaintState {
  final String? message;
  ComplaintFailed({@required this.message});
}

class ComplaintError extends ComplaintState {
  final String? message;
  ComplaintError({@required this.message});
}

//transactions
class ComplaintTransactionLoading extends ComplaintState {}

class ComplaintTransactionSuccess extends ComplaintState {
  List<HistoryData>? transactionList;
  ComplaintTransactionSuccess({@required this.transactionList});
}

class ComplaintTransactionFailed extends ComplaintState {
  final String? message;
  ComplaintTransactionFailed({@required this.message});
}

class ComplaintTransactionError extends ComplaintState {
  final String? message;
  ComplaintTransactionError({@required this.message});
}

class ComplaintConfigLoading extends ComplaintState {}

class ComplaintConfigSuccess extends ComplaintState {
  configData? ComplaintConfigList;
  ComplaintConfigSuccess({@required this.ComplaintConfigList});
}

class ComplaintConfigFailed extends ComplaintState {
  final String? message;
  ComplaintConfigFailed({@required this.message});
}

class ComplaintConfigError extends ComplaintState {
  final String? message;
  ComplaintConfigError({@required this.message});
}

//transaction details for
class ComplaintTransactionDetailLoading extends ComplaintState {}

class ComplaintTransactionDetailSuccess extends ComplaintState {
  List<HistoryData>? transactionDetail;
  ComplaintTransactionDetailSuccess({@required this.transactionDetail});
}

class ComplaintTransactionDetailFailed extends ComplaintState {
  final String? message;
  ComplaintTransactionDetailFailed({@required this.message});
}

class ComplaintTransactionDetailError extends ComplaintState {
  final String? message;
  ComplaintTransactionDetailError({@required this.message});
}

//submit complaint state
class ComplaintSubmitLoading extends ComplaintState {}

class ComplaintSubmitSuccess extends ComplaintState {
  final String? message;
  final String? data;

  ComplaintSubmitSuccess({@required this.message, @required this.data});
}

class ComplaintSubmitFailed extends ComplaintState {
  final String? message;
  ComplaintSubmitFailed({@required this.message});
}

class ComplaintSubmitError extends ComplaintState {
  final String? message;
  ComplaintSubmitError({@required this.message});
}
