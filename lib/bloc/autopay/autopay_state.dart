part of 'autopay_cubit.dart';

@immutable
abstract class AutopayState {}

class AutopayInitial extends AutopayState {}

class AutopayLoading extends AutopayState {}

class AutopaySuccess extends AutopayState {
  AutoSchedulePayModel? autoSchedulePayData;
  AutopaySuccess({@required this.autoSchedulePayData});
}

class AutopayFailed extends AutopayState {
  final String? message;
  AutopayFailed({@required this.message});
}

class AutopayError extends AutopayState {
  final String? message;
  AutopayError({@required this.message});
}

// upcoming
class AutopayUpcomingLoading extends AutopayState {}

class AutopayUpcomingSuccess extends AutopayState {
  AutoSchedulePayModel? autoSchedulePayModel;
  AutopayUpcomingSuccess({@required this.autoSchedulePayModel});
}

class AutopayUpcomingFailed extends AutopayState {
  final String? message;
  AutopayUpcomingFailed({@required this.message});
}

class AutopayUpcomingError extends AutopayState {
  final String? message;
  AutopayUpcomingError({@required this.message});
}

// edit
class AutopayEditLoading extends AutopayState {}

class AutopayEditSuccess extends AutopayState {
  EditAutoPayData? editAutoPayData;
  AutopayEditSuccess({@required this.editAutoPayData});
}

class AutopayEditFailed extends AutopayState {
  final String? message;
  AutopayEditFailed({@required this.message});
}

class AutopayEditError extends AutopayState {
  final String? message;
  AutopayEditError({@required this.message});
}

// FetchAutoPayMaxAmount
class FetchAutoPayMaxAmountLoading extends AutopayState {}

class FetchAutoPayMaxAmountSuccess extends AutopayState {
  FetchAutoPayMaxAmountModel? fetchAutoPayMaxAmountModel;
  FetchAutoPayMaxAmountSuccess({@required this.fetchAutoPayMaxAmountModel});
}

class FetchAutoPayMaxAmountFailed extends AutopayState {
  final String? message;
  FetchAutoPayMaxAmountFailed({@required this.message});
}

class FetchAutoPayMaxAmountError extends AutopayState {
  final String? message;
  FetchAutoPayMaxAmountError({@required this.message});
}
