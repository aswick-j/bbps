import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/complaints_config_model.dart';
import '../../model/complaints_model.dart';
import '../../model/history_model.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  Repository? repository;
  ComplaintCubit({@required this.repository}) : super(ComplaintInitial());

  void getAllComplaints() {
    if (!isClosed) {
      emit(ComplaintLoading());
    }
    try {
      repository!.getComplaints().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              complaints_model? complaintsModel =
                  complaints_model.fromJson(value);
              if (!isClosed) {
                emit(ComplaintSuccess(ComplaintList: complaintsModel.data));
              }
            } else {
              if (!isClosed) {
                emit(ComplaintFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ComplaintError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ComplaintFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAllComplaints:::");
    }
  }

  void getAllTransactions() {
    if (!isClosed) {
      emit(ComplaintTransactionLoading());
    }
    try {
      repository!.getTransactions().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              HistoryModel? historyModel = HistoryModel.fromJson(value);
              if (!isClosed) {
                emit(ComplaintTransactionSuccess(
                    transactionList: historyModel.data));
              }
            } else {
              if (!isClosed) {
                emit(ComplaintTransactionFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ComplaintTransactionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ComplaintTransactionFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAllTransactions:::");
    }
  }

  void getComplaintConfig() {
    if (!isClosed) {
      emit(ComplaintConfigLoading());
    }
    try {
      repository!.getComplaintConfig().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              complaints_config_model? complaints_config_details =
                  complaints_config_model.fromJson(value);
              if (!isClosed) {
                emit(ComplaintConfigSuccess(
                    ComplaintConfigList: complaints_config_details.data));
              }
            } else {
              if (!isClosed) {
                emit(ComplaintConfigFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ComplaintConfigError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ComplaintConfigFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getComplaintConfig:::");
    }
  }

  Future<void> getHistoryDetails(DateRange) async {
    if (!isClosed) {
      emit(ComplaintTransactionLoading());
    }

    Map<String, dynamic> payload = {};

    Map<String, dynamic> dateData =
        await getTransactionDateForComplaint(DateRange);
    logConsole(dateData['startDate'], 'DateData');
    logConsole(dateData['endDate'], 'DateData');
    logConsole(dateData.toString(), "get transactions :: daterange ::");

    payload = {
      "startDate": dateData['startDate'],
      "endDate": dateData['endDate'],
    };
    try {
      repository!.getHistory(payload).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              logConsole(jsonEncode(value).toString(), "AT COMPLAINT CUBIT");
              HistoryModel? historyModel = HistoryModel.fromJson(value);
              //  success emit
              if (!isClosed) {
                emit(ComplaintTransactionSuccess(
                    transactionList: historyModel!.data));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(ComplaintTransactionFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(ComplaintTransactionError(message: value['message']));
            }
          }
        } else {
          //  failed emit
          if (!isClosed) {
            emit(ComplaintTransactionFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getHistoryDetails:::");
    }
  }

  void submitComplaint(Map<String, dynamic> data) async {
    if (!isClosed) {
      emit(ComplaintSubmitLoading());
    }
    try {
      await repository!.submitTxnsComplaint(data).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              logConsole(jsonEncode(value).toString(), "AT COMPLAINT CUBIT");
              // //  success emit
              if (!isClosed) {
                emit(ComplaintSubmitSuccess(
                    message: value['message'], data: value['data']));
              }
            } else {
              //  failed emit
              if (!isClosed) {
                emit(ComplaintSubmitFailed(message: value['message']));
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(ComplaintSubmitError(message: value['message']));
            }
          }
        } else {
          //  failed emit
          if (!isClosed) {
            emit(ComplaintSubmitFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::submitComplaint:::");
    }
  }
}
