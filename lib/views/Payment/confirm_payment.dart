import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/input_signatures_model.dart';
import 'package:bbps/model/prepaid_fetch_plans_model.dart';
import 'package:bbps/model/saved_billers_model.dart';
import 'package:bbps/model/validate_bill_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../bloc/home/billflow_cubit.dart';
import '../../bloc/home/billflow_state.dart';
import '../../model/account_info_model.dart';
import '../../model/add_bill_payload_model.dart';
import '../../model/auto_schedule_pay_model.dart';
import '../../model/bbps_settings_model.dart';
import '../../model/biller_model.dart';
import '../../model/confirm_fetch_bill_model.dart';
import '../../model/fetch_bill_model.dart';
import '../../model/paymentInformationModel.dart';
import '../../model/saved_bill_details_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

// has pending work
class ConfirmPayment extends StatefulWidget {
  int? billID;
  String? billerName;
  String? billName;
  bool isSavedBill;

  BillersData? billerData;
  SavedBillersData? savedBillersData;
  List<AddbillerpayloadModel>? inputParameters;
  List<InputSignaturesData>? inputSignatureItems = [];

  PrepaidPlansData? selectedPrepaidPlan;
  bool? isMobilePrepaid;
  String? selectedCircle;
  String? mobileNumber;
  ConfirmPayment(
      {Key? key,
      required this.billID,
      required this.billerName,
      required this.isSavedBill,
      this.billerData,
      required this.savedBillersData,
      required this.inputParameters,
      this.billName,
      this.selectedPrepaidPlan,
      this.isMobilePrepaid,
      this.selectedCircle,
      this.inputSignatureItems,
      this.mobileNumber})
      : super(key: key);

  @override
  _ConfirmPaymentState createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  List<InputSignatures>? savedInputSignatures = [];
  List<PARAMETERS>? prepaidParameters = [];
  List<AllConfigurations>? allautoPaymentList = [];
  List<UpcomingPaymentsData>? upcomingPaymentList = [];

  // List<BillNameDetail>? billName = [];
  PaymentInformationData? paymentInform;
  bbpsSettingsData? BbpsSettingInfo;
  String _dailyLimit = "0";
  BillerResponse? _billerResponseData;
  int? _customerBIllID;
  //  List<Tag> newTag = [];
  //  Map<String,dynamic> temp = {
  //   "Tag" : null
  //  };
  // AdditionalInfo? _additionalInfo = AdditionalInfo.fromJson(temp);
  AdditionalInfo? _additionalInfo;
  Map<String, dynamic> billerInputSign = {};
  AutoSchedulePayModel? autoSchedulePayData = AutoSchedulePayModel();

  List<AccountsData>? accountInfo = [];
  int billAmount = 0;
  Map<String, dynamic>? validateBill;
  List<AddbillerpayloadModel>? newAddbillerParams = [];

  void helperFunction() async {
    logConsole(myAccounts.toString(), "myAccounts");
    if (myAccounts!.length > 0)
      BlocProvider.of<billFlowCubit>(context).getAccountInfo(myAccounts);

    if (widget.isSavedBill) {
      setState(() {
        validateBill = getBillerType(
            widget.savedBillersData!.fETCHREQUIREMENT,
            widget.savedBillersData!.bILLERACCEPTSADHOC,
            widget.savedBillersData!.sUPPORTBILLVALIDATION,
            widget.savedBillersData!.pAYMENTEXACTNESS);
      });
      if (widget.isMobilePrepaid == true) {
        isAmountByDateLoading = false;
        isFetchBillLoading = false;
        isSavedBillerDetailsLoading = false;
        Map<String, dynamic> inputParameters = {
          "Mobile Number": widget.savedBillersData?.pARAMETERS!
              .firstWhere(
                (param) =>
                    param.pARAMETERNAME.toString().toLowerCase() ==
                    'mobile number',
              )
              .pARAMETERVALUE
              .toString(),
          // "Mobile Number": widget.savedBillersData!.pARAMETERVALUE,
          "Circle": widget.selectedCircle,
          "Id": widget.selectedPrepaidPlan!.billerPlanId
        };
        inputParameters.forEach((key, value) {
          billerInputSign[key] = value;
        });
        // for (var element in List.from(inputParameters)) {
        //   billerInputSign[element.pARAMETERNAME.toString()] =
        //       element.pARAMETERVALUE.toString();
        // }
        logConsole(widget.savedBillersData!.pARAMETERS!.asMap().toString(),
            "HERE :::");
        List<PARAMETERS> newInputParameters = [];

        PARAMETERS newparam;
        List newTest = [];
        var dataLength = widget.savedBillersData!.pARAMETERS!.length;
        for (int i = 0; i < dataLength; i++) {
          Map<String, dynamic> modifiedInputParam = {
            "PARAMETER_NAME":
                widget.savedBillersData!.pARAMETERS![i].pARAMETERNAME,
            "PARAMETER_VALUE":
                widget.savedBillersData!.pARAMETERS![i].pARAMETERVALUE,
          };
          newTest.add(modifiedInputParam);
          newparam = PARAMETERS.fromJson(modifiedInputParam);
          newInputParameters.add(newparam);
        }
        setState(() {
          prepaidParameters = newInputParameters;
        });
        // savedInputSignatures = widget.savedBillersData.pARAMETERS;
      }
    } else if (widget.isMobilePrepaid == null ||
        widget.isMobilePrepaid!.toString().isEmpty ||
        widget.isMobilePrepaid == false) {
      setState(() {
        validateBill = getBillerType(
            widget.billerData!.fETCHREQUIREMENT,
            widget.billerData!.bILLERACCEPTSADHOC,
            widget.billerData!.sUPPORTBILLVALIDATION,
            widget.billerData!.pAYMENTEXACTNESS);
      });
      inspect(validateBill);

      for (var element in widget.inputParameters!) {
        billerInputSign[element.pARAMETERNAME.toString()] =
            element.pARAMETERVALUE.toString();
      }
      if (validateBill!["fetchBill"]) {
        BlocProvider.of<billFlowCubit>(context).fetchBill(
            billerID: widget.billerData!.bILLERID,
            quickPay: false,
            quickPayAmount: "0",
            adHocBillValidationRefKey: null,
            validateBill: validateBill!["validateBill"],
            billerParams: billerInputSign,
            billName: widget.isSavedBill ? null : widget!.billName);
      } else {
        isFetchBillLoading = false;
      }
    } else if (widget.isMobilePrepaid == true) {
      isAmountByDateLoading = false;
      isFetchBillLoading = false;
      isSavedBillerDetailsLoading = false;
      setState(() {
        validateBill = getBillerType(
            widget.billerData!.fETCHREQUIREMENT,
            widget.billerData!.bILLERACCEPTSADHOC,
            widget.billerData!.sUPPORTBILLVALIDATION,
            widget.billerData!.pAYMENTEXACTNESS);
      });
      inspect(validateBill);
      debugPrint("widget.inputSignatureItems :::::::::::::");
      inspect(widget.inputSignatureItems);
      List<AddbillerpayloadModel> newInputAddbillerParams = [];
      AddbillerpayloadModel tempModel;
      var newParameterValue = "";

      for (var element in widget.inputSignatureItems!) {
        if (element.pARAMETERNAME.toString().toLowerCase() == "mobile number") {
          newParameterValue = widget.mobileNumber.toString();
        } else if (element.pARAMETERNAME.toString().toLowerCase() == "circle") {
          newParameterValue = widget.selectedCircle.toString();
        } else if (element.pARAMETERNAME.toString().toLowerCase() == "id") {
          newParameterValue = "";
        }
        Map<String, dynamic> tempMap = {
          "BILLER_ID": element.bILLERID.toString(),
          "PARAMETER_ID": element.pARAMETERID,
          "PARAMETER_NAME": element.pARAMETERNAME.toString(),
          "PARAMETER_VALUE": newParameterValue,
          "PARAMETER_TYPE": element.pARAMETERTYPE.toString(),
          "MIN_LENGTH": element.mINLENGTH,
          "MAX_LENGTH": element.mAXLENGTH,
          "REGEX": element.rEGEX == null ? null : element.rEGEX.toString(),
          "OPTIONAL": element.oPTIONAL.toString(),
          "ERROR": element.eRROR == null ? "" : element.eRROR.toString()
        };
        tempModel = AddbillerpayloadModel.fromJson(tempMap);
        newInputAddbillerParams.add(tempModel);
      }

      List<PARAMETERS> newInputParameters = [];

      PARAMETERS newparam;
      List newTest = [];
      var dataLength = widget.inputSignatureItems!.length;
      var newParameterValueTwo = "";

      for (int i = 0; i < dataLength; i++) {
        if (widget.inputSignatureItems![i].pARAMETERNAME
                .toString()
                .toLowerCase() ==
            "mobile number") {
          newParameterValueTwo = widget.mobileNumber.toString();
        } else if (widget.inputSignatureItems![i].pARAMETERNAME
                .toString()
                .toLowerCase() ==
            "circle") {
          newParameterValueTwo = widget.selectedCircle.toString();
        } else if (widget.inputSignatureItems![i].pARAMETERNAME
                .toString()
                .toLowerCase() ==
            "id") {
          newParameterValueTwo = "";
        }
        Map<String, dynamic> modifiedInputParam = {
          "PARAMETER_NAME": widget.inputSignatureItems![i].pARAMETERNAME,
          "PARAMETER_VALUE": newParameterValueTwo,
        };
        newTest.add(modifiedInputParam);
        newparam = PARAMETERS.fromJson(modifiedInputParam);
        newInputParameters.add(newparam);
      }
      setState(() {
        prepaidParameters = newInputParameters;
      });

      debugPrint("check herer ============");

      inspect(newInputAddbillerParams);
      Map<String, dynamic> inputParameters = {
        "Mobile Number": widget.mobileNumber,
        "Circle": widget.selectedCircle,
        "Id": widget.selectedPrepaidPlan!.billerPlanId
      };
      inputParameters.forEach((key, value) {
        billerInputSign[key] = value;
      });
      setState(() {
        newAddbillerParams = newInputAddbillerParams;
      });
    }

    debugPrint(
        "validateBill ============> ${validateBill!["fetchBill"]}${validateBill!["amountEditable"]}${validateBill!["validateBill"]}${validateBill!["billerType"]}${validateBill!["isAdhoc"]}${validateBill!["quickPay"]}${jsonEncode(myAccounts)}");
  }

