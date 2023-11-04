import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bbps/bloc/otp/otp_cubit.dart';
import 'package:bbps/model/add_bill_payload_model.dart';
import 'package:bbps/model/saved_billers_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/auto_schedule_pay_model.dart';
import '../../model/biller_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/shimmerCell.dart';

var otp = '';
final txtOtpController = TextEditingController();

class OtpVerification extends StatefulWidget {
  AllConfigurationsData? autopayData;
  String? id;
  String? from;
  String? templateName;
  Map<String, dynamic>? data;
  OtpVerification(
      {super.key,
      this.from,
      this.templateName,
      this.autopayData,
      this.id,
      this.data});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String? refNo = '';
  bool isLoading = true;
  bool showTimer = true;
  String? dataMsg = '';
  String? errOTPMsg;
  String? decodedTokenCustomer;
  Timer? timer;
  int secondsRemaining = otpTimerDuration;
  // int secondsRemaining = 10;
  String? billerName;
  bool enableResend = false;
  bool enableReadOnly = false;
  bool showResend = true;
  bool showGenerateOtpSuccessMsg = true;
  resetOtpErr() {
    setState(() {
      errOTPMsg = null;
    });
  }

  @override
  void initState() {
//trigger API to generate OTP in cubit
    if (widget.from == fromAutoPayDelete) {
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.autopayData!.bILLERNAME);
    } else if (widget.from == fromAutoPayEdit) {
      logInfo(widget.data!['billerName'].toString());
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billerName']);
    } else if (widget.from == fromAutoPayCreate) {
      logInfo(widget.data!['billerName'].toString());
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName, billerName: widget.id);
    } else if (widget.from == fromUpcomingDisable) {
      logInfo(widget.templateName.toString());
      logInfo(widget.data!['billerName'].toString());
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billerName']);
    } else if (widget.from == fromAddnewBillOtp) {
      logInfo(widget.templateName.toString());
      logInfo(widget.data!['billName'].toString());
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billName']);
    } else if (widget.from == myBillRoute) {
      logInfo(widget.templateName.toString());
      logInfo(widget.data!['bILLERNAME'].toString());
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['bILLERNAME']);
    } else if (widget.from == confirmPaymentRoute) {
      logInfo(widget.templateName.toString());
      logInfo("AT OTP SCREEN ::::::");
      inspect(widget.data!);
      logInfo(widget.data!['billAmount'].toString());
      BlocProvider.of<OtpCubit>(context).generateOtp(
          templateName: widget.templateName,
          billerName: widget.data!['billAmount']);
    }
    setState(() {
      isLoading = true;
    });
    assignDecodedToken();
    super.initState();
  }

//to get the customerId from token
  void assignDecodedToken() async {
    Map<String, dynamic> decodedToken = await getDecodedToken();
    setState(() {
      decodedTokenCustomer = decodedToken['customerID'];
    });

    logConsole(decodedTokenCustomer.toString(), "customerID");
  }

  void autoRedirect() {
    try {
      logConsole(
          secondsRemaining.toString(), "autoRedirect() :: secondsRemaining: ");

      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        if (secondsRemaining != 0) {
          if (mounted) {
            setState(() {
              secondsRemaining--;
              enableResend = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
            goToReplace(context, homeRoute);
          }
        }
        if (!mounted) {
          timer.cancel();
        }
      });
    } catch (e) {
      logError(e.toString(), "autoRedirect");
    }
  }

//to start timer and dispose timer if the page redirected or else the user navigate to back
  void triggerTimer(dynamic durationValue) {
    try {
      timer = Timer.periodic(Duration(seconds: durationValue), (timer) {
        if (secondsRemaining != 0) {
          if (mounted) {
            setState(() {
              secondsRemaining--;
              enableResend = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              timer.cancel();
              enableResend = true;
            });
          }
        }
        if (!mounted) {
          timer.cancel();
        }
      });
    } catch (e) {
      logError(e.toString(), "Trigger Timer (Fn)");
    }
  }

