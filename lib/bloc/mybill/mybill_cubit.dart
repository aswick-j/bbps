import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/chart_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/upcoming_dues_model.dart';
import '../../utils/const.dart';

part 'mybill_state.dart';

class MybillCubit extends Cubit<MybillState> {
  Repository? repository;
  MybillCubit({@required this.repository}) : super(MybillInitial());

  void getCharts() async {
    if (!isClosed) {
      emit(MybillChartLoading());
    }
    try {
      repository!.getChartData().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              ChartModel chartModel = ChartModel.fromJson(value);
              if (!isClosed) {
                emit(MybillChartSuccess(chartModel: chartModel));
              }
            } else {
              if (!isClosed) {
                emit(MybillChartFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(MybillChartError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(MybillChartFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getCharts:::");
    }
  }

  void getAllUpcomingDues() {
    if (!isClosed) {
      emit(UpcomingDueLoading());
    }
    try {
      repository!.getAllUpcomingDues().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              // logConsole(jsonEncode(value).toString());

              UpcomingDuesModel? upcomingDuesModel =
                  UpcomingDuesModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                logConsole(jsonEncode(upcomingDuesModel.data),
                    "at getAllUpcomingDues() ::::");
                emit(UpcomingDueSuccess(
                    upcomingDuesData: upcomingDuesModel.data));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(UpcomingDueFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(UpcomingDueError(message: value['message']));
            }
          }
        } else {
          //  failed emit
          if (!isClosed) {
            emit(UpcomingDueFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAllUpcomingDues :::");
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
}
