import 'dart:developer';

import 'package:bbps/model/oto_model.dart';
import 'package:bbps/utils/const.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../api/api_repository.dart';
import '../../model/confirm_done_model.dart';
import '../../model/edit_autopay_model.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  Repository? repository;
  OtpCubit({@required this.repository}) : super(OtpInitial());

  void generateOtp({templateName, billerName}) async {
    try {
      if (!isClosed) {
        emit(OtpLoading());
      }
      await repository!
          .generateOtp(templateName: templateName, billerName: billerName)
          .then((value) {
        logInfo('$templateName generateOtp cubit');

        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              OtpModel otpModel = OtpModel.fromJson(value);
              if (!isClosed) {
                emit(OtpSuccess(
                    refrenceNumber: otpModel.data, message: otpModel.message));
              }
            } else {
              if (!isClosed) {
                emit(OtpFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpFailed(message: trylaterMessage));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::generateOtp:::");
    }
  }

  void validateOTP(otp) async {
    try {
      if (!isClosed) {
        emit(OtpValidateLoading());
      }
      await repository!.validateOtp(otp).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              if (!isClosed) {
                emit(OtpValidateSuccess());
              }
            } else if (value['status'] == 400) {
              if (!isClosed) {
                emit(OtpValidateFailed(message: value['message']));
              }
            } else if (value['status'] == 500) {
              if (!isClosed) {
                emit(OtpValidateFailed(message: value['message']));
              }
            } else if (value['message'].toString().contains("Invalid token")) {
              if (!isClosed) {
                emit(OtpValidateError(message: value['message']));
              }
            } else {
              if (!isClosed) {
                emit(OtpValidateFailed(message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpValidateError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpValidateFailed(message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT:::validateOTP:::");
    }
  }

  void deleteAutoPay(id, otp) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!.removeAutoPay(id, otp).then((value) {
        logInfo(value.toString());
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              if (!isClosed) {
                emit(OtpActionSuccess(
                    from: fromAutoPayDelete, message: value['message']));
              }
            } else {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromAutoPayDelete, message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromAutoPayDelete, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::deleteAutoPay:::");
    }
  }

  void editAutoPay(id, data) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!.editAutopayData(id, data).then((value) {
        logInfo(value.toString());
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              if (!isClosed) {
                // api response message avoided due to UI
                // emit(OtpActionSuccess(
                //     from: fromAutoPayEdit, message: value['message']));

                emit(OtpActionSuccess(
                    from: fromAutoPayEdit, message: data['billerName']));
              }
            } else {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromAutoPayEdit, message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromAutoPayEdit, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::editAutoPay:::");
    }
  }

  void createAutopay(data) async {
    logInfo("createAutopay payload ===>");
    inspect(data);
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!.createAutopayData(data).then((value) {
        logInfo(value.toString());
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 400) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromAutoPayCreate,
                    message: "Auto pay already enabled for this biller."));
              }
            } else if (value['status'] == 200) {
              if (!isClosed) {
                //Successfully created an auto pay configuration
                // emit(OtpActionSuccess(
                //     from: fromAutoPayCreate, message: value['message']));
                emit(OtpActionSuccess(
                    from: fromAutoPayCreate, message: data['billerName']));
              }
            } else {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromAutoPayCreate,
                    message: "Unable to Create Auto Pay."));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromAutoPayCreate, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT::createAutopay:::");
    }
  }

  void disableUpcomingPay(id, status, otp) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!.disableUpcoming(id, status, otp).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              if (!isClosed) {
                emit(OtpActionSuccess(
                    from: fromUpcomingDisable, message: value['message']));
              }
            } else {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromUpcomingDisable, message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromUpcomingDisable, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT:::disableUpcomingPay:::");
    }
  }

  void addNewBiller(String billID, dynamic inputSignatures, String billname,
      String otp, Map<String, dynamic> confirmPaymentRouteData) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      /**
       * 
       * 
       goToData(context, confirmPaymentRoute, {
        "name": widget.billerData!.bILLERNAME,
        "billName": billNameController.text,
        "billerData": widget.billerData,
        "inputParameters": inputPayloadData,
        "isSavedBill": false
      });
       */
      await repository!
          .addNewBiller(billID, inputSignatures, billname, otp)
          .then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              confirmPaymentRouteData = {
                ...confirmPaymentRouteData,
                "enableConfirmPayment":
                    confirmPaymentRouteData.isNotEmpty ? true : false,
                "cUSTOMERBILLID": value['data'],
                "isMobilePrepaid": false
              };
              if (!isClosed) {
                emit(OtpActionSuccess(
                    from: fromAddnewBillOtp,
                    message: value['message'],
                    data: confirmPaymentRouteData));
              }
            } else if (value['status'] == 400) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromAddnewBillOtp, message: value['message']));
              }
            } else {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromAddnewBillOtp, message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromAddnewBillOtp, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT:::addNewBiller:::");
    }
  }

  void prepaidPayBill(
      bool isMobilePrepaid,
      String billerID,
      String billerName,
      String billName,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      dynamic billerData,
      String otp,
      String paymentMode,
      String forChannel,
      String paymentChannel) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!
          .prepaidPayBillApi(
              billerID,
              acNo,
              billAmount,
              customerBillID,
              tnxRefKey,
              quickPay,
              inputSignature,
              otherAmount,
              otp,
              paymentMode,
              forChannel,
              paymentChannel)
          .then((value) {
        var mobileNumberToPay = inputSignature!
            .firstWhere(
              (param) =>
                  param.pARAMETERNAME.toString().toLowerCase() ==
                  'mobile number',
            )
            .pARAMETERVALUE
            .toString();

        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 400) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromConfirmPaymentOtp,
                    message: "Your Ac Need to complete KYC"));
              }
            } else if (value['status'] == 200) {
              if (value['data']['paymentDetails'].containsKey('success')) {
                if (value['data']['paymentDetails']['success']) {
                  if (!isClosed) {
                    emit(
                      OtpActionSuccess(
                        from: fromConfirmPaymentOtp,
                        message: value['message'],
                        data: {
                          "isMobilePrepaid": isMobilePrepaid,
                          "res": value['data'],
                          "billerID": billerID,
                          "billName": billName,
                          "acNo": acNo,
                          "billAmount": billAmount,
                          "customerBillID": customerBillID,
                          "tnxRefKey": tnxRefKey,
                          "quickPay": quickPay,
                          "inputSignature": inputSignature,
                          "otherAmount": otherAmount,
                          "billerData": billerData,
                        },
                      ),
                    );
                  }
                } else {
                  if (!isClosed) {
                    emit(
                      OtpActionFailed(
                        from: fromConfirmPaymentOtp,
                        message: value['message'],
                        data: {
                          "isMobilePrepaid": isMobilePrepaid,
                          "errData": value['data'],
                          "billerID": billerID,
                          "acNo": acNo,
                          "billerName": billerName,
                          "billAmount": billAmount,
                          "customerBillID": customerBillID,
                          "mobileNumber": mobileNumberToPay,
                          "inputSignature": inputSignature,
                        },
                      ),
                    );
                  }
                }
              } else {
                emit(
                  OtpActionFailed(
                    from: fromConfirmPaymentOtp,
                    message: value['message'],
                    data: {
                      "isMobilePrepaid": isMobilePrepaid,
                      "errData": value['data'],
                      "billerID": billerID,
                      "acNo": acNo,
                      "billerName": billerName,
                      "billAmount": billAmount,
                      "customerBillID": customerBillID,
                      "mobileNumber": mobileNumberToPay,
                      "inputSignature": inputSignature,
                    },
                  ),
                );
              }
            } else if (value['status'] == 500 &&
                !(value['message']
                    .toString()
                    .toLowerCase()
                    .contains("timed out")) &&
                (value['data'] == null)) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromConfirmPaymentOtp, message: "status_500"));
              }
            } else if (value['status'] == 500 &&
                (value['message']
                    .toString()
                    .toLowerCase()
                    .contains("timed out"))) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromConfirmPaymentOtp, message: "timeout"));
              }
            } else {
              if (!isClosed) {
                emit(
                  OtpActionFailed(
                    from: fromConfirmPaymentOtp,
                    message: value['message'],
                    data: {
                      "isMobilePrepaid": isMobilePrepaid,
                      "errData": value['data'],
                      "billerID": billerID,
                      "acNo": acNo,
                      "billerName": billerName,
                      "billAmount": billAmount,
                      "customerBillID": customerBillID,
                      "mobileNumber": mobileNumberToPay,
                      "inputSignature": inputSignature,
                    },
                  ),
                );
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          //  failed emit

          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromConfirmPaymentOtp, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT:::prepaidPayBill:::");
    }
  }

  void payBill(
    String billerID,
    String billerName,
    String billName,
    String acNo,
    String billAmount,
    int customerBillID,
    String tnxRefKey,
    bool quickPay,
    dynamic inputSignature,
    bool otherAmount,
    bool autopayStatus,
    dynamic billerData,
    String otp,
  ) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!
          .payBill(billerID, acNo, billAmount, customerBillID, tnxRefKey,
              quickPay, inputSignature, otherAmount, otp)
          .then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 400) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromConfirmPaymentOtp,
                    message: "Your Ac Need to complete KYC"));
              }
            } else if (value['status'] == 200) {
              if (value['data']['paymentDetails'].containsKey('success')) {
                if (value['data']['paymentDetails']['success']) {
                  if (!isClosed) {
                    emit(
                      OtpActionSuccess(
                        from: fromConfirmPaymentOtp,
                        message: value['message'],
                        data: {
                          "res": value['data'],
                          "billerID": billerID,
                          "billName": billName,
                          "acNo": acNo,
                          "billAmount": billAmount,
                          "customerBillID": customerBillID,
                          "tnxRefKey": tnxRefKey,
                          "quickPay": quickPay,
                          "inputSignature": inputSignature,
                          "otherAmount": otherAmount,
                          "autopayStatus": autopayStatus,
                          "billerData": billerData,
                        },
                      ),
                    );
                  }
                } else {
                  if (!isClosed) {
                    emit(
                      OtpActionFailed(
                        from: fromConfirmPaymentOtp,
                        message: value['message'],
                        data: {
                          "errData": value['data'],
                          "billerID": billerID,
                          "acNo": acNo,
                          "billerName": billerName,
                          "billAmount": billAmount,
                          "customerBillID": customerBillID,
                          "inputSignature": inputSignature
                        },
                      ),
                    );
                  }
                }
              }
            } else if (value['status'] == 500 &&
                !(value['message']
                    .toString()
                    .toLowerCase()
                    .contains("timed out")) &&
                (value['data'] == null)) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromConfirmPaymentOtp, message: "status_500"));
              }
            } else if (value['status'] == 500 &&
                (value['message']
                    .toString()
                    .toLowerCase()
                    .contains("timed out"))) {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: fromConfirmPaymentOtp, message: "timeout"));
              }
            } else {
              if (!isClosed) {
                emit(
                  OtpActionFailed(
                    from: fromConfirmPaymentOtp,
                    message: value['message'],
                    data: {
                      "errData": value['data'],
                      "billerID": billerID,
                      "acNo": acNo,
                      "billerName": billerName,
                      "billAmount": billAmount,
                      "customerBillID": customerBillID,
                      "inputSignature": inputSignature
                    },
                  ),
                );
              }
            }
          } else {
            //  error emit
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          //  failed emit

          if (!isClosed) {
            emit(OtpActionFailed(
                from: fromConfirmPaymentOtp, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT:::payBill:::");
    }
  }

  void deleteBiller(String cusbillID, String customerId, String otp) async {
    if (!isClosed) {
      emit(OtpActionLoading());
    }
    try {
      await repository!.deleteBiller(cusbillID, customerId, otp).then((value) {
        if (value != null) {
          if (!value.toString().contains("Invalid token")) {
            if (value['status'] == 200) {
              if (!isClosed) {
                emit(OtpActionSuccess(
                    from: myBillRoute, message: value['message']));
              }
            } else {
              if (!isClosed) {
                emit(OtpActionFailed(
                    from: myBillRoute, message: value['message']));
              }
            }
          } else {
            if (!isClosed) {
              emit(OtpActionError(message: value['message']));
            }
          }
        } else {
          if (!isClosed) {
            emit(OtpActionFailed(from: myBillRoute, message: value['message']));
          }
        }
      });
    } catch (e) {
      logConsole(e.toString(), "CUBIT:::deleteBiller:::");
    }
  }
}
