import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/edit_autopay_model.dart';
import 'package:bbps/model/fetch_auto_pay_max_amount_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../utils/const.dart';

part 'autopay_state.dart';

class AutopayCubit extends Cubit<AutopayState> {
  Repository? repository;
  AutopayCubit({@required this.repository}) : super(AutopayInitial());

  void fetchAutoPayMaxAmount() async {
    try {
      if (!isClosed) {
        emit(FetchAutoPayMaxAmountLoading());
      }
      repository!.fetchAutoPayMaxAmount().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              FetchAutoPayMaxAmountModel? fetchAutoPayMaxAmountModel =
                  FetchAutoPayMaxAmountModel.fromJson(value);
              logConsole(jsonEncode(fetchAutoPayMaxAmountModel),
                  "fetchAutoPayMaxAmount() :::");
              if (!isClosed) {
                emit(FetchAutoPayMaxAmountSuccess(
                    fetchAutoPayMaxAmountModel: fetchAutoPayMaxAmountModel));
              }
            } else {
              if (!isClosed) {
                emit(FetchAutoPayMaxAmountFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(FetchAutoPayMaxAmountError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(FetchAutoPayMaxAmountFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::fetchAutoPayMaxAmount:::");
    }
  }

  void getAutopay() async {
    try {
      if (!isClosed) {
        emit(AutopayLoading());
      }
      repository!.getAllScheduledAutoPay().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              AutoSchedulePayModel? autoSchedulePayModel =
                  AutoSchedulePayModel.fromJson(value);
              logConsole(jsonEncode(autoSchedulePayModel), "getAutopay() :::");
              if (!isClosed) {
                emit(AutopaySuccess(autoSchedulePayData: autoSchedulePayModel));
              }
            } else {
              if (!isClosed) {
                emit(AutopayFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AutopayError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AutopayFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAutopay:::");
    }
  }

  void getUpcomingPay() async {
    if (!isClosed) {
      emit(AutopayUpcomingLoading());
    }
    try {
      repository!.getAllScheduledAutoPay().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              AutoSchedulePayModel? autoSchedulePayModel =
                  AutoSchedulePayModel.fromJson(value);
              if (!isClosed) {
                emit(AutopayUpcomingSuccess(
                    autoSchedulePayModel: autoSchedulePayModel));
              }
            } else {
              if (!isClosed) {
                emit(AutopayUpcomingFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AutopayUpcomingError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AutopayUpcomingFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getUpcomingPay:::");
    }
  }

  void getEditData(id) {
    if (!isClosed) {
      emit(AutopayEditLoading());
    }
    try {
      repository!.getAutopayEditData(id).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              EditAutoPayModel? editAutoPayModel =
                  EditAutoPayModel.fromJson(value);
              if (!isClosed) {
                emit(
                    AutopayEditSuccess(editAutoPayData: editAutoPayModel.data));
              }
            } else {
              if (!isClosed) {
                emit(AutopayEditFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AutopayEditError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AutopayEditFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getEditData:::");
    }
  }
}
