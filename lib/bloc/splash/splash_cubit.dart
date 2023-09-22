import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/login_model.dart';
import '../../model/redirect_model.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  Repository? repository;
  SplashCubit({@required this.repository}) : super(SplashInitial());

  void redirect(String whom, {initParams, initCheckSum}) {
    RedirectModel? redirectModel;
    if (!isClosed) {
      emit(SplashLoading());
    }
    repository!.redirect(whom, initParams, initCheckSum).then((value) {
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            redirectModel = RedirectModel.fromJson(value);
            if (!isClosed) {
              emit(SplashSuccess(redirectModel: redirectModel));
            }
          } else {
            if (!isClosed) {
              emit(SplashFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(SplashError(error: value['message']));
          }
        }
      } else {}
    });
  }

  void checkRedirection(redirectData, checkSum) {
    print("ParentRedirect() : :::" + redirectData.toString());
    RedirectModel? redirectModel;
    if (!isClosed) {
      emit(SplashLoading());
    }
    repository!.parentRedirect(redirectData, checkSum).then((value) {
      print("parentRedirect() splash_cubit ::: ");
      print(jsonEncode(value));
      if (value != null) {
        if (!value.toString().contains("Invalid token")) {
          if (value['status'] == 200) {
            redirectModel = RedirectModel.fromJson(value);
            if (!isClosed) {
              emit(SplashSuccess(redirectModel: redirectModel));
            }
          } else {
            if (!isClosed) {
              emit(SplashFailed(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(SplashError(error: value['message']));
          }
        }
      } else {}
    });
  }

  void login(id, hash) {
    try {
      if (!isClosed) {
        emit(SplashLoginLoading());
      }
      LoginModel? loginModel;
      repository!.login(id, hash).then((value) async {
        if (value != null) {
          if (!value.toString().contains('Invalid token')) {
            if (value['status'] == 200) {
              loginModel = LoginModel.fromJson(value);
              await setSharedValue(TOKEN, loginModel!.data!.token);
              await setSharedValue(
                  ENCRYPTION_KEY, loginModel!.data!.encryptionKey);

              var isValid = validateJWT();
              if (isValid.toString() == 'restart') {
                log("restart need", name: "TOKEN EXPAIR RESTART NEED");
                redirect('two');
              } else {
                if (!isClosed) {
                  emit(SplashLoginSuccess());
                }
              }
            } else {
              if (!isClosed) {
                emit(SplashLoginFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(SplashLoginError(message: "Invalid Token"));
            }
          }
        } else {
          if (!isClosed) {
            emit(SplashLoginFailed(message: "Null"));
          }
        }
      });
    } on Exception catch (e) {
      // TODO
    }
  }
}
