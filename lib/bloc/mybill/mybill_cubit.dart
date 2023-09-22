import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/chart_model.dart';
import '../../model/upcoming_dues_model.dart';

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
      log(e.toString(), name: "CUBIT::getCharts:::");
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
              // log(jsonEncode(value).toString());

              UpcomingDuesModel? upcomingDuesModel =
                  UpcomingDuesModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                log(jsonEncode(upcomingDuesModel.data),
                    name: "at getAllUpcomingDues() ::::");
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
      log(e.toString(), name: "CUBIT::getAllUpcomingDues :::");
    }
  }
}