//function trigger resend otp function
  resendCode() async {
    try {
      resetOtpErr();
      if (widget.from == fromAutoPayDelete) {
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.autopayData!.bILLERNAME);
      } else if (widget.from == fromAutoPayEdit) {
        logInfo(widget.data!['billerName'].toString());
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billerName']);
      } else if (widget.from == fromAutoPayCreate) {
        logInfo(widget.data!['billerName'].toString());
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billerName']);
      } else if (widget.from == fromUpcomingDisable) {
        logInfo(widget.templateName.toString());
        logInfo(widget.data!['billerName'].toString());
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billerName']);
      } else if (widget.from == fromAddnewBillOtp) {
        logInfo(widget.templateName.toString());
        logInfo(widget.data!['billName'].toString());
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billName']);
      } else if (widget.from == myBillRoute) {
        logInfo(widget.templateName.toString());
        logInfo(widget.data!['bILLERNAME'].toString());
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['bILLERNAME']);
      } else if (widget.from == confirmPaymentRoute) {
        logInfo(widget.templateName.toString());
        logInfo(widget.data!['billAmount'].toString());
        BlocProvider.of<OtpCubit>(context).generateOtp(
            templateName: widget.templateName,
            billerName: widget.data!['billAmount']);
      }
      //other code here

      if (mounted) {
        setState(() {
          secondsRemaining = otpTimerDuration;
          // secondsRemaining = otpTimerDuration;
          enableResend = false;
        });
      }
    } catch (e) {
      logError(e.toString(), "Resend OTP Code (fn)");
    }
  }

  // @override
  // void dispose() {
  //   try {
  //     timer!.cancel();
  //     super.dispose();
  //   } catch (e) {
  //    logConsole(e.toString(), name: "Dispose Timer (fn)");
  //   }
  // }

  @override
  void dispose() {
    logInfo("OTP VALIDATION : dispose()");
    if (!mounted) {
      txtOtpController.clear();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void hideDialog() {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpLoading) {
              setState(() {
                isLoading = true;
                refNo = '';
                dataMsg = '';
              });
            } else if (state is OtpSuccess) {
              // receive data
              triggerTimer(1);

              isLoading = false;
              refNo = state.refrenceNumber;
              dataMsg = state.message;
              if (Loader.isShown) {
                Loader.hide();
              }
              txtOtpController.clear();
            } else if (state is OtpFailed) {
              if (Loader.isShown) {
                Loader.hide();
              }
              txtOtpController.clear();
              setState(() {
                isLoading = false;
                errOTPMsg = state.message;
              });
              // showSnackBar(state.message, context);
              //Time Delay when the OTP failed
            } else if (state is OtpError) {
              if (Loader.isShown) {
                Loader.hide();
              }
              setState(() {
                isLoading = false;
                errOTPMsg = state.message;
              });
              // formshowReplace(context, splashRoute);
              goToUntil(context, splashRoute);
            } else if (state is OtpValidateLoading) {
              if (!Loader.isShown) {
                showLoader(context);
              }
            } else if (state is OtpValidateSuccess) {
              setState(() {
                enableReadOnly = true;
              });
              if (!Loader.isShown) {
                showLoader(context);
              }
              logInfo("succesfully verified");
              // delete or do other action
              if (widget.from == fromAutoPayDelete) {
                logConsole(otp, "PASSED OTP");
                BlocProvider.of<OtpCubit>(context)
                    .deleteAutoPay(widget.autopayData!.iD, otp);
              } else if (widget.from == fromAutoPayEdit) {
                logConsole(widget.id.toString(), "idddddddddddddd");
                dynamic payload = widget.data;
                payload['otp'] = otp;
                BlocProvider.of<OtpCubit>(context)
                    .editAutoPay(widget.id, payload);
              } else if (widget.from == fromAutoPayCreate) {
                dynamic payload = widget.data;
                payload['otp'] = otp;
                logConsole(jsonEncode(payload), "Create autopay paload ::");
                BlocProvider.of<OtpCubit>(context).createAutopay(payload);
              } else if (widget.from == fromUpcomingDisable) {
                // disable api call
                BlocProvider.of<OtpCubit>(context).disableUpcomingPay(
                    widget.data!['id'], widget.data!['status'], otp);
              } else if (widget.from == fromAddnewBillOtp) {
                logConsole(jsonEncode(widget.data).toString(),
                    "at otpValidation :: fromAddnewBillOtp ::: ");
                BlocProvider.of<OtpCubit>(context).addNewBiller(
                    widget.data!['billerId'],
                    widget.data!['inputSignatures'],
                    widget.data!['billName'],
                    otp,
                    widget.data!['confirmPaymentRouteData']);
              } else if (widget.from == myBillRoute) {
                BlocProvider.of<OtpCubit>(context).deleteBiller(
                    widget.data!['cbid'], decodedTokenCustomer!, otp);
              } else if (widget.from == confirmPaymentRoute) {
                inspect(widget.data);
                if (!Loader.isShown) {
                  showLoader(context);
                }
                if (widget.data!['isMobilePrepaid'] == null ||
                    widget.data!['isMobilePrepaid'] == false) {
                  BlocProvider.of<OtpCubit>(context).payBill(
                      widget.data!['billerID'],
                      widget.data!['billerName'],
                      widget.data!['billName'],
                      widget.data!['acNo'],
                      widget.data!['billAmount'],
                      widget.data!['customerBillID'],
                      widget.data!['tnxRefKey'],
                      widget.data!['quickPay'],
                      widget.data!['inputSignature'],
                      widget.data!['otherAmount'],
                      widget.data!['autoPayStatus'],
                      widget.data!['billerData'],
                      otp);
                } else {
                  BlocProvider.of<OtpCubit>(context).prepaidPayBill(
                      widget.data!['isMobilePrepaid'],
                      widget.data!['billerID'],
                      widget.data!['billerName'],
                      widget.data!['billName'],
                      widget.data!['acNo'],
                      widget.data!['billAmount'],
                      widget.data!['customerBillID'],
                      widget.data!['tnxRefKey'],
                      widget.data!['quickPay'],
                      widget.data!['inputSignature'],
                      widget.data!['otherAmount'],
                      widget.data!['billerData'],
                      otp,
                      widget.data!['paymentMode'],
                      widget.data!['forChannel'],
                      widget.data!['paymentChannel']);
                }
              }
            } else if (state is OtpValidateFailed) {
              if (Loader.isShown) {
                Loader.hide();
              }
              txtOtpController.clear();
              // showSnackBar(
              // "Check your Internet, Please try again later.", context);
              setState(() {
                isLoading = false;
                errOTPMsg = state.message;
              });
              if (state.message!.contains('OTP validation exceeded')) {
                triggerTimer(0);
                setState(() {
                  showTimer = false;
                  enableResend = false;
                  showResend = false;
                  showGenerateOtpSuccessMsg = false;
                  secondsRemaining = 20;
                });
                autoRedirect();
              }

              // showSnackBar(state.message, context);
            } else if (state is OtpValidateError) {
              if (Loader.isShown) {
                Loader.hide();
              }
              goToUntil(context, splashRoute);
            } else if (state is OtpActionLoading) {
              if (!Loader.isShown) {
                showLoader(context);
              }
            } else if (state is OtpActionSuccess) {
              if (!Loader.isShown) {
                showLoader(context);
              }
              logInfo("action done${state.from}");

              if (state.from == fromAutoPayDelete) {
                customDialog(
                    context: context,
                    dialogHeight: height(context) / 2.7,
                    message: state.message,
                    message2: "",
                    message3: "",
                    title: "Success!",
                    buttonName: "Okay",
                    buttonAction: () {
                      hideDialog();
                      goToUntil(context, homeRoute);
                    },
                    iconSvg: iconSuccessSvg);
              } else if (state.from == fromAutoPayEdit) {
                List<Map<String, dynamic>>? customMessage = [
                  {"type": "normal", "message": "Auto Pay for "},
                  {"type": "bold", "message": state.message},
                  {
                    "type": "normal",
                    "message": "\nhas been updated successfully."
                  }
                ];
                logConsole(customMessage.toString(), "OtpActionSuccess");
                customDialogMultiText(
                    context: context,
                    dialogHeight: height(context) / 2.6,
                    message: customMessage,
                    title: "Success!",
                    buttonName: "Okay",
                    buttonAction: () {
                      hideDialog();

                      goToUntil(context, homeRoute);
                    },
                    iconSvg: iconSuccessSvg);

                // customDialog(
                //     context: context,
                //     dialogHeight: height(context) / 2.7,
                //     message: state.message,
                //     message2: "",
                //     message3: "",
                //     title: "Success!",
                //     buttonName: "Okay",
                //     buttonAction: () {
                //       goToUntil(context, homeRoute);
                //     },
                //     iconSvg: iconSuccessSvg);
              } else if (state.from == fromAutoPayCreate) {
                List<Map<String, dynamic>>? customMessage = [
                  {"type": "normal", "message": "Auto Pay for "},
                  {"type": "bold", "message": state.message},
                  {
                    "type": "normal",
                    "message": "\nhas been created successfully."
                  }
                ];
                logConsole(customMessage.toString(),
                    "OtpActionSuccess :: fromAutoPayCreate");

                customDialogMultiText(
                    context: context,
                    dialogHeight: height(context) / 2.6,
                    message: customMessage,
                    title: "Success!",
                    buttonName: "Okay",
                    buttonAction: () {
                      hideDialog();

                      goToUntil(context, homeRoute);
                    },
                    iconSvg: iconSuccessSvg);
                // customDialog(
                //     context: context,
                //     dialogHeight: height(context) / 2.75,
                //     message: state.message,
                //     message2: "",
                //     message3: "",
                //     title: "Success!",
                //     buttonName: "Okay",
                //     buttonAction: () {
                //       goToUntil(context, homeRoute);
                //     },
                //     iconSvg: iconSuccessSvg);
              } else if (state.from == fromUpcomingDisable) {
                customDialog(
                    context: context,
                    dialogHeight: height(context) / 2.75,
                    message: state.message,
                    message2: "",
                    message3: "",
                    title: "Success!",
                    buttonName: "Okay",
                    buttonAction: () {
                      hideDialog();

                      goToUntil(context, homeRoute);
                    },
                    iconSvg: iconSuccessSvg);
                //
              } else if (state.from == fromAddnewBillOtp) {
                if (!state.data!['enableConfirmPayment']) {
                  if (Loader.isShown) {
                    Loader.hide();
                  }
                  customDialog(
                      context: context,
                      dialogHeight: height(context) / 2.75,
                      message: "The biller has been added successfully",
                      message2: "",
                      message3: "",
                      title: "Success!",
                      buttonName: "Okay",
                      buttonAction: () {
                        hideDialog();

                        goToUntil(context, homeRoute);
                      },
                      iconSvg: iconSuccessSvg);
                } else {
                  if (Loader.isShown) {
                    Loader.hide();
                  }
                  // state.data!['billerData'].forEach((currentValue, index) {
                  //  logConsole(currentValue.toString(), name: "billerData ${index}");
                  // });
                  // state.data!['inputParameters'].forEach((currentValue, index) {
                  //  logConsole(currentValue.toString(),
                  //       name: "inputParameters ${index}");
                  // });

                  List<Map<String, dynamic>>? customMessage = [
                    {"type": "normal", "message": "The biller has been"},
                    {"type": "normal", "message": "\nadded successfully.\n\n"},
                    {
                      "type": "normal",
                      "message": "Your bill has an outstanding amount\n"
                    },
                    {"type": "bold", "message": "Do you want to pay now?"}
                  ];
                  //logConsole(customMessage.toString(), name: "ComplaintSubmitSuccess");
                  SavedBillersData? savedBillerData;
                  BillersData? billerData = state.data!['billerData'];

                  logConsole(billerData!.bILLERNAME.toString(),
                      "state.data!===========");
                  inspect(state.data);
                  PARAMETERS parameters;
                  List<PARAMETERS> inputParameters = [];
                  List<AddbillerpayloadModel>? newParamTwo = [];
                  AddbillerpayloadModel adbillerpayloadModel;
                  PARAMETERS newparam;
                  List newTest = [];

                  logConsole(
                      jsonEncode(state.data!['inputParameters']).toString(),
                      " state.data!['inputParameters']");
                  int dataLength = state.data!['inputParameters'].length;
                  for (int i = 0; i < dataLength; i++) {
                    adbillerpayloadModel = state.data!['inputParameters'][i];
                    Map<String, dynamic> modifiedInputParam = {
                      "PARAMETER_NAME": adbillerpayloadModel.pARAMETERNAME,
                      "PARAMETER_VALUE": adbillerpayloadModel.pARAMETERVALUE,
                    };
                    newTest.add(modifiedInputParam);
                    newparam = PARAMETERS.fromJson(modifiedInputParam);
                    inputParameters.add(newparam);
                  }
                  // state.data!['inputParameters'].forEach((currentValue, index) {
                  //   adbillerpayloadModel = currentValue;
                  //   Map<String, dynamic> modifiedInputParam = {
                  //     "PARAMETER_NAME": adbillerpayloadModel.pARAMETERNAME,
                  //     "PARAMETER_VALUE": adbillerpayloadModel.pARAMETERVALUE,
                  //   };
                  //   newparam = PARAMETERS.fromJson(modifiedInputParam);
                  //   inputParameters.add(newparam);
                  // });
                  logConsole(jsonEncode(inputParameters).toString(),
                      "AFTER CHANGING ::");
                  inspect(state.data!['billerData']);
                  inspect(inputParameters);
                  logConsole(jsonEncode(state.data).toString(), "AT utils ");
                  debugPrint(
                      "&&&&&&&&&&& ${jsonEncode(state.data!['billerData'])}");

                  /***
                             * 
  int? cUSTOMERBILLID;

   "cHANGE_IN_AMOUNT": 
"lASTPAIDDATE"
"lASTBILLAMOUNT"
  "qUICKPAYALLOWED"
"pAYMENTDATE"  
"aUTOPAYID"
"pARAMETERNAME"
pARAMETERVALUE
 tRANSACTIONSTATUS
cOMPLETIONDATE
bILLAMOUNT
  
   bILLNAME;
pARAMETERS;
                             */
                  Map<String, dynamic> newData = {
                    "BILLER_ID": billerData.bILLERID,
                    "CUSTOMER_BILL_ID": state.data!['cUSTOMERBILLID'],
                    "BILLER_NAME": billerData.bILLERNAME,
                    "BILLER_COVERAGE": billerData.bILLERCOVERAGE,
                    "BILLER_ICON": billerData.bILLERICON,
                    "BILLER_EFFECTIVE_FROM": billerData.bILLEREFFECTIVEFROM,
                    "BILLER_EFFECTIVE_TO": billerData.bILLEREFFECTIVETO,
                    "PAYMENT_EXACTNESS": billerData.pAYMENTEXACTNESS,
                    "BILLER_ACCEPTS_ADHOC": billerData.bILLERACCEPTSADHOC,
                    "FETCH_BILL_ALLOWED": billerData.fETCHBILLALLOWED,
                    "VALIDATE_BILL_ALLOWED": billerData.vALIDATEBILLALLOWED,
                    "FETCH_REQUIREMENT": billerData.fETCHREQUIREMENT,
                    "SUPPORT_BILL_VALIDATION": billerData.sUPPORTBILLVALIDATION,
                    "CATEGORY_NAME": billerData.cATEGORYNAME,
                    "BILL_NAME": state.data!['billName'],
                    "PARAMETERS": newTest,
                  };
                  //logConsole(jsonDecode(state.data!['billerData'].toString()));

                  debugPrint("=========newData ${newData}");
                  savedBillerData = SavedBillersData.fromJson(newData);
                  isSavedBillFrom = true;
                  isMobilePrepaidFrom = false;
                  customDialogMultiText(
                      context: context,
                      dialogHeight: height(context) / 2.4,
                      message: customMessage,
                      title: "Success!",
                      buttonName: "Pay",
                      isMultiBTN: true,
                      buttonAction: () {
                        /*
                         onTap: () => goToData(
                                          context, confirmPaymentRoute, {
                                        "billID":
                                            SavedBiller![index].cUSTOMERBILLID,
                                        "name": SavedBiller![index].bILLERNAME,
                                        "number":
                                            SavedBiller![index].pARAMETERVALUE,
                                        "billerID":
                                            SavedBiller![index].bILLERID,
                                        "savedBillersData": SavedBiller![index],
                                        "isSavedBill": true
                                      }),
                         */
                        hideDialog();

                        txtOtpController.clear();
                        //logConsole(state.data!['inputParameters'],
                        //     name: "near gotoData");
                        goToData(context, confirmPaymentRoute, {
                          "name": state.data!['name'],
                          "billName": state.data!['billName'],
                          "savedBillersData": savedBillerData,
                          // "inputParameters": inputParameters,
                          "inputParameters": state.data!['inputParameters'],
                          "isSavedBill": state.data!['isSavedBill'],
                          "billID": state.data!['cUSTOMERBILLID']
                        });
                      },
                      iconSvg: iconSuccessSvg);
                }
              } else if (state.from == myBillRoute) {
                customDialog(
                    context: context,
                    dialogHeight: height(context) / 2.75,
                    message: state.message,
                    message2: "",
                    message3: "",
                    title: "Success!",
                    buttonName: "Okay",
                    buttonAction: () {
                      hideDialog();

                      goToUntil(context, homeRoute);
                    },
                    iconSvg: iconSuccessSvg);
              } else if (state.from == fromConfirmPaymentOtp) {
                debugPrint("fromConfirmPaymentOtp========= ${state.data}");
                logConsole(jsonEncode(state.data).toString(),
                    "at otp validation from confirmpayment");
                inspect(state.data);
                Map<String, dynamic>? temp = {};
                temp = state.data;

                /**
                 * 
                 if (temp!['isMobilePrepaid'] == null ||
                    temp!['isMobilePrepaid'] == false)
                 */
                if (!isMobilePrepaidFrom) {
                  goToReplaceData(context, confirmPaymentDoneRoute, {
                    "data": state.data,
                  });
                } else {
                  var mobileNumberValue = temp!['inputSignature']
                      .firstWhere(
                        (param) =>
                            param.pARAMETERNAME.toString().toLowerCase() ==
                            'mobile number',
                      )
                      .pARAMETERVALUE;
                  List<Map<String, dynamic>>? customMessage = [
                    {"type": "normal", "message": "Your Recharge of ${rupee}"},
                    {"type": "bold", "message": temp!['billAmount'].toString()},
                    {"type": "normal", "message": " to\n"},
                    {"type": "bold", "message": mobileNumberValue.toString()},
                    {
                      "type": "normal",
                      "message": " is successful.\n\n",
                    },
                    {
                      "type": "normal",
                      "message":
                          "{Transaction ID : ${temp!['res']['paymentDetails']['tran']['switchRef']}}"
                    }
                  ];

                  prepaidCustomDialogMultiText(
                      context: context,
                      dialogHeight: isSavedBillFrom
                          ? height(context) / 2.3
                          : height(context) / 2,
                      message: customMessage,
                      title: "Recharge Successful!",
                      buttonName: "View Details",
                      isMultiBTN: true,
                      buttonAction: () {
                        hideDialog();

                        txtOtpController.clear();

                        if (!isSavedBillFrom) {
                          inputSignaturesModelTemp = temp!['inputSignature'];
                          billerDataTemp = temp!['billerData'];
                          // Map<String, dynamic>? confirmpaymentpayload = {
                          //   "data": state.data,
                          //   "billerData": temp!['billerData'],
                          //   "inputSignatureData": temp!['inputSignature']
                          // };
                          // goToReplaceData(context, confirmPaymentDoneRoute, {
                          //   "data": state.data,
                          // });
                        } else {
                          // Map<String, dynamic>? confirmpaymentpayload =
                          //     state.data;
                          // goToReplaceData(context, confirmPaymentDoneRoute, {
                          //   "data": confirmpaymentpayload,
                          // });
                        }
                        goToReplaceData(context, confirmPaymentDoneRoute, {
                          "data": state.data,
                        });
                      },
                      iconSvg: iconSuccessSvg,
                      goToAddBiller: () {
                        if (!isSavedBillFrom) {
                          inspect(temp!['billerData']);
                          goToData(context, addNewBill, {
                            "billerData": temp!['billerData'],
                            "inputSignatureData": temp!['inputSignature']
                          });
                        }
                      });
                }
              }
              if (Loader.isShown) {
                Loader.hide();
              }
            } else if (state is OtpActionFailed) {
              if (Loader.isShown) {
                Loader.hide();
              }
              if (state.from == fromConfirmPaymentOtp) {
                if (state.message == "status_500") {
                  customDialog(
                      context: context,
                      dialogHeight: height(context) / 2.75,
                      message: "Bill payment failed for a transaction",
                      message2: "",
                      message3: "",
                      title: "Alert!",
                      buttonName: "Okay",
                      buttonAction: () {
                        hideDialog();

                        goToUntil(context, homeRoute);
                      },
                      iconSvg: alertSvg);
                } else if (state.message == "timeout") {
                  List<Map<String, dynamic>>? customMessage = [
                    {
                      "type": "normal",
                      "message":
                          "Unable to fetch the current status of the Transaction.Please check the status of the transaction from Transacton History."
                    },
                  ];
                  logConsole(
                      customMessage.toString(), "OtpActionSuccess:: timout");
                  customDialogMultiText(
                      context: context,
                      dialogHeight: height(context) / 2.6,
                      message: customMessage,
                      title: "Alert!",
                      buttonName: "Okay",
                      buttonAction: () {
                        hideDialog();

                        goToUntil(context, homeRoute);
                      },
                      iconSvg: alertSvg);

                  // customDialog(
                  //     context: context,
                  //     dialogHeight: height(context) / 2.75,
                  //     message: " . ",
                  //     message2: "",
                  //     message3: "",
                  //     title: "Alert!",
                  //     buttonName: "Okay",
                  //     buttonAction: () {
                  //       goToUntil(context, homeRoute);
                  //     },
                  //     iconSvg: alertSvg);
                } else {
                  goToReplaceData(context, failedPaymentRoute, {
                    "data": state.data,
                  });
                }
                // customDialog(
                //     context: context,
                //     dialogHeight: height(context) / 2.75,
                //     message: state.message,
                //     message2: "",
                //     message3: "",
                //     title: "Alert!",
                //     buttonName: "Okay",
                //     buttonAction: () {
                //       goToUntil(context, homeRoute);
                //     },
                //     iconSvg: alertSvg);
              } else {
                customDialog(
                    context: context,
                    dialogHeight: height(context) / 2.75,
                    message: state.message,
                    message2: "",
                    message3: "",
                    title: "Alert!",
                    buttonName: "Okay",
                    buttonAction: () {
                      hideDialog();

                      goToUntil(context, homeRoute);
                    },
                    iconSvg: alertSvg);
              }
            } else if (state is OtpActionError) {
              if (Loader.isShown) {
                Loader.hide();
              }
              // showSnackBar(state.message,context);
              goToUntil(context, splashRoute);
            }
          },
          builder: (context, state) {
            //billerName binding for autopay biller or other data

            if (widget.from != confirmPaymentRoute) {
              billerName = widget.data != null
                  ? widget.data!['bILLERNAME']
                  : widget.autopayData!.bILLERNAME!;
            } else {
              billerName = "Confirm Payment";
            }
            return isLoading
                ? Scaffold(
                    backgroundColor: primaryBodyColor,
                    appBar: myAppBar(
                      context: context,
                      title: "OTP Verification",
                      backgroundColor: primaryColor,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          verticalSpacer(10.2),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "OTP Verification",
                                style: TextStyle(
                                  color: txtPrimaryColor,
                                  fontSize: width(context) * 0.044,
                                  fontFamily: appFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          verticalSpacer(15.2),
                          Text(
                            "Reference Number : *******",
                            style: TextStyle(
                              color: txtSecondaryColor,
                              fontSize: width(context) * 0.04,
                              fontFamily: appFont,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          verticalSpacer(20.2),
                          Shimmer.fromColors(
                              baseColor: dashColor,
                              highlightColor: divideColor,
                              child: ShimmerCell(
                                  cellheight: 60.0,
                                  cellwidth: width(context) / 1.5)),
                          verticalSpacer(15.2),
                          Image.asset(
                            LoaderGif,
                            height: height(context) * 0.07,
                            width: height(context) * 0.07,
                          )
                        ],
                      ),
                    ),
                  )
                : OtpVerificationUI(
                    showTimer: showTimer,
                    title: widget.from,
                    refNo: refNo,
                    dataMsg: dataMsg,
                    templateName: widget.templateName,
                    autopayData: widget.autopayData,
                    errMsg: errOTPMsg,
                    resetErr: resetOtpErr,
                    timerValue: secondsRemaining,
                    enableResend: enableResend,
                    billerName: billerName,
                    isLoading: isLoading,
                    resendOtp: resendCode,
                    showResend: showResend,
                    showGenerateOtpSuccessMsg: showGenerateOtpSuccessMsg,
                    enableReadOnly: enableReadOnly);
          },
        ),
      ),
    );
  }
}