  @override
  void initState() {
    helperFunction();
    logConsole(
        jsonEncode(widget.savedBillersData).toString(), "savedBillersData :::");
    logConsole(jsonEncode(widget.billerData).toString(), "billerData :::");
    logConsole(isSavedBillFrom.toString(), "isSavedBillFrom ::::");
    logConsole(isMobilePrepaidFrom.toString(), "isMobilePrepaidFrom::::");

    if (widget.isSavedBill &&
        (widget.isMobilePrepaid == null ||
            widget.isMobilePrepaid!.toString().isEmpty)) {
      BlocProvider.of<billFlowCubit>(context).getSavedDetails(widget.billID);
    }
    BlocProvider.of<billFlowCubit>(context).getAmountByDate();
    BlocProvider.of<billFlowCubit>(context).getBbpsSettings();
    BlocProvider.of<billFlowCubit>(context).getPaymentInformation(
        widget.isSavedBill
            ? widget.savedBillersData!.bILLERID
            : widget.billerData!.bILLERID);
    BlocProvider.of<billFlowCubit>(context).getAutopay();

    super.initState();
  }

  bool isAmountByDateLoading = true;

  bool isFetchBillLoading = true;

  bool isPaymentInfoLoading = true;

  bool isAccLoading = true;

  bool isBBPSSettingsLoading = true;

  bool isSavedBillerDetailsLoading = false;

  bool isAutopayLoading = true;

