import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/account_info_model.dart';
import 'package:bbps/model/add_update_upcoming_due_model.dart';
import 'package:bbps/model/amount_by_date_model.dart';
import 'package:bbps/model/fetch_bill_model.dart';
import 'package:bbps/model/saved_bill_details_model.dart';
import 'package:bbps/model/validate_bill_model.dart';
import 'package:bbps/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../api/api_repository.dart';
import '../../../model/bbps_settings_model.dart';
import '../../../model/confirm_fetch_bill_model.dart';
import '../../../model/paymentInformationModel.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../utils/const.dart';
import 'billflow_state.dart';

class billFlowCubit extends Cubit<billFlowState> {
  Repository? repository;
  billFlowCubit({@required this.repository}) : super(billFlowInitial());

  void getAmountByDate() {
    if (!isClosed) {
      emit(AmountByDateLoading());
    }
    try {
      repository!.getAmountByDate().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              // ignore: non_constant_identifier_names
              AmountByDateModel? amountByDateModel =
                  AmountByDateModel.fromJson(value);
              if (!isClosed) {
                emit(AmountByDateSuccess(amountByDate: amountByDateModel.data));
              }
            } else {
              if (!isClosed) {
                emit(AmountByDateFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AmountByDateError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AmountByDateFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAmountByDate:::");
    }
  }

  void getSavedDetails(id) {
    if (!isClosed) {
      emit(SavedBillDetailsLoading());
    }
    try {
      repository!.getSavedBillDetails(id).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              // ignore: non_constant_identifier_names
              SavedBillDetailsModel? Savedbilldetails =
                  SavedBillDetailsModel.fromJson(value);
              if (!isClosed) {
                emit(SavedBillDetailsSuccess(
                    SavedBillDetails: Savedbilldetails.data));
              }
            } else {
              if (!isClosed) {
                emit(SavedBillDetailsFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(SavedBillDetailsError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(SavedBillDetailsFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getSavedDetails:::");
    }
  }

  void fetchBill(
      {String? billerID,
      bool? quickPay,
      String? quickPayAmount,
      String? adHocBillValidationRefKey,
      bool? validateBill,
      Map<String, dynamic>? billerParams,
      String? billName}) {
    //static data working perfectly

    // String billerParams =
    //     "{\"a\":\"10\",\"a b\":\"20\",\"a b c\":\"30\",\"a b c d\":\"40\",\"a b c d e\":\"50\"}";

    var mockResponse = {
      "message": "Successfully retrieved the bill Details",
      "status": 200,
      "data": {
        "bankBranch": true,
        "data": {
          "Response": "Transaction Successful",
          "BankRRN": "313922010841",
          "BbpsTranlogId": "348581",
          "ActCode": "0",
          "Data": {
            "AdditionalInfo": {
              "Tag": [
                {"name": "a", "value": "10"},
                {"name": "a b", "value": "20"},
                {"name": "a b c", "value": "30"},
                {"name": "a b c d", "value": "40"}
              ]
            },
            "BillerResponse": {
              "amount": "1000.00",
              "dueDate": "2015-06-20",
              "billDate": "2015-06-14",
              "Tag": [
                {"name": "Late Payment Fee", "value": "40"},
                {"name": "Fixed Charges", "value": "50"},
                {"name": "Additional Charges", "value": "60"}
              ],
              "billNumber": "12303",
              "customerName": "PRABHA",
              "billPeriod": "june"
            }
          },
          "ExtraData": "",
          "SsTxnId": ""
        },
        "success": true,
        "rc": "0",
        "txnRefKey": "253643ba-10c5-4d87-998c-8e09ea79e31f",
        "fees": {
          "Response": "success",
          "valid": "true",
          "totalAmount": "1000.00",
          "amount": "1000.00",
          "ccf2": 0,
          "ccf1": 0,
          "ccf": 0,
          "ActCode": "0"
        },
        "paymentMode": "Internet Banking",
        "AmountExactness": {
          "minimumDueAmount": "Y",
          "other": "N",
          "totalOutstandingAmount": "Y",
          "paymentAmountExactness": "Exact"
        }
      }
    };
    if (!isClosed) {
      emit(FetchBillLoading());
    }
    try {
      repository!
          .fetchBill(validateBill, billerID, billerParams, quickPay,
              quickPayAmount, adHocBillValidationRefKey, billName)
          .then((value) {
        // value = mockResponse;
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              FetchBillModel? fetchBillModel = FetchBillModel.fromJson(value);

              if (!isClosed) {
                emit(FetchBillSuccess(fetchBillResponse: fetchBillModel.data));
              }
            } else {
              if (!isClosed) {
                emit(FetchBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(FetchBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(FetchBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::fetchBill:::");
    }
  }

  void prepaidValidateBill(dynamic payload) async {
    debugPrint("prepaidValidateBill payload ===>");
    inspect(payload);
    if (!isClosed) {
      emit(ValidateBillLoading());
    }
    try {
      await repository!.PrepaidFetchvalidateBill(payload).then((value) {
        logInfo(value.toString());
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              ValidateBillModel? validateBillModel =
                  ValidateBillModel.fromJson(value);
              if (!isClosed) {
                emit(PrepaidValidateBillSuccess(
                  transactionReferenceKey: validateBillModel.data!.txnRefKey,
                ));
              }
            } else {
              if (!isClosed) {
                emit(ValidateBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ValidateBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ValidateBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::prepaidValidateBill:::");
    }
  }

  void fetchValidateBill(dynamic payload) async {
    debugPrint("validateBill payload ===>");
    inspect(payload);
    if (!isClosed) {
      emit(ValidateBillLoading());
    }
    try {
      await repository!.validateBill(payload).then((value) {
        logInfo(value.toString());
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              ValidateBillModel? validateBillModel =
                  ValidateBillModel.fromJson(value);
              if (!isClosed) {
                emit(ValidateBillSuccess(
                  validateBillResponseData: validateBillModel.data,
                  bbpsTranlogId: validateBillModel.data!.data!.bbpsTranlogId,
                ));
              }
            } else {
              if (!isClosed) {
                emit(ValidateBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ValidateBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ValidateBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::fetchValidateBill:::");
    }
  }

  void confirmFetchBill(
      {String? billerID,
      bool? quickPay,
      String? quickPayAmount,
      String? adHocBillValidationRefKey,
      bool? validateBill,
      Map<String, dynamic>? billerParams,
      String? billName,

      //prepaid
      dynamic? forChannel,
      dynamic? planId,
      dynamic? planType,
      dynamic? supportPlan}) {
    // String billerParams =
    //     "{\"a\":\"10\",\"a b\":\"20\",\"a b c\":\"30\",\"a b c d\":\"40\",\"a b c d e\":\"50\"}";

    if (!isClosed) {
      emit(ConfirmFetchBillLoading());
    }
    try {
      repository!
          .fetchBill(validateBill, billerID, billerParams, quickPay,
              quickPayAmount, adHocBillValidationRefKey, billName)
          .then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              ConfirmFetchBillModel? confirmfetchBillModel =
                  ConfirmFetchBillModel.fromJson(value);
              if (!isClosed) {
                emit(ConfirmFetchBillSuccess(
                  ConfirmFetchBillResponse: confirmfetchBillModel.data,
                ));
              }
            } else {
              if (!isClosed) {
                emit(ConfirmFetchBillFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(ConfirmFetchBillError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(ConfirmFetchBillFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::confirmFetchBill:::");
    }
  }

  void getAccountInfo(myAcc) {
    // String accountInfo =
    //     "{ \"accountInfo\": [ { \"accountType\": \"SA\", \"accountID\": \"100002467080\", \"customerRelationship\": \"SOW\", \"customerStatusDescription\": \"ACCOUNT OPEN - NO DEBIT\", \"entityType\": \"I\", \"currentStatus\": \"3\", \"id\": 1 }, { \"accountType\": \"CA\", \"accountID\": \"200000552249\", \"customerRelationship\": \"SOW\", \"customerStatusDescription\": \"ACCOUNT OPEN - NO DEBIT\", \"entityType\": \"I\", \"currentStatus\": \"3\", \"id\": 2 }, { \"accountType\": \"SA\", \"accountID\": \"918754412249\", \"customerRelationship\": \"JOF\", \"customerStatusDescription\": \"ACCOUNT OPEN REGULAR\", \"entityType\": \"I\", \"currentStatus\": \"8\", \"id\": 3 } ] }";
    if (!isClosed) {
      emit(AccountInfoLoading());
    }
    try {
      repository!.getAccountInfo(myAcc).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              AccountInfoModel? accountInfoModel =
                  AccountInfoModel.fromJson(value);
              if (!isClosed) {
                emit(AccountInfoSuccess(accountInfo: accountInfoModel.data));
              }
            } else {
              if (!isClosed) {
                emit(AccountInfoFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AccountInfoError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AccountInfoFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAccountInfo:::");
    }
  }

  void getAddUpdateUpcomingDue(
      {int? customerBillID,
      String? dueAmount,
      String? dueDate,
      String? billDate,
      String? billPeriod}) {
    // int customerBillID = 1621;
    // String dueAmount = "1000.00";
    // String dueDate = "2015-06-20";
    if (!isClosed) {
      emit(AddUpdateUpcomingDueLoading());
    }
    try {
      repository!
          .getAddUpdateUpcomingDue(
              customerBillID, dueAmount, dueDate, billDate, billPeriod)
          .then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              AddUpdateUpcomingModel? addUpdateUpcomingModel =
                  AddUpdateUpcomingModel.fromJson(value);
              if (!isClosed) {
                emit(AddUpdateUpcomingDueSuccess(
                    addUpdateUpcomingDueData: addUpdateUpcomingModel.data));
              }
            } else {
              if (!isClosed) {
                emit(AddUpdateUpcomingDueFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AddUpdateUpcomingDueError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AddUpdateUpcomingDueFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAddUpdateUpcomingDue:::");
    }
  }

  void getAutopay() async {
    try {
      if (!isClosed) {
        emit(AllAutopayLoading());
      }
      repository!.getAllScheduledAutoPay().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              AutoSchedulePayModel? autoSchedulePayModel =
                  AutoSchedulePayModel.fromJson(value);
              logConsole(jsonEncode(autoSchedulePayModel), "getAutopay() :::");
              if (!isClosed) {
                emit(AllAutopaySuccess(
                    autoSchedulePayData: autoSchedulePayModel));
              }
            } else {
              if (!isClosed) {
                emit(AllAutopayFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(AllAutopayError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(AllAutopayFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getAutopay:::");
    }
  }

  void getPaymentInformation(billerID) {
    if (!isClosed) {
      emit(PaymentInfoLoading());
    }
    try {
      repository!.getPaymentInformation(billerID).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              PaymentInformationModel? PaymentInfoDetails =
                  PaymentInformationModel.fromJson(value);
              if (!isClosed) {
                emit(PaymentInfoSuccess(PaymentInfoDetail: PaymentInfoDetails));
              }
            } else {
              if (!isClosed) {
                emit(PaymentInfoFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(PaymentInfoError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(PaymentInfoFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getPaymentInformation:::");
    }
  }

  void getBbpsSettings() {
    if (!isClosed) {
      emit(BbpsSettingsLoading());
    }
    try {
      repository!.getBbpsSettings().then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              bbpsSettingsModel? BbpsSettingsDetails =
                  bbpsSettingsModel.fromJson(value);
              if (!isClosed) {
                emit(BbpsSettingsSuccess(
                    BbpsSettingsDetail: BbpsSettingsDetails));
              }
            } else {
              if (!isClosed) {
                emit(BbpsSettingsFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(BbpsSettingsError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(BbpsSettingsFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::getBbpsSettings:::");
    }
  }
}