class OtpVerificationUI extends StatefulWidget {
  String? title;
  String? refNo;
  String? billerName;
  String? dataMsg;
  bool? isLoading;
  AllConfigurationsData? autopayData;
  String? errMsg;
  String? templateName;
  void Function() resetErr;
  int? timerValue;
  bool? enableResend;
  bool showTimer;
  bool showResend;
  bool showGenerateOtpSuccessMsg;
  dynamic Function() resendOtp;
  bool enableReadOnly;
  OtpVerificationUI(
      {Key? key,
      @required this.title,
      @required this.refNo,
      @required this.billerName,
      @required this.templateName,
      @required this.autopayData,
      @required this.errMsg,
      @required this.dataMsg,
      @required this.isLoading,
      this.timerValue,
      this.enableResend,
      required this.resendOtp,
      required this.resetErr,
      required this.showTimer,
      required this.showGenerateOtpSuccessMsg,
      required this.showResend,
      required this.enableReadOnly})
      : super(key: key);

  @override
  State<OtpVerificationUI> createState() => _OtpVerificationUIState();
}

class _OtpVerificationUIState extends State<OtpVerificationUI> {
  bool isButtonActive = false;
  // int secondsRemaining = 180;
  // bool enableResend = false;
  static const length = 6;
  static const errorColor = Color.fromRGBO(255, 234, 238, 1);
  static const fillColor = Color.fromRGBO(222, 231, 240, .57);