  @override
  Widget build(BuildContext context) {
    void hideDialog() {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return Scaffold(
      backgroundColor: primaryBodyColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: primaryColor,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: txtColor,
          ),
        ),
        title: appText(
          data: "Confirm Payment",
          size: width(context) * 0.05,
          weight: FontWeight.w600,
        ),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
            width: width(context) / 4,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 5),
                width: width(context) / 5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(bbpspngLogo),
                  fit: BoxFit.contain,
                ))),
          )
        ],
      ),
      body: BlocConsumer<billFlowCubit, billFlowState>(
        listener: (context, state) {
          if (state is AllAutopayLoading) {
            isAutopayLoading = true;
          } else if (state is AllAutopaySuccess) {
            autoSchedulePayData = state.autoSchedulePayData;
            allautoPaymentList = autoSchedulePayData!.data!.allConfigurations!;
            upcomingPaymentList =
                autoSchedulePayData!.data!.upcomingPayments!.isEmpty
                    ? []
                    : autoSchedulePayData!.data!.upcomingPayments![0].data;
            // model = state.autoSchedulePayModel.data.allConfigurations;
            // allautoPaymentList = model!.data!.allConfigurations!;

            isAutopayLoading = false;
          } else if (state is AllAutopayFailed) {
            isAutopayLoading = false;

            showSnackBar(state.message, context);
          } else if (state is AllAutopayError) {
            isAutopayLoading = false;

            goToUntil(context, splashRoute);
          }
          if (state is SavedBillDetailsLoading) {
            // showLoader(context);
            helperFunction();
            isSavedBillerDetailsLoading = true;
          } else if (state is SavedBillDetailsSuccess) {
            // showLoader(context);

            savedInputSignatures = state.SavedBillDetails?.inputSignatures;
            // billName = state.SavedBillDetails?.billName;

            for (var element in savedInputSignatures!) {
              billerInputSign[element.pARAMETERNAME.toString()] =
                  element.pARAMETERVALUE.toString();
            }
            if (validateBill!["fetchBill"]) {
              BlocProvider.of<billFlowCubit>(context).fetchBill(
                  billerID: widget.savedBillersData!.bILLERID,
                  quickPay: false,
                  quickPayAmount: "0",
                  adHocBillValidationRefKey: null,
                  validateBill: validateBill!["validateBill"],
                  billerParams: billerInputSign,
                  billName: widget.isSavedBill ? null : widget!.billName);
            } else {
              isFetchBillLoading = false;
            }
            // showLoader(context);
          } else if (state is SavedBillDetailsFailed) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            // isSavedBillerDetailsLoading = false;

            customDialog(
                title: "Alert!",
                message: state.message.toString(),
                message2: "",
                message3: "",
                buttonName: "Okay",
                dialogHeight: height(context) / 3,
                buttonAction: () {
                  hideDialog();

                  goBack(context);
                  goBack(context);
                },
                context: context,
                iconSvg: alertSvg);
            showSnackBar(state.message, context);
          } else if (state is SavedBillDetailsError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isSavedBillerDetailsLoading = false;

            goToUntil(context, splashRoute);
          }

          if (state is PaymentInfoLoading) {
            // showLoader(context);
            isPaymentInfoLoading = true;
          } else if (state is PaymentInfoSuccess) {
            paymentInform = state.PaymentInfoDetail!.data;
            if (widget.isMobilePrepaid == null ||
                widget.isMobilePrepaid!.toString().isEmpty) Loader.hide();
            isPaymentInfoLoading = false;
          } else if (state is PaymentInfoFailed) {
            // isPaymentInfoLoading = false;

            customDialog(
                title: "Alert!",
                message: state.message.toString(),
                message2: "",
                message3: "",
                buttonName: "Okay",
                dialogHeight: height(context) / 3,
                buttonAction: () {
                  hideDialog();

                  goBack(context);
                  goBack(context);
                },
                context: context,
                iconSvg: alertSvg);
            // showSnackBar(state.message, context);
          } else if (state is PaymentInfoError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isPaymentInfoLoading = false;

            goToUntil(context, splashRoute);
          }

          if (state is BbpsSettingsLoading) {
            isBBPSSettingsLoading = true;

            // showLoader(context);
          } else if (state is BbpsSettingsSuccess) {
            BbpsSettingInfo = state.BbpsSettingsDetail!.data;
            if (widget.isMobilePrepaid == null ||
                widget.isMobilePrepaid!.toString().isEmpty) Loader.hide();
            isBBPSSettingsLoading = false;
          } else if (state is BbpsSettingsFailed) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            // isBBPSSettingsLoading = false;

            customDialog(
                title: "Alert!",
                message: state.message.toString(),
                message2: "",
                message3: "",
                buttonName: "Okay",
                dialogHeight: height(context) / 3,
                buttonAction: () {
                  hideDialog();

                  goBack(context);
                  goBack(context);
                },
                context: context,
                iconSvg: alertSvg);
            showSnackBar(state.message, context);
          } else if (state is BbpsSettingsError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isBBPSSettingsLoading = false;

            goToUntil(context, splashRoute);
          }

          if (state is AmountByDateLoading) {
            isAmountByDateLoading = true;
            // showLoader(context);
          } else if (state is AmountByDateSuccess) {
            _dailyLimit = state.amountByDate!;
            // if (widget.isMobilePrepaid == null ||
            //     widget.isMobilePrepaid!.toString().isEmpty) Loader.hide();
            if (widget.isMobilePrepaid == null ||
                widget.isMobilePrepaid!.toString().isEmpty) {
              isAmountByDateLoading = false;
            }
          } else if (state is AmountByDateFailed) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            // isAmountByDateLoading = false;

            customDialog(
                title: "",
                message: state.message.toString(),
                // title: "Fetch Bill Error!",
                // message: state.message.toString(),
                message2: "",
                message3: "",
                buttonName: "Okay",
                dialogHeight: height(context) / 3,
                buttonAction: () {
                  hideDialog();

                  goBack(context);
                  goBack(context);
                },
                context: context,
                iconSvg: alertSvg,
                fromConfirmPayment: true);
            showSnackBar(state.message, context);
          } else if (state is AmountByDateError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isAmountByDateLoading = false;

            goToUntil(context, splashRoute);
          }
          if (state is FetchBillLoading) {
            isFetchBillLoading = true;
            // showLoader(context);
          } else if (state is FetchBillSuccess) {
            // final res = state.fetchBillResponse!.data?.data?.billerResponse;
            _billerResponseData =
                state.fetchBillResponse!.data!.data!.billerResponse;
            // debugPrint(state.fetchBillResponse!.data!.data!.billerResponse);
            _customerBIllID = state.fetchBillResponse!.customerbillId;
            _additionalInfo =
                state.fetchBillResponse!.data!.data!.additionalInfo;
            BlocProvider.of<billFlowCubit>(context).getAddUpdateUpcomingDue(
                customerBillID: widget.isSavedBill
                    ? widget.savedBillersData!.cUSTOMERBILLID
                    : _customerBIllID,
                dueAmount: _billerResponseData!.amount,
                dueDate: _billerResponseData!.dueDate,
                billDate: _billerResponseData!.billDate,
                billPeriod: _billerResponseData!.billPeriod);

            // billAmount = int.parse(state
            //     .fetchBillResponse!.data!.data!.billerResponse!.amount
            //     .toString());
            isFetchBillLoading = false;
          } else if (state is FetchBillFailed) {
            BlocProvider.of<billFlowCubit>(context).getAddUpdateUpcomingDue();
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            // isFetchBillLoading = false;

            customDialog(
                title: "",
                message: state.message.toString(),
                // title: "Fetch Bill Error!",
                // message: state.message.toString(),
                message2: "",
                message3: "",
                buttonName: "Okay",
                dialogHeight: height(context) / 2.6,
                buttonAction: () {
                  hideDialog();

                  goBack(context);
                  goBack(context);
                  // goToUntil(context, homeRoute);
                },
                context: context,
                iconSvg: alertSvg,
                fromConfirmPayment: true);
          } else if (state is FetchBillError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isFetchBillLoading = false;

            goToUntil(context, splashRoute);
          }

          if (state is AccountInfoLoading) {
            // if (!Loader.isShown) {
            //   showLoader(context);
            // }
            isAccLoading = true;
          } else if (state is AccountInfoSuccess) {
            accountInfo = state.accountInfo;
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isAccLoading = false;
          } else if (state is AccountInfoFailed) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            isAccLoading = false;

            customDialog(
                title: "",
                message: state.message.toString(),
                // title: "Fetch Bill Error!",
                // message: state.message.toString(),
                message2: "",
                message3: "",
                buttonName: "Okay",
                dialogHeight: height(context) / 3,
                buttonAction: () {
                  hideDialog();

                  goBack(context);
                  goBack(context);
                },
                context: context,
                iconSvg: alertSvg,
                fromConfirmPayment: true);
          } else if (state is AccountInfoError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }

            goToUntil(context, splashRoute);
          }

          if (state is AddUpdateUpcomingDueLoading) {
            // showLoader(context);
          } else if (state is AddUpdateUpcomingDueSuccess) {
          } else if (state is AddUpdateUpcomingDueFailed) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            // customDialog(
            //     title: "",
            //     message: state.message.toString(),
            //     // title: "Fetch Bill Error!",
            //     // message: state.message.toString(),
            //     message2: "",
            //     message3: "",
            //     buttonName: "Okay",
            //     dialogHeight: height(context) / 3,
            //     buttonAction: () {
            //       goBack(context);
            //       goBack(context);
            //     },
            //     context: context,
            //     iconSvg: alertSvg,
            //     fromConfirmPayment: true);
          } else if (state is AddUpdateUpcomingDueError) {
            // if (Loader.isShown) {
            //   Loader.hide();
            // }
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          return !(isAmountByDateLoading ||
                  isFetchBillLoading ||
                  isPaymentInfoLoading ||
                  isBBPSSettingsLoading ||
                  isAutopayLoading ||
                  isSavedBillerDetailsLoading)
              ? ConformPaymentUI(
                  id: widget.billID,
                  billerID: widget.isSavedBill
                      ? widget.savedBillersData!.bILLERID
                      : widget.billerData!.bILLERID,
                  billerName: widget.billerName,
                  billName: widget.isSavedBill
                      ? widget.savedBillersData!.bILLNAME
                      : widget.billName,
                  billerData: widget.billerData,
                  savedInputSignatures: savedInputSignatures,
                  inputParameters: widget.inputParameters,
                  paymentInfo: paymentInform,
                  settingInfo: BbpsSettingInfo,
                  billerResData: _billerResponseData,
                  additionalInfo: _additionalInfo,
                  accInfo: accountInfo,
                  isAccLoading: isAccLoading,
                  isSavedBill: widget.isSavedBill,
                  savedBillerData: widget.savedBillersData,
                  validate_bill: validateBill,
                  dailyLimit: _dailyLimit,
                  billerParams: billerInputSign,
                  isMobilePrepaid:
                      widget.isMobilePrepaid == null ? false : true,
                  selectedPrepaidPlan: widget.selectedPrepaidPlan,
                  selectedCircle: widget.selectedCircle,
                  prepaidParameters: prepaidParameters,
                  newCustomerBillId: _customerBIllID,
                  allAutopayData: allautoPaymentList,
                  allAutopayUpcomingData: upcomingPaymentList)
              : Container(
                  height: height(context),
                  child: Center(
                    heightFactor: height(context) * 0.0097,
                    child: Image.asset(
                      LoaderGif,
                      height: height(context) * 0.07,
                      width: height(context) * 0.07,
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class ConformPaymentUI extends StatefulWidget {
  PrepaidPlansData? selectedPrepaidPlan;
  List<PARAMETERS>? prepaidParameters = [];

  //MOBILE PREPAID = TRUE
  List<AddbillerpayloadModel>? newAddbillerParams = [];

  int? id;
  String? billerName;
  dynamic accNumber;
  bool isSavedBill;
  List<InputSignatures>? savedInputSignatures;
  String? billName;
  // List<BillNameDetail>? billName;
  PaymentInformationData? paymentInfo;
  bbpsSettingsData? settingInfo;
  BillerResponse? billerResData;
  AdditionalInfo? additionalInfo;
  List<AccountsData>? accInfo;
  SavedBillersData? savedBillerData;
  String? billerID;
  Map<String, dynamic>? validate_bill;
  String dailyLimit;
  Map<String, dynamic>? billerParams;
  BillersData? billerData;
  List<AddbillerpayloadModel>? inputParameters;
  bool isMobilePrepaid;
  String? selectedCircle;
  bool? isAccLoading;
  dynamic? newCustomerBillId;
  dynamic? allAutopayData;
  dynamic? allAutopayUpcomingData;
  ConformPaymentUI(
      {super.key,
      required this.id,
      required this.billerName,
      this.savedInputSignatures,
      this.billName,
      this.paymentInfo,
      this.settingInfo,
      this.billerResData,
      this.additionalInfo,
      this.accInfo,
      this.billerID,
      this.savedBillerData,
      this.validate_bill,
      required this.isSavedBill,
      required this.dailyLimit,
      this.billerParams,
      this.billerData,
      this.inputParameters,
      required this.isMobilePrepaid,
      this.selectedCircle,
      this.selectedPrepaidPlan,
      this.prepaidParameters,
      this.isAccLoading,
      this.newCustomerBillId,
      this.allAutopayData,
      this.allAutopayUpcomingData,
      this.newAddbillerParams});
  @override
  State<ConformPaymentUI> createState() => _ConformPaymentUIState();
}

class _ConformPaymentUIState extends State<ConformPaymentUI> {
  final txtAmountController = TextEditingController();
  int selectedAccount = 9999;
  String? errorMsg = "";
  bool _amountForAdhocBill = false;
  bool _otherAmount = false;
  double userAmount = 0;
  bool isInsufficient = true;
  ConfirmFetchBillData? confirmbillerResData;
  dynamic billAmount = 0;
  bool? isAmountEmpty = false;
  void initState() {
    // txtAmountController.text = "0";
    isInsufficient = false;
    if (widget.isMobilePrepaid == false) {
      if (widget.billerResData != null) {
        txtAmountController.text = widget.billerResData!.amount.toString();
      } else {
        txtAmountController.text = "0";
      }
    } else {
      txtAmountController.text = widget.selectedPrepaidPlan!.amount.toString();
      // if (double.parse(widget.accInfo![selectedAccount].balance.toString()) <
      //         double.parse(txtAmountController.text) ||
      //     double.parse(txtAmountController.text) <
      //         double.parse(widget.paymentInfo!.mINLIMIT.toString()) ||
      //     double.parse(txtAmountController.text) >
      //         double.parse(widget.paymentInfo!.mAXLIMIT.toString())) {
      //   setState(() {
      //     isInsufficient = true;
      //   });
      // } else {
      //   setState(() {
      //     isInsufficient = false;
      //   });
      // }
    }

    if (widget.validate_bill!["fetchBill"]) {
      billAmount = getFetchBillDetails();
      debugPrint("billAmount $billAmount");

      if (!_amountForAdhocBill) {
        debugPrint("_amountForAdhocBill $_amountForAdhocBill");
        userAmount = double.parse(billAmount);
        debugPrint("_amountForAdhocBill $userAmount");
      }
      // userAmount = 100;
    }

    super.initState();
  }

  NumberFormat rupeeFormatWithSymbol =
      NumberFormat.currency(locale: "en_IN", symbol: '₹', name: '');
  rupeeCov(numb) {
    dynamic data;
    data = rupeeFormatWithSymbol.format(numb);
    var rupee = data.split('.');
    return rupee[0];
  }
  // @override
  // void didChangeDependencies() {

  //   //logConsole("OTP DEP CHANGED :::: +++++");
  //   super.didChangeDependencies();
  // }

  confirmDetail(context, title, content) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: appText(
                  data: title,
                  size: width(context) * 0.04,
                  color: txtSecondaryColor)),
          Expanded(
              child: appText(
                  align: TextAlign.right,
                  data: content,
                  size: width(context) * 0.04,
                  color: txtSecondaryDarkColor))
        ],
      ),
    );
  }

  // String? get _errorText {
  //   dynamic amount = txtAmountController.text;

  //   if (amount.isEmpty) {
  //     return 'Can\'t be empty';
  //   } else if (double.parse(amount) <
  //           double.parse(widget.paymentInfo!.mINLIMIT.toString()) ||
  //       double.parse(amount) >
  //           double.parse(widget.paymentInfo!.mAXLIMIT.toString())) {
  //     return 'Payment amount has to between ${widget.paymentInfo!.mINLIMIT} and ${widget.paymentInfo!.mAXLIMIT}';
  //   }
  //   // if (text.isEmpty) {
  //   //   return 'Can\'t be empty';
  //   // }
  //   // if (text.length < 4) {
  //   //   return 'Too short';
  //   // }
  //   return null;
  // }

  getFetchBillDetails() {
    String billAmount = widget.billerResData == null
        ? "0"
        : widget.billerResData!.amount.toString();

    return billAmount;
  }

  String checkIsExact() {
    var isErrorMsg = "";

    var paymentExactness = widget.isSavedBill
        ? widget.savedBillerData!.pAYMENTEXACTNESS
        : widget.billerData!.pAYMENTEXACTNESS;

    switch (paymentExactness) {
      // If the exactness is Exact then set the error message
      case "Exact":
        if (userAmount != billAmount) {
          isErrorMsg = "Only Exact Payment Amount Accepted";
        }
        break;
      // If the exactness is Exact and below then set the error message
      case "Exact and below":
        if (userAmount > double.parse(billAmount)) {
          isErrorMsg =
              "Payment amount should be less than or equal to the bill amount";
        }
        break;
      // If the exactness is Exact and Above then set the error message
      case "Exact and Above":
        if (userAmount < billAmount) {
          isErrorMsg =
              "Payment amount should be more than or equal to the bill amount";
        }
        break;
      default:
        break;
    }
    return isErrorMsg;
  }

  bool checkIsAmountValid() {
    var isError = false;

    var paymentExactness = widget.isSavedBill
        ? widget.savedBillerData!.pAYMENTEXACTNESS
        : widget.billerData!.pAYMENTEXACTNESS;

    switch (paymentExactness) {
      // If the exactness is Exact then set the error message
      case "Exact":
        if (userAmount != billAmount) {
          isError = true;
        }
        break;
      // If the exactness is Exact and below then set the error message
      case "Exact and below":
        if (userAmount > double.parse(billAmount)) {
          isError = true;
        }
        break;
      // If the exactness is Exact and Above then set the error message
      case "Exact and Above":
        if (userAmount < billAmount) {
          isError = true;
        }
        break;
      default:
        break;
    }
    return isError;
  }

  String capitalizeFirstWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  List<AccountsData>? accountInfo = [];
  ValidateBillResponseData? validateBillResponseData;
  String _isErrorMsg = "";

  getAutopayStatus(customerBillID) {
    List<AllConfigurationsData>? AutoData = [];
    List<UpcomingPaymentsData>? UpcomingData = [];

    for (int i = 0; i < widget.allAutopayData!.length; i++) {
      for (int j = 0; j < widget.allAutopayData![i].data!.length; j++) {
        AutoData.add(widget.allAutopayData![i].data![j]);
      }
    }

    for (int i = 0; i < widget.allAutopayUpcomingData!.length; i++) {
      UpcomingData.add(widget.allAutopayUpcomingData![i]);
    }

    List<AllConfigurationsData>? data =
        AutoData.where((item) => item.cUSTOMERBILLID == customerBillID)
            .toList();

    List<UpcomingPaymentsData>? Updata =
        UpcomingData.where((item) => item.cUSTOMERBILLID == customerBillID)
            .toList();

    return (data.isNotEmpty || Updata.isNotEmpty ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    void hideDialog() {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return BlocConsumer<billFlowCubit, billFlowState>(
        listener: (context, state) {
      if (state is ConfirmFetchBillLoading) {
      } else if (state is ConfirmFetchBillSuccess) {
        if (Loader.isShown) {
          Loader.hide();
        }
        // final res = state.fetchBillResponse!.data?.data?.billerResponse;
        confirmbillerResData = state.ConfirmFetchBillResponse;

        if (widget.isSavedBill) {
          _otherAmount =
              !(!widget.savedBillerData!.pAYMENTEXACTNESS!.isNotEmpty ||
                  widget.savedBillerData!.pAYMENTEXACTNESS == "Exact" ||
                  userAmount == billAmount);
        } else {
          _otherAmount = !(!widget.billerData!.pAYMENTEXACTNESS!.isNotEmpty ||
              widget.billerData!.pAYMENTEXACTNESS == "Exact" ||
              userAmount == billAmount);
        }
        if (widget.isSavedBill) {
          logConsole(jsonEncode(widget.savedInputSignatures).toString(),
              "widget.savedInputSignatures ::");
        }

        inspect(widget.savedInputSignatures);
        inspect(widget.savedBillerData);

        // _additionalInfo = state.fetchBillResponse!.data!.data!.additionalInfo;
        goToData(context, otpRoute, {
          "from": confirmPaymentRoute,
          "templateName": "confirm-payment",
          "data": {
            "billerID": widget.isSavedBill
                ? widget.savedBillerData!.bILLERID
                : widget.billerData!.bILLERID,
            "billerName": widget.isSavedBill
                ? widget.savedBillerData!.bILLERNAME
                : widget.billerData!.bILLERNAME,
            "billName": widget.isSavedBill
                ? widget.savedBillerData!.bILLNAME
                : widget.billName,
            "acNo": widget.accInfo![selectedAccount].accountNumber,
            "billAmount": userAmount.toString(),
            "customerBillID": widget.isSavedBill
                ? widget.savedBillerData!.cUSTOMERBILLID
                : widget.newCustomerBillId,
            "tnxRefKey": confirmbillerResData!.txnRefKey,
            "quickPay": widget.validate_bill!["quickPay"],
            "inputSignature": widget.isSavedBill
                ? widget.savedInputSignatures
                : widget.inputParameters,
            "otherAmount": _otherAmount,
            "autoPayStatus": getAutopayStatus(widget.isSavedBill
                ? widget.savedBillerData!.cUSTOMERBILLID
                : widget.newCustomerBillId),
            "billerData":
                widget.isSavedBill ? widget.savedBillerData : widget.billerData
          }
        });
        // billAmount = int.parse(state
        //     .fetchBillResponse!.data!.data!.billerResponse!.amount
        //     .toString());
      } else if (state is ConfirmFetchBillFailed) {
      } else if (state is ConfirmFetchBillError) {
        if (Loader.isShown) {
          Loader.hide();
        }
        goToUntil(context, splashRoute);
      } else if (state is ValidateBillLoading) {
        showLoader(context);
      } else if (state is PrepaidValidateBillSuccess) {
        Loader.hide();
        inspect(widget.billerData);
        inspect(widget.savedBillerData);

        isSavedBillFrom = widget.billerData != null ? false : true;
        isMobilePrepaidFrom = true;

        logConsole(jsonEncode(widget.savedInputSignatures).toString(),
            "widget.savedInputSignatures :::");
        logConsole(state.transactionReferenceKey.toString(),
            "transactionReferenceKey:::");
        logConsole(jsonEncode(widget.newAddbillerParams).toString(),
            "widget.inputParameters ::::");
        goToData(context, otpRoute, {
          "from": confirmPaymentRoute,
          "templateName": "confirm-payment",
          "data": {
            "isMobilePrepaid": true,
            "billerID": widget.isSavedBill
                ? widget.savedBillerData!.bILLERID
                : widget.billerData!.bILLERID,
            "billerName": widget.isSavedBill
                ? widget.savedBillerData!.bILLERNAME
                : widget.billerData!.bILLERNAME,
            "billName": widget.isSavedBill
                ? widget.savedBillerData!.bILLNAME
                : widget.billName,
            "acNo": widget.accInfo![selectedAccount].accountNumber,
            "billAmount": widget.isMobilePrepaid
                ? widget.selectedPrepaidPlan!.amount.toString()
                : userAmount.toString(),
            "customerBillID":
                widget.isSavedBill ? widget.savedBillerData!.cUSTOMERBILLID : 0,
            "tnxRefKey": state.transactionReferenceKey,
            "quickPay": widget.validate_bill!["quickPay"],
            "transactionReferenceKey": state.transactionReferenceKey,
            // "inputSignature": widget.isSavedBill
            //     ? widget.prepaidParameters
            //     : widget.newAddbillerParams,
            "inputSignature": widget.prepaidParameters,
            "paymentMode": "CASH",
            "paymentChannel": "BNKBRNCH",
            "forChannel": "prepaid",
            "otherAmount": _otherAmount,
            "autoPayStatus": getAutopayStatus(widget.isSavedBill
                ? widget.savedBillerData!.cUSTOMERBILLID
                : widget.newCustomerBillId),
            "billerData":
                widget.isSavedBill ? widget.savedBillerData : widget.billerData
          }
        });
      } else if (state is ValidateBillSuccess) {
        isMobilePrepaidFrom = false;

        validateBillResponseData = state.validateBillResponseData;
        if (widget.isMobilePrepaid == true) {
          Map<String, dynamic> payload = {
            "validateBill": false,
            "billerID": widget.isSavedBill
                ? widget.savedBillerData!.bILLERID
                : widget.billerID,
            "billerParams": widget.billerParams,
            "quickPay": widget.validate_bill!["quickPay"],
            "quickPayAmount": txtAmountController.text,
            "forChannel": "prepaid",
            "adHocBillValidationRefKey": state.bbpsTranlogId,
            "planid": widget.selectedPrepaidPlan!.billerPlanId,
            "supportplan": "MANDATORY",
            "plantype": widget.selectedPrepaidPlan!.planAdditionalInfo!.Type
            // "plantype": "CURATED"
          };
          BlocProvider.of<billFlowCubit>(context).prepaidValidateBill(payload);
        } else {
          BlocProvider.of<billFlowCubit>(context).confirmFetchBill(
              validateBill: false,
              billerID: widget.isSavedBill
                  ? widget.savedBillerData!.bILLERID
                  : widget.billerID,
              billerParams: widget.billerParams,
              quickPay: widget.validate_bill!["quickPay"],
              quickPayAmount: userAmount.toString(),
              adHocBillValidationRefKey:
                  validateBillResponseData?.data!.bbpsTranlogId,
              billName: widget.isSavedBill ? null : widget!.billName);
        }
      } else if (state is ValidateBillFailed) {
        isMobilePrepaidFrom = false;

        Loader.hide();
        customDialog(
            title: "Error!",
            //  message: state.message!.isNotEmpty
            //   ? state.message.toString()
            //   : "Unable to validate the Bill at the moment . Please try again.",
            message:
                "Unable to validate the Bill at the moment . Please try again.",
            message2: "",
            message3: "",
            buttonName: "Okay",
            dialogHeight: height(context) / 2.6,
            buttonAction: () {
              hideDialog();

              goBack(context);
              goBack(context);
            },
            context: context,
            iconSvg: alertSvg);
      } else if (state is ValidateBillError) {
        isMobilePrepaidFrom = false;

        Loader.hide();

        goToUntil(context, splashRoute);
      } else if (state is AccountInfoLoading) {
        widget.isAccLoading = true;
      } else if (state is AccountInfoSuccess) {
        widget.isAccLoading = false;
        accountInfo = state.accountInfo;

        if (Loader.isShown) {
          Loader.hide();
        }
      } else if (state is AccountInfoFailed) {
        widget.isAccLoading = false;
      } else if (state is AccountInfoError) {
        widget.isAccLoading = false;
        goToUntil(context, splashRoute);
      }
    }, builder: (context, state) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(2),
        child: Column(
          children: [
            Container(
              // height: widget.isMobilePrepaid
              //     ? widget.selectedPrepaidPlan?.planAdditionalInfo!
              //                 .additionalBenefits !=
              //             null
              //         ? height(context) * 0.38
              //         : height(context) * 0.24
              //     : height(context) * 0.27,
              // height: height(context) * 0.27,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: txtColor,
              ),
              margin: EdgeInsets.all(width(context) * 0.044),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: 6)),
                  if (!widget.isMobilePrepaid)
                    ListTile(
                      dense: true,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      leading: Image.asset(
                        bNeumonic,
                        height: height(context) * 0.07,
                      ),
                      title: appText(
                          data: widget.billName.toString(),
                          size: width(context) * 0.04,
                          color: txtSecondaryColor,
                          weight: FontWeight.w400),
                    ),
                  if (widget.isMobilePrepaid)
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            dense: true,
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            leading: Image.asset(
                              bNeumonic,
                              height: height(context) * 0.07,
                            ),
                            title: appText(
                                data: rupeeCov(
                                    widget.selectedPrepaidPlan?.amount),
                                size: width(context) * 0.04,
                                color: txtPrimaryColor,
                                weight: FontWeight.w600),
                            subtitle: appText(
                                data:
                                    "Validity:${widget.selectedPrepaidPlan?.planAdditionalInfo?.validity}",
                                size: width(context) * 0.03,
                                color: txtCheckBalanceColor,
                                weight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, bottom: 15),
                          child: Container(
                            height: height(context) * 0.030,
                            width: width(context) * 0.29,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size(width(context) * 0.30, 40.0),
                                  backgroundColor: primaryColor),
                              child: Text(
                                "Change Plan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.4,
                                  color: Colors.white,
                                  fontSize: width(context) * 0.03,
                                  fontFamily: appFont,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onPressed: () => goBack(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!widget.isMobilePrepaid)
                    Divider(
                      thickness: 1,
                      indent: 16.0,
                      endIndent: 16.0,
                      color: divideColor,
                    ),
                  if (widget.isMobilePrepaid)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0, bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: appText(
                              data: widget.selectedPrepaidPlan?.planDesc,
                              size: width(context) * 0.031,
                              color: txtSecondaryColor,
                              maxline: 5,
                              weight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  if (widget.isMobilePrepaid &&
                      widget.selectedPrepaidPlan?.planAdditionalInfo!
                              .additionalBenefits !=
                          null)
                    /* Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: appText(
                        data: 'Additional Benefits:',
                        size: width(context) * 0.035,
                        color: txtPrimaryColor,
                        weight: FontWeight.w600,
                      ),
                    ), */
                    if (widget.isMobilePrepaid &&
                        widget.selectedPrepaidPlan?.planAdditionalInfo!
                                .additionalBenefits !=
                            null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                dense: true,
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                                title: appText(
                                  data: 'Additional Benefits:',
                                  size: width(context) * 0.035,
                                  color: txtPrimaryColor,
                                  weight: FontWeight.w600,
                                ),
                                subtitle: appText(
                                  data: widget.selectedPrepaidPlan
                                      ?.planAdditionalInfo!.additionalBenefits,
                                  size: width(context) * 0.035,
                                  color: txtSecondaryColor,
                                  maxline: 3,
                                  weight: FontWeight.w400,
                                ),
                              ), /* appText(
                              data: widget.selectedPrepaidPlan
                                  ?.planAdditionalInfo!.additionalBenefits,
                              size: width(context) * 0.035,
                              color: txtSecondaryColor,
                              maxline: 5,
                              weight: FontWeight.w400,
                            ), */
                            )
                          ],
                        ),
                      ),
                  if (widget.isMobilePrepaid)
                    Divider(
                      thickness: 1,
                      indent: 16.0,
                      endIndent: 16.0,
                      color: divideColor,
                    ),
                  if (!widget.isMobilePrepaid)
                    confirmDetail(context, "Bill Name",
                        capitalizeFirstWord(widget.billName.toString())),
                  if (widget.isMobilePrepaid)
                    confirmDetail(context, "Circle",
                        capitalizeFirstWord(widget.selectedCircle.toString())),
                  if (!widget.isMobilePrepaid)
                    Divider(
                      thickness: 1,
                      indent: 16.0,
                      endIndent: 16.0,
                      color: divideColor,
                    ),
                  if (!widget.isMobilePrepaid)
                    confirmDetail(
                        context, "Provider", widget.billerName.toString()),
                  if (widget.isMobilePrepaid)
                    confirmDetail(
                        context,
                        "Biller Name",
                        capitalizeFirstWord(widget.isSavedBill
                            ? widget.billerName!.toString()
                            : widget.billerData!.bILLERNAME.toString())),
                  if (!widget.isMobilePrepaid &&
                      (!(widget.savedBillerData == null ||
                          widget.savedBillerData!.pARAMETERS == null ||
                          (widget.savedBillerData!.pARAMETERS!.isEmpty))))
                    Divider(
                      thickness: 1,
                      indent: 16.0,
                      endIndent: 16.0,
                      color: divideColor,
                    ),
                  if (!widget.isMobilePrepaid &&
                      (!(widget.savedBillerData == null ||
                          widget.savedBillerData!.pARAMETERS == null ||
                          (widget.savedBillerData!.pARAMETERS!.isEmpty))))
                    confirmDetail(
                      context,
                      widget
                          .savedBillerData!
                          .pARAMETERS![
                              widget.savedBillerData!.pARAMETERS!.length - 1]
                          .pARAMETERNAME
                          .toString(),
                      widget
                          .savedBillerData!
                          .pARAMETERS![
                              widget.savedBillerData!.pARAMETERS!.length - 1]
                          .pARAMETERVALUE
                          .toString(),
                    ),
                ],
              ),
            ),
            if (widget.isMobilePrepaid == false)
              Container(
                // height: height(context) * 0.62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: txtColor,
                ),
                margin: EdgeInsets.only(
                    left: width(context) * 0.044,
                    right: width(context) * 0.044,
                    bottom: width(context) * 0.044),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.billerResData != null)
                      Padding(
                        padding: EdgeInsets.all(width(context) * 0.044),
                        child: appText(
                            data: 'Bill Details',
                            size: width(context) * 0.04,
                            color: txtPrimaryColor,
                            maxline: 1,
                            weight: FontWeight.w600),
                      ),

                    if (widget.billerResData != null &&
                        widget.billerResData!.dueDate != null)
                      confirmDetail(context, "Due Date",
                          widget.billerResData!.dueDate.toString()),

                    if (widget.billerResData != null &&
                        widget.billerResData!.dueDate != null)
                      Divider(
                        thickness: 1,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: divideColor,
                      ),

                    if (widget.billerResData != null &&
                        widget.billerResData!.billDate != null)
                      confirmDetail(context, "Bill Date",
                          widget.billerResData!.billDate.toString()),

                    if (widget.billerResData != null &&
                        widget.billerResData!.billDate != null)
                      Divider(
                        thickness: 1,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: divideColor,
                      ),

                    if (widget.billerResData != null &&
                        widget.billerResData!.billNumber != null)
                      confirmDetail(context, "Bill Number",
                          widget.billerResData!.billNumber.toString()),

                    if (widget.billerResData != null &&
                        widget.billerResData!.billNumber != null)
                      Divider(
                        thickness: 1,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: divideColor,
                      ),
                    if (widget.billerResData != null)
                      confirmDetail(context, "Customer Name",
                          widget.billerResData!.customerName.toString()),
                    if (widget.billerResData != null)
                      Divider(
                        thickness: 1,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: divideColor,
                      ),

                    if (widget.billerResData != null &&
                        widget.billerResData!.billPeriod != null)
                      confirmDetail(context, "Bill Period",
                          widget.billerResData!.billPeriod.toString()),
                    // if ((!(widget.additionalInfo == null ||
                    //     widget.additionalInfo!.tag!.isEmpty)))
                    //   ListView.builder(
                    //       itemCount: widget.additionalInfo!.tag!.length,
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemBuilder: (context, index) => Column(
                    //             children: [
                    //               confirmDetail(
                    //                   context,
                    //                   widget.additionalInfo!.tag![index].name
                    //                       .toString(),
                    //                   widget.additionalInfo!.tag![index].value
                    //                       .toString()),
                    //               Divider(
                    //                 thickness: 1,
                    //                 indent: 16.0,
                    //                 endIndent: 16.0,
                    //                 color: divideColor,
                    //               )
                    //             ],
                    //           )),
                    // Divider(
                    //   thickness: 1,
                    //   indent: 16.0,
                    //   endIndent: 16.0,
                    //   color: divideColor,
                    // ),

                    // if (widget.billerResData!.tag!.isNotEmpty)
                    //   confirmDetail(
                    //     context,
                    //     widget.billerResData!.tag![0].name,
                    //     widget.billerResData!.tag![0].value,
                    //   ),
                    if (widget.billerResData != null &&
                        widget.billerResData!.billPeriod != null)
                      Divider(
                        thickness: 1,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: divideColor,
                      ),
                    // confirmDetail(
                    //   context,
                    //   widget.billerResData!.tag![1].name.toString(),
                    //   widget.billerResData!.tag![1].value.toString(),
                    // ),
                    // Divider(
                    //   thickness: 1,
                    //   indent: 16.0,
                    //   endIndent: 16.0,
                    //   color: divideColor,
                    // ),
                    // confirmDetail(
                    //     context,
                    //     widget.billerResData!.tag![2].name.toString(),
                    //     widget.billerResData!.tag![2].value.toString()),

                    if ((!(widget.billerResData == null ||
                        widget.billerResData!.tag!.isEmpty)))
                      ListView.builder(
                          itemCount: widget.billerResData!.tag!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Column(
                                children: [
                                  confirmDetail(
                                      context,
                                      widget.billerResData!.tag![index].name
                                          .toString(),
                                      widget.billerResData!.tag![index].value
                                          .toString()),
                                  Divider(
                                    thickness: 1,
                                    indent: 16.0,
                                    endIndent: 16.0,
                                    color: divideColor,
                                  )
                                ],
                              )),

                    Padding(padding: EdgeInsets.all(8)),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        bbpsAssuredLogo,
                        height: height(context) * 0.07,
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: appText(
                          data:
                              'All billing details are verified by Bharat Billpay',
                          size: width(context) * 0.03,
                          color: txtSecondaryColor,
                          maxline: 1,
                        ))
                  ],
                ),
              ),
            if (widget.isMobilePrepaid == false)
              Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: txtColor,
                ),
                margin: EdgeInsets.only(
                    left: width(context) * 0.044,
                    right: width(context) * 0.044,
                    bottom: width(context) * 0.044),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((!(widget.additionalInfo == null ||
                        widget.additionalInfo!.tag!.isEmpty)))
                      Padding(
                        padding: EdgeInsets.all(width(context) * 0.044),
                        child: appText(
                            data: 'Additional Info',
                            size: width(context) * 0.04,
                            color: txtPrimaryColor,
                            maxline: 1,
                            weight: FontWeight.w600),
                      ),
                    if ((!(widget.additionalInfo == null ||
                        widget.additionalInfo!.tag!.isEmpty)))
                      ListView.builder(
                          itemCount: widget.additionalInfo!.tag!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Column(
                                children: [
                                  confirmDetail(
                                      context,
                                      widget.additionalInfo!.tag![index].name
                                          .toString(),
                                      widget.additionalInfo!.tag![index].value
                                          .toString()),
                                  Divider(
                                    thickness: 1,
                                    indent: 16.0,
                                    endIndent: 16.0,
                                    color: divideColor,
                                  )
                                ],
                              )),
                    Container(
                      margin: EdgeInsets.only(
                          left: width(context) * 0.044,
                          top: width(context) * 0.044,
                          right: width(context) * 0.044),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appText(
                            data: "Outstanding Amount",
                            size: width(context) * 0.04,
                            weight: FontWeight.w500,
                            color: txtPrimaryColor,
                          ),
                          verticalSpacer(10.0),
                          TextFormField(
                            controller: txtAmountController,
                            enabled: widget.validate_bill!["amountEditable"],
                            onChanged: (val) {
                              // debugPrint(val);
                              _isErrorMsg = "";
                              if (txtAmountController.text.isEmpty) {
                                setState(() {
                                  isAmountEmpty = true;
                                });
                              } else {
                                setState(() {
                                  isAmountEmpty = false;
                                  userAmount = double.parse(val.toString());
                                });
                              }
                              logConsole(selectedAccount.toString(),
                                  "selectedAccount :: ");
                              if (selectedAccount != 9999 &&
                                  txtAmountController.text.isNotEmpty) {
                                if (double.parse(widget
                                            .accInfo![selectedAccount].balance
                                            .toString()) <
                                        double.parse(
                                            txtAmountController.text) ||
                                    double.parse(txtAmountController.text) <
                                        double.parse(widget
                                            .paymentInfo!.mINLIMIT
                                            .toString()) ||
                                    double.parse(txtAmountController.text) >
                                        double.parse(widget
                                            .paymentInfo!.mAXLIMIT
                                            .toString())) {
                                  setState(() {
                                    isInsufficient = true;
                                  });
                                } else {
                                  setState(() {
                                    isInsufficient = false;
                                  });
                                }
                              }
                            },
                            onFieldSubmitted: (_) {},
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            autocorrect: false,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              // errorText: _errorText,
                              filled: true,
                              fillColor: widget.validate_bill!["amountEditable"]
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryBodyColor, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: divideColor, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryBodyColor, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: primaryBodyColor, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              hintText: "Amount",
                              hintStyle: TextStyle(color: txtHintColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    if (txtAmountController.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          left: width(context) * 0.044,
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: appText(
                              data:
                                  'Payment Amount has to be between ₹ ${widget.paymentInfo?.mINLIMIT.toString()} and ₹ ${widget.paymentInfo?.mAXLIMIT.toString()}',
                              size: width(context) * 0.03,
                              color: double.parse(txtAmountController.text) <
                                          double.parse(
                                              widget.paymentInfo != null
                                                  ? widget.paymentInfo!.mINLIMIT
                                                      .toString()
                                                  : "0") ||
                                      double.parse(txtAmountController.text) >
                                          double.parse(
                                              widget.paymentInfo != null
                                                  ? widget.paymentInfo!.mAXLIMIT
                                                      .toString()
                                                  : "0")
                                  ? Colors.red
                                  : txtSecondaryColor,
                              maxline: 2,
                            )),
                      ),
                    if (txtAmountController.text.isEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: appText(
                          data: '     Please enter the amount',
                          size: width(context) * 0.03,
                          color: Colors.red,
                          maxline: 1,
                        ),
                      ),
                    Padding(padding: EdgeInsets.only(bottom: 12)),
                  ],
                ),
              ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: double.infinity,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: txtColor,
              ),
              margin: EdgeInsets.only(
                  left: width(context) * 0.044,
                  right: width(context) * 0.044,
                  bottom: width(context) * 0.044),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: width(context) * 0.008,
                      left: width(context) * 0.044,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          appText(
                              data: 'Debit From',
                              size: width(context) * 0.04,
                              color: txtPrimaryColor,
                              maxline: 1,
                              weight: FontWeight.w600),
                          IconButton(
                              splashRadius: 20,
                              onPressed: () async {
                                // if (!Loader.isShown) {
                                //   showLoader(context);
                                // }
                                if (await isConnected()) {
                                  BlocProvider.of<billFlowCubit>(context)
                                      .getAccountInfo(myAccounts);
                                } else {
                                  showSnackBar(noInternetMessage, context);
                                }
                              },
                              icon: const Icon(
                                Icons.refresh,
                              )),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: widget.isAccLoading == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.4),
                            child: Center(
                              child: appText(
                                  data:
                                      "Please wait fetching account information ...",
                                  size: width(context) * 0.035,
                                  weight: FontWeight.w100,
                                  color: txtPrimaryColor),
                            ),
                          )
                        : Column(
                            children: [
                              if (myAccounts!.length > 0)
                                for (int i = 0; i < widget.accInfo!.length; i++)
                                  Material(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          disabledColor: shadowColor,
                                          backgroundColor: txtColor),
                                      child: RadioListTile(
                                        activeColor: txtCheckBalanceColor,
                                        value: i,
                                        groupValue: selectedAccount,
                                        onChanged: (widget
                                                    .accInfo![i].balance !=
                                                "Unable to fetch balance")
                                            ? isAmountEmpty == true
                                                ? null
                                                : (value) {
                                                    setState(() =>
                                                        selectedAccount = i);

                                                    if (double.parse(widget
                                                            .accInfo![
                                                                selectedAccount]
                                                            .balance
                                                            .toString()) <
                                                        double.parse(
                                                            txtAmountController
                                                                .text)) {
                                                      setState(() {
                                                        isInsufficient = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isInsufficient = false;
                                                      });
                                                    }
                                                  }
                                            : (widget.accInfo![i].balance ==
                                                    "Unable to fetch balance")
                                                ? null
                                                : double.parse(widget
                                                            .accInfo![i].balance
                                                            .toString()) >
                                                        double.parse(
                                                            txtAmountController
                                                                .text)
                                                    ? null
                                                    : null,
                                        visualDensity: widget
                                                        .accInfo![i].balance ==
                                                    "Unable to fetch balance" ||
                                                txtAmountController.text.isEmpty
                                            ? VisualDensity.compact
                                            : VisualDensity.standard,
                                        title: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            appText(
                                                data: widget
                                                    .accInfo![i].accountNumber
                                                    .toString(),
                                                size: width(context) * 0.035,
                                                weight: FontWeight.w100,
                                                color: txtPrimaryColor),
                                            widget.accInfo![i].balance ==
                                                    "Unable to fetch balance"
                                                ? appText(
                                                    data:
                                                        "Unable to fetch balance",
                                                    size: width(context) * 0.03,
                                                    color: alertFailedColor)
                                                : appText(
                                                    data:
                                                        "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.accInfo![i].balance.toString()))}",
                                                    size: width(context) * 0.04,
                                                    color: txtPrimaryColor)
                                          ],
                                        ),
                                        subtitle: widget.accInfo![i].balance !=
                                                    "Unable to fetch balance" &&
                                                txtAmountController
                                                    .text.isNotEmpty
                                            ? double.parse(widget
                                                        .accInfo![i].balance
                                                        .toString()) <
                                                    double.parse(
                                                        txtAmountController
                                                            .text)
                                                ? appText(
                                                    data:
                                                        "Insufficient balance in the account",
                                                    size:
                                                        width(context) * 0.025,
                                                    color: alertFailedColor)
                                                : null
                                            : null,
                                      ),
                                    ),
                                  ),
                              if (myAccounts!.length == 0)
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width(context) * 0.048,
                                      right: width(context) * 0.044,
                                      top: 0,
                                      bottom: width(context) * 0.044),
                                  child: appText(
                                      data: "No Account available",
                                      size: width(context) * 0.04,
                                      color: alertFailedColor),
                                ),
                              if (errorMsg != null && selectedAccount == 9999)
                                appText(
                                  data: errorMsg,
                                  size: width(context) * 0.03,
                                  color: Colors.red,
                                ),
                              if (selectedAccount != 9999)
                                if (txtAmountController.text.isNotEmpty)
                                  if (double.parse(widget
                                          .accInfo![selectedAccount].balance
                                          .toString()) <
                                      double.parse(txtAmountController.text))
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.07),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: appText(
                                          data:
                                              'Insufficient balance in the account',
                                          size: width(context) * 0.03,
                                          color: Colors.red,
                                          maxline: 1,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                  ),
                  if (_isErrorMsg.length > 0)
                    Padding(
                        padding: EdgeInsets.only(
                            left: width(context) * 0.044,
                            top: height(context) * 0.024),
                        child: Align(
                            alignment: Alignment.center,
                            child: appText(
                                data: _isErrorMsg,
                                textAlign: TextAlign.center,
                                size: width(context) * 0.03,
                                color: alertFailedColor))),
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: primaryBodyColor,
                    ),
                    margin: EdgeInsets.all(width(context) * 0.044),
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: width(context) * 0.016,
                                left: width(context) * 0.020,
                                bottom: width(context) * 0.012),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    color: txtSecondaryColor),
                                appText(
                                    data: "  Message from Biller",
                                    size: width(context) * 0.035,
                                    weight: FontWeight.w800,
                                    color: txtPrimaryColor),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: width(context) * 0.064,
                              right: width(context) * 0.08,
                              top: width(context) * 0.009,
                              bottom: width(context) * 0.040),
                          child: appText(
                              data:
                                  "It might take upto 72 hours to complete this transaction based on the biller bank availability in case of any network or technical failure.",
                              size: width(context) * 0.032,
                              color: txtSecondaryColor,
                              maxline: 5,
                              weight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: width(context) * 0.048,
                        right: width(context) * 0.044,
                        top: 0,
                        bottom: width(context) * 0.044),
                    child: InkWell(
                      onTap: () => showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                actions: [
                                  myAppButton(
                                    context: context,
                                    buttonName: "Done",
                                    margin: const EdgeInsets.only(
                                      right: 40,
                                      left: 40,
                                      top: 0,
                                    ),
                                    onpress: () => goBack(context),
                                  )
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                                content: SingleChildScrollView(
                                  padding:
                                      EdgeInsets.all(width(context) * 0.024),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      HtmlWidget(widget
                                          .settingInfo!.tERMSANDCONDITIONS
                                          .toString()),
                                    ],
                                  ),
                                ));
                          }),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: appFont,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: tcTextContent),
                            TextSpan(
                              text: tcText,
                              style: TextStyle(
                                fontFamily: appFont,
                                color: txtAmountColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 8),
                    // margin:
                    //     EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    width: width(context) / 2.5,
                    height: height(context) / 14,
                    child: TextButton(
                      onPressed: () => goBack(context),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: txtPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: appText(
                          data: "Cancel",
                          size: width(context) * 0.04,
                          weight: FontWeight.bold,
                          color: txtPrimaryColor),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 16),
                    // margin:
                    //     EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    width: width(context) / 2.5,
                    height: height(context) / 14,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAccount == 9999 ||
                                isInsufficient == true ||
                                isAmountEmpty == true
                            ? disableColor
                            : primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: selectedAccount == 9999 ||
                              isInsufficient == true ||
                              txtAmountController.text.isNotEmpty &&
                                  (double.parse(widget
                                              .accInfo![selectedAccount].balance
                                              .toString()) <
                                          double.parse(
                                              txtAmountController.text) ||
                                      double.parse(txtAmountController.text) <
                                          double.parse(widget
                                              .paymentInfo!.mINLIMIT
                                              .toString()) ||
                                      double.parse(txtAmountController.text) >
                                          double.parse(widget
                                              .paymentInfo!.mAXLIMIT
                                              .toString()) ||
                                      txtAmountController.text.isEmpty ||
                                      double.parse(txtAmountController.text
                                              .toString()) ==
                                          0)
                          ? null
                          : () {
                              inspect(widget.savedBillerData);
                              final dailyLimit =
                                  double.parse(widget.dailyLimit.toString());
                              final bankLimit = double.parse(
                                  widget.settingInfo!.dAILYLIMIT.toString());

                              bool _response = false;
                              String _errResponse = "";

                              if (widget.validate_bill!["amountEditable"] &&
                                  widget.validate_bill!["billerType"] ==
                                      "billFetch") {
                                _response = checkIsAmountValid();
                                _errResponse = checkIsExact();
                              }

                              if (_errResponse.toString().length > 0) {
                                setState(() {
                                  _isErrorMsg = _errResponse;
                                });
                              }

                              if (!_response) {
                                debugPrint(
                                    "limits ${widget.dailyLimit} $userAmount ${widget.settingInfo!.dAILYLIMIT}");
                                if (txtAmountController.text.isEmpty) {
                                  showSnackBar(
                                      "Enter a valid payment amount", context);
                                } else if (double.parse(widget
                                        .accInfo![selectedAccount].balance
                                        .toString()) <
                                    userAmount) {
                                  showSnackBar(
                                      "Insufficient balance for making a payment.",
                                      context);
                                } else if (userAmount >
                                    (bankLimit - dailyLimit)) {
                                  showSnackBar(
                                      "Payment limit exceeded for paying bills in a day.",
                                      context);
                                } else {
                                  if (!Loader.isShown) {
                                    showLoader(context);
                                  }
                                  logConsole(widget.validate_bill.toString(),
                                      "widget.validate_bill");

                                  //CHANGE HERE
                                  if (widget.isMobilePrepaid == true) {
                                    if (widget.isSavedBill) {
                                      Map<String, dynamic> payload = {
                                        "validateBill": true,
                                        "billerID": widget.isSavedBill
                                            ? widget.savedBillerData!.bILLERID
                                            : widget.billerID,
                                        "billerParams": widget.billerParams,
                                        "quickPay":
                                            widget.validate_bill!["quickPay"],
                                        "quickPayAmount":
                                            txtAmountController.text,
                                        "forChannel": "prepaid"
                                      };
                                      BlocProvider.of<billFlowCubit>(context)
                                          .fetchValidateBill(payload);
                                    } else {
                                      Map<String, dynamic> payload = {
                                        "validateBill": true,
                                        "billerID": widget.isSavedBill
                                            ? widget.savedBillerData!.bILLERID
                                            : widget.billerID,
                                        // "billerParams":
                                        //     widget.newAddbillerParams,
                                        // "billerParams": widget.inputParameters,
                                        "billerParams": widget.billerParams,
                                        "quickPay":
                                            widget.validate_bill!["quickPay"],
                                        "quickPayAmount":
                                            txtAmountController.text,
                                        "forChannel": "prepaid"
                                      };
                                      BlocProvider.of<billFlowCubit>(context)
                                          .fetchValidateBill(payload);
                                    }
                                  } else if (widget
                                      .validate_bill!["validateBill"]) {
                                    var billDetail = {};
                                    billDetail["validateBill"] =
                                        widget.validate_bill!["validateBill"];
                                    billDetail["billerID"] =
                                        widget.savedBillerData!.bILLERID;
                                    billDetail["billerParams"] =
                                        widget.billerParams;
                                    billDetail["quickPay"] =
                                        widget.validate_bill!["quickPay"];
                                    billDetail["quickPayAmount"] = userAmount;
                                    billDetail["billName"] = widget.billName;
                                    logConsole(
                                        jsonEncode(billDetail), "billDetail=>");
                                    logInfo(
                                        "if widget.validate_bill!['validateBill'] is true :::");

                                    Map<String, dynamic> payload = {
                                      "validateBill":
                                          widget.validate_bill!["validateBill"],
                                      "billerID": widget.isSavedBill
                                          ? widget.savedBillerData!.bILLERID
                                          : widget.billerID,
                                      "billerParams": widget.billerParams,
                                      "quickPay":
                                          widget.validate_bill!["quickPay"],
                                      "quickPayAmount": userAmount.toString(),
                                      "billName": widget.billName,
                                    };
                                    BlocProvider.of<billFlowCubit>(context)
                                        .fetchValidateBill(payload);
                                    /*

                                    BlocProvider.of<billFlowCubit>(context)
                                        .confirmFetchBill(
                                            billerID: widget.isSavedBill
                                                ? widget
                                                    .savedBillerData!.bILLERID
                                                : widget.billerID,
                                            quickPay: widget.isSavedBill,
                                            quickPayAmount:
                                                userAmount.toString(),
                                            adHocBillValidationRefKey: "",
                                            validateBill: false,
                                            billerParams: widget.billerParams);

                                            */
                                  } else if (widget
                                              .validate_bill!["billerType"] ==
                                          "instant" ||
                                      widget.validate_bill!["billerType"] ==
                                          "adhoc" ||
                                      widget.validate_bill!["billerType"] ==
                                          "billFetch") {
                                    _amountForAdhocBill = true;
                                    if (!Loader.isShown) {
                                      showLoader(context);
                                    }
                                    BlocProvider.of<billFlowCubit>(context)
                                        .confirmFetchBill(
                                      billerID: widget.isSavedBill
                                          ? widget.savedBillerData!.bILLERID
                                          : widget.billerID,
                                      quickPay:
                                          widget.validate_bill!["quickPay"],
                                      quickPayAmount: userAmount.toString(),
                                      adHocBillValidationRefKey: "",
                                      validateBill:
                                          widget.validate_bill!["validateBill"],
                                      billerParams: widget.billerParams,
                                      billName: widget.isSavedBill
                                          ? null
                                          : widget.billName,
                                    );
                                  }
                                }
                              }
                            },
                      child: appText(
                          data: "Make Payment",
                          size: width(context) * 0.04,
                          weight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
