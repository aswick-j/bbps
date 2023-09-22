part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashSuccess extends SplashState {
  final RedirectModel? redirectModel;
  SplashSuccess({@required this.redirectModel});
}

class SplashFailed extends SplashState {
  final String? message;
  SplashFailed({@required this.message});
}

class SplashError extends SplashState {
  final String? error;
  SplashError({@required this.error});
}

//login
class SplashLoginLoading extends SplashState {}

class SplashLoginSuccess extends SplashState {}

class SplashLoginFailed extends SplashState {
  final String? message;
  SplashLoginFailed({@required this.message});
}

class SplashLoginError extends SplashState {
  final String? message;
  SplashLoginError({@required this.message});
}
