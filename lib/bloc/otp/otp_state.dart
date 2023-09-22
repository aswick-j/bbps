part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

// generate
class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final String? refrenceNumber;
  final String? message;
  OtpSuccess({@required this.refrenceNumber, @required this.message});
}

class OtpFailed extends OtpState {
  final String? message;
  OtpFailed({@required this.message});
}

class OtpError extends OtpState {
  final String? message;
  OtpError({@required this.message});
}

// validate
class OtpValidateLoading extends OtpState {}

class OtpValidateSuccess extends OtpState {}

class OtpValidateFailed extends OtpState {
  final String? message;
  OtpValidateFailed({@required this.message});
}

class OtpValidateError extends OtpState {
  final String? message;
  OtpValidateError({@required this.message});
}

// action
class OtpActionLoading extends OtpState {}

class OtpActionSuccess extends OtpState {
  final String? from;
  Map<String, dynamic>? data;
  final String? message;
  OtpActionSuccess(
      {@required this.from, @required this.message, @required this.data});
}

class OtpActionFailed extends OtpState {
  final String? from;
  final String? message;
  Map<String, dynamic>? data;
  OtpActionFailed(
      {@required this.from, @required this.message, @required this.data});
}

class OtpActionError extends OtpState {
  final String? message;
  OtpActionError({@required this.message});
}
