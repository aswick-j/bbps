import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/history_model.dart';
import '../../utils/utils.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  Repository? repository;
  HistoryCubit({@required this.repository}) : super(HistoryInitial());

  Future<void> getHistoryDetails(dateValues, custom) async {
    Map<String, dynamic> payload = {};
    if (custom) {
      // final _now = DateTime.now();
      // var gettoday = getDate(_now);
      // print(
      //     "=====end date===== ${dateValues['endDate'].toString().substring(0, 10)}");
      // print(
      //     "=====end date with timestamp===== ${_now.toLocal().toIso8601String()}");

      // print("object${_now.toLocal().toIso8601String()}");

      // if (gettoday.toString().substring(0, 10) ==
      //     dateValues['endDate'].toString().substring(0, 10)) {
      //   payload = {
      //     "startDate": dateValues['startDate'],
      //     "endDate": _now.toLocal().toIso8601String(),
      //   };
      // } else {

      var newEndDate = DateTime.parse(dateValues['endDate']);
      var finalEndDate = DateTime(
          newEndDate.year, newEndDate.month, newEndDate.day, 23, 59, 59);
      print("finalEndDate ::::");
      print(finalEndDate);

      payload = {
        "startDate": dateValues['startDate'],
        "endDate": finalEndDate.toString()
      };
      // payload = dateValues;
      // }
    } else {
      Map<String, dynamic> dateData =
          await getTransactionHistoryDate(dateValues);
      log(dateData['startDate'], name: 'DateData');
      log(dateData['endDate'], name: 'DateData');
      log(dateData.toString(), name: "get transactions :: daterange ::");

      payload = {
        "startDate": dateData['startDate'],
        "endDate": dateData['endDate'],
      };
    }

    if (!isClosed) {
      emit(HistoryLoading());
    }
    try {
      repository!.getHistory(payload).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              log(jsonEncode(value).toString(), name: "AT HISTORY CUBIT");
              HistoryModel? historyModel = HistoryModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                emit(HistorySuccess(historyData: historyModel!.data));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(HistoryFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(HistoryError(message: value['message']));
            }
          }
        } else {
          //  failed emit
          if (!isClosed) {
            emit(HistoryFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "CUBIT::getHistoryDetails:::");
    }
  }
}