  Timer? timer;
  @override
  void initState() {
    if (!widget.showResend) {
      setState(() {
        isButtonActive = false;
      });
    }
    super.initState();
    if (Loader.isShown) {
      Loader.hide();
    }
  }

  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    if (Loader.isShown) {
      Loader.hide();
    }
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final defaultPinTheme = PinTheme(
    //   width: width(context) * 0.13,
    //   height: height(context) * 0.07,
    //   textStyle: TextStyle(
    //     fontSize: width(context) * 0.045,
    //     letterSpacing: 16.0,
    //     fontWeight: FontWeight.bold,
    //     color: txtAmountColor,
    //   ),
    //   decoration: BoxDecoration(
    //     color: fillColor,
    //     borderRadius: BorderRadius.circular(8),
    //     border: Border.all(color: Colors.transparent),
    //   ),
    // );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: myAppBar(
          context: context,
          title: "OTP Verification",
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 32,
                ),
                // color: Colors.amber[300],
                height: height(context) / 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: appText(
                          data: "OTP Verification",
                          size: width(context) * 0.045,
                          color: txtPrimaryColor,
                          weight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                        height: height(context) * 0.04,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appText(
                              data: widget.refNo!.isNotEmpty
                                  ? "Reference Number "
                                  : "",
                              size: width(context) * 0.04,
                              color: txtSecondaryDarkColor,
                            ),
                            appText(
                                data: widget.refNo,
                                size: width(context) * 0.04,
                                color: txtSecondaryDarkColor,
                                weight: FontWeight.bold),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //     vertical: 32,
                      //   ),
                      //   child: SizedBox(
                      //     height: 68,
                      //     child: Pinput(
                      //       length: length,
                      //       controller: txtOtpController,
                      //       focusNode: focusNode,
                      //       androidSmsAutofillMethod:
                      //           AndroidSmsAutofillMethod.smsUserConsentApi,
                      //       listenForMultipleSmsOnAndroid: true,
                      //       defaultPinTheme: defaultPinTheme,
                      //       onChanged: (s) {
                      //         widget.resetErr();
                      //         if (s.isEmpty) {
                      //           setState(
                      //             () => isButtonActive = false,
                      //           );
                      //         } else {
                      //           if (s.length < 6) {
                      //             setState(
                      //               () => isButtonActive = false,
                      //             );
                      //           } else {
                      //             setState(
                      //               () => isButtonActive = true,
                      //             );
                      //           }
                      //         }
                      //       },
                      //       focusedPinTheme: defaultPinTheme.copyWith(
                      //         // height: 68,
                      //         // width: 64,
                      //         width: width(context) * 0.23,
                      //         height: height(context) * 0.08,
                      //         decoration: defaultPinTheme.decoration!.copyWith(
                      //           border: Border.all(color: txtAmountColor),
                      //         ),
                      //       ),
                      //       keyboardType: TextInputType.number,
                      //       enabled: widget.refNo!.isEmpty ? false : true,
                      //       inputFormatters: <TextInputFormatter>[
                      //         // for below version 2 use this
                      //         FilteringTextInputFormatter.allow(
                      //             RegExp(r'[0-9]')),
                      //         // for version 2 and greater youcan also use this
                      //         FilteringTextInputFormatter.digitsOnly
                      //       ],
                      //       errorPinTheme: defaultPinTheme.copyWith(
                      //         decoration: BoxDecoration(
                      //           color: errorColor,
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      //OTP Textformfield
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 64,
                        ),
                        child: PhysicalModel(
                          // borderRadius: BorderRadius.circular(4),
                          color: txtColor,
                          elevation: 3,
                          shadowColor: primaryBodyColor,
                          child: TextFormField(
                            readOnly: widget.enableReadOnly,
                            textAlign: TextAlign.center,
                            enableInteractiveSelection:
                                widget.refNo!.isEmpty ? false : true,
                            enabled: widget.refNo!.isEmpty ? false : true,
                            controller: txtOtpController,
                            onChanged: (s) {
                              widget.resetErr();
                              if (s.isEmpty) {
                                setState(
                                  () => isButtonActive = false,
                                );
                              } else {
                                if (s.length < 6) {
                                  setState(
                                    () => isButtonActive = false,
                                  );
                                } else {
                                  setState(
                                    () => isButtonActive = true,
                                  );
                                }
                              }
                            },
                            inputFormatters: <TextInputFormatter>[
                              // for below version 2 use this
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              // for version 2 and greater youcan also use this
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: txtCursorColor,
                            cursorWidth: 4.0,
                            maxLines: 1,
                            maxLength: 6,
                            style: TextStyle(
                              fontSize: width(context) * 0.06,
                              letterSpacing: 16.0,
                              fontWeight: FontWeight.bold,
                              color: txtAmountColor,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counter: Container(),
                              fillColor: primaryBodyColor,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: txtColor, width: 0.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: txtColor, width: 0.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: txtColor, width: 0.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: txtColor, width: 0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.errMsg != null,
                        child: Text(
                          widget.errMsg.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: txtRejectColor),
                        ),
                      ),
                      Visibility(
                        visible: widget.isLoading!,
                        child: Image.asset(
                          LoaderGif,
                          height: height(context) * 0.07,
                          width: height(context) * 0.07,
                        ),
                      ),
                      if (widget.showTimer)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            appText(
                              data: widget.refNo!.isNotEmpty
                                  ? "OTP valid for"
                                  : '',
                              size: width(context) * 0.04,
                              color: txtSecondaryDarkColor,
                              weight: FontWeight.w400,
                            ),
                            appText(
                              data: widget.refNo!.isNotEmpty
                                  ? " ${widget.timerValue.toString()} seconds"
                                  : '',
                              size: width(context) * 0.04,
                              color: alertFailedColor,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      if (widget.showGenerateOtpSuccessMsg)
                        Container(
                          margin: const EdgeInsets.only(
                              top: 32, left: 32, right: 32),
                          height: height(context) * 0.08,
                          child: appText(
                            data: widget.dataMsg!,
                            size: width(context) * 0.04,
                            color: txtSecondaryDarkColor,
                            align: TextAlign.center,
                          ),
                        ),
                      if (widget.showResend)
                        InkWell(
                          onTap: widget.enableResend!
                              ? () => widget.resendOtp()
                              : null,
                          child: appText(
                            data: "Resend OTP",
                            textAlign: TextAlign.center,
                            color: widget.enableResend!
                                ? txtCheckBalanceColor
                                : txtHintColor,
                            weight: FontWeight.w400,
                            size: width(context) * 0.04,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: myAppButton(
                context: context,
                buttonName: "Verify",
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                onpress: isButtonActive
                    ? () async {
                        if (txtOtpController.text.isNotEmpty) {
                          if (await isConnected()) {
                            otp = txtOtpController.text;
                            if (!Loader.isShown) {
                              showLoader(context);
                            }
                            BlocProvider.of<OtpCubit>(context)
                                .validateOTP(txtOtpController.text);
                            setState(() {
                              isButtonActive = false;
                            });
                          } else {
                            showSnackBar(noInternetMessage, context);
                          }
                        } else {
                          showSnackBar("Invalid OTP", context);
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
