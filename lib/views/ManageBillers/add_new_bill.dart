import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/add_bill_payload_model.dart';
import 'package:bbps/model/saved_billers_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../bloc/home/home_cubit.dart';
import '../../model/bbps_settings_model.dart';
import '../../model/biller_model.dart';
import '../../model/input_signatures_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class AddNewBill extends StatefulWidget {
  BillersData? billerData;
  List<PARAMETERS>? inputSignatureData;

  AddNewBill({Key? key, this.billerData, this.inputSignatureData})
      : super(key: key);

  @override
  _AddNewBillState createState() => _AddNewBillState();
}

class _AddNewBillState extends State<AddNewBill> {
  bool isButtonActive = false;
  bool isValidBillName = false;
  bool isAddtoMybill = false;
  bool isEdit = false;
  List<InputSignaturesData>? inputSignatureItems = [];
  // List<InputSignaturess>? editInputItems = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormFieldState>> _fieldKey = [];
  final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  List<TextEditingController> inputSignatureControllers = [];
  dynamic billNameController = TextEditingController();
  bbpsSettingsData? bbpsSettingInfo;
  String? mobileNumberValue = "";
  String? circleValue = "";

  @override
  void initState() {
    inspect(widget.billerData);

    inspect(widget.inputSignatureData);
    BlocProvider.of<HomeCubit>(context)
        .getInputSingnature(widget.billerData!.bILLERID);

    BlocProvider.of<HomeCubit>(context).getBbpsSettings();
    super.initState();
    if (widget.billerData!.cATEGORYNAME.toString().toLowerCase() ==
        "mobile prepaid") {
      var mobileNumberValue1 = widget.inputSignatureData!
          .firstWhere(
            (param) =>
                param.pARAMETERNAME.toString().toLowerCase() == 'mobile number',
          )
          .pARAMETERVALUE;
      setState(() {
        mobileNumberValue = mobileNumberValue1;
      });
      var circleValue2 = widget.inputSignatureData!
          .firstWhere(
            (param) => param.pARAMETERNAME.toString().toLowerCase() == 'circle',
          )
          .pARAMETERVALUE;
      setState(() {
        circleValue = circleValue2;
      });
    }
    helperFunction();
  }

  Map<String, dynamic>? validateBill;

  helperFunction() {
    setState(() {
      validateBill = getBillerType(
          widget.billerData!.fETCHREQUIREMENT,
          widget.billerData!.bILLERACCEPTSADHOC,
          widget.billerData!.sUPPORTBILLVALIDATION,
          widget.billerData!.pAYMENTEXACTNESS);
    });
  }

  addMobilePrepaid() {
    List<AddbillerpayloadModel> inputPayloadDataPrepaid = [];
    // Map<String, dynamic> inputPayload = {};
    Map<String, dynamic> tempMapPrepaid = new Map();

    List<InputSignaturesData>? tempInputSignatures = inputSignatureItems;
    tempInputSignatures!.forEach((element) {
      if (element.pARAMETERNAME.toString().toLowerCase() == "id") {
        element.pARAMETER_VALUE = billNameController.text;
      }
      if (element.pARAMETERNAME.toString().toLowerCase() == "mobile number") {
        element.pARAMETER_VALUE = mobileNumberValue;
      }
      if (element.pARAMETERNAME.toString().toLowerCase() == "circle") {
        element.pARAMETER_VALUE = circleValue;
      }
    });

    var addbillerPayload = {
      "billerId": widget.billerData!.bILLERID,
      "inputSignatures": inputPayloadDataPrepaid,
      "billName": billNameController.text,
      "confirmPaymentRouteData": tempMapPrepaid
    };
    for (var k = 0; k < tempInputSignatures!.length; k++) {
      AddbillerpayloadModel makeInputPrepaid;
      makeInputPrepaid = AddbillerpayloadModel(
          bILLERID: tempInputSignatures![k].bILLERID,
          pARAMETERID: tempInputSignatures![k].pARAMETERID,
          pARAMETERNAME: tempInputSignatures![k].pARAMETERNAME,
          pARAMETERTYPE: tempInputSignatures![k].pARAMETERTYPE,
          mINLENGTH: tempInputSignatures![k].mINLENGTH,
          mAXLENGTH: tempInputSignatures![k].mAXLENGTH,
          // rEGEX: inputSignatureItems![k].rEGEX,
          rEGEX: null,
          oPTIONAL: tempInputSignatures![k].oPTIONAL,
          eRROR: '',
          pARAMETERVALUE: tempInputSignatures![k].pARAMETER_VALUE);

      inputPayloadDataPrepaid.add(makeInputPrepaid);
    }

    logConsole(
        jsonEncode(tempInputSignatures).toString(), "tempInputSignatures ::::");
    // var addbillerPayload = {
    //   "billerId": widget.billerData!.bILLERID,
    //   "inputSignatures": "",
    //   "billName": billNameController.text,
    //   // "confirmPaymentRouteData": {}
    //   "confirmPaymentRouteData": tempMap
    // };
    goToData(context, otpRoute, {
      "from": fromAddnewBillOtp,
      "templateName": "add-biller-otp",
      "data": addbillerPayload,
    });
  }

  submitForm() {
    Map<String, dynamic> tempMap = new Map();

    List<AddbillerpayloadModel> inputPayloadData = [];
    // Map<String, dynamic> inputPayload = {};
    var addbillerPayload = {
      "billerId": widget.billerData!.bILLERID,
      "inputSignatures": inputPayloadData,
      "billName": billNameController.text,
      "confirmPaymentRouteData": tempMap
    };
    logConsole(inputPayloadData.toString(), "BEFORE inputPayloadData");
    for (var k = 0; k < inputSignatureItems!.length; k++) {
      AddbillerpayloadModel makeInput;
      makeInput = AddbillerpayloadModel(
          bILLERID: inputSignatureItems![k].bILLERID,
          pARAMETERID: inputSignatureItems![k].pARAMETERID,
          pARAMETERNAME: inputSignatureItems![k].pARAMETERNAME,
          pARAMETERTYPE: inputSignatureItems![k].pARAMETERTYPE,
          mINLENGTH: inputSignatureItems![k].mINLENGTH,
          mAXLENGTH: inputSignatureItems![k].mAXLENGTH,
          // rEGEX: inputSignatureItems![k].rEGEX,
          rEGEX: null,
          oPTIONAL: inputSignatureItems![k].oPTIONAL,
          eRROR: '',
          pARAMETERVALUE: inputSignatureControllers[k].text);

      inputPayloadData.add(makeInput);
    }
    logConsole(
        jsonEncode(inputPayloadData).toString(), "AFTER inputPayloadData");
    logConsole(validateBill.toString(), "validateBill:::");
    if (validateBill!['fetchBill']) {
      addbillerPayload = {
        ...addbillerPayload,
        "confirmPaymentRouteData": {
          "name": widget.billerData!.bILLERNAME,
          "billName": billNameController.text,
          "billerData": widget.billerData,
          "inputParameters": inputPayloadData,
          "isSavedBill": true,
          "validateBill": validateBill
        }
      };
    }
    inspect(addbillerPayload);

    // if (isAddtoMybill) {
    //   goToData(context, otpRoute, {
    //     "from": fromAddnewBillOtp,
    //     "templateName": "add-biller-otp",
    //     "data": addbillerPayload,
    //   });
    // } else {
    isSavedBillFrom = false;
    isMobilePrepaidFrom = false;
    goToData(context, confirmPaymentRoute, {
      "name": widget.billerData!.bILLERNAME,
      "billName": billNameController.text,
      "billerData": widget.billerData,
      "inputParameters": inputPayloadData,
      "isSavedBill": false
    });
    // }
  }

  FormValidation(int index, bool _static) {
    setState(() {
      isButtonActive =
          _fieldKey.every((element) => element.currentState!.isValid);
    });

    debugPrint(isButtonActive.toString());
    if (!_static) {
      _fieldKey[index].currentState!.validate();
    } else {
      setState(() {
        isValidBillName = _billnameKey.currentState!.validate();
      });
    }
  }

  void hideDialog() {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar(
          context: context,
          backgroundColor: primaryColor,
          title: "Add Biller",
          bottom: PreferredSize(
            preferredSize: Size(width(context), 8.0),
            child: Container(
              width: width(context),
              color: primaryBodyColor,
            ),
          ),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
          if (state is InputSignatureLoading) {
          } else if (state is InputSignatureSuccess) {
            inputSignatureItems = state.InputSignatureList;
            for (int i = 0; i < inputSignatureItems!.length; i++) {
              _fieldKey.add(GlobalKey<FormFieldState>());
              var textEditingController = TextEditingController(text: "");
              inputSignatureControllers.add(textEditingController);
            }
          } else if (state is InputSignatureFailed) {
            showSnackBar(state.message, context);
          } else if (state is InputSignatureError) {
            goToUntil(context, splashRoute);
          }

          // if (state is EditBillLoading) {
          // } else if (state is EditBillSuccess) {
          //   editInputItems = state.EditBillList?.inputSignaturess;

          //   for (int m = 0; m < editInputItems!.length; m++) {
          //     var textEditingController = TextEditingController(
          //         text: editInputItems![m].pARAMETERVALUE);
          //     billNameController = TextEditingController(
          //         text: state.EditBillList!.billName![0].bILLNAME);
          //     inputSignatureControllers.add(textEditingController);
          //   }
          // } else if (state is EditBillFailed) {
          //   showSnackBar(state.message, context);
          // } else if (state is EditBillError) {
          //   goToUntil(context, splashRoute);
          // }
          if (state is BbpsSettingsLoading) {
          } else if (state is BbpsSettingsSuccess) {
            bbpsSettingInfo = state.BbpsSettingsDetails!.data;
          } else if (state is BbpsSettingsFailed) {
            showSnackBar(state.message, context);
          } else if (state is BbpsSettingsError) {
            goToUntil(context, splashRoute);
          }
          if (state is UpdateBillLoading) {
          } else if (state is UpdateBillSuccess) {
            customDialog(
                context: context,
                message: "Successfully Updated to Registered Billers",
                message2: "",
                message3: "",
                dialogHeight: height(context) / 3,
                iconHeight: height(context) * 0.1,
                title: "Biller Updated",
                buttonName: "Okay",
                buttonAction: () {
                  hideDialog();
                  goToUntil(context, homeRoute);
                },
                iconSvg: iconSuccessSvg);
          } else if (state is UpdateBillFailed) {
            showSnackBar(state.message, context);
          } else if (state is UpdateBillError) {
            goToUntil(context, splashRoute);
          }
        }, builder: (context, state) {
          return ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: width(context),
                    margin: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.03,
                        vertical: width(context) * 0.02),
                    decoration: BoxDecoration(
                      color: txtColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2F535353),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: width(context) * 0.02,
                      horizontal: width(context) * 0.03,
                    ),
                    child: Row(children: [
                      Image.asset(
                        bNeumonic,
                        height: height(context) * 0.07,
                      ),
                      horizondalSpacer(width(context) * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: width(context) / 1.4,
                              child: appText(
                                  data:
                                      widget.billerData!.bILLERNAME.toString(),
                                  size: width(context) * 0.037,
                                  weight: FontWeight.bold,
                                  maxline: 2,
                                  color: primaryColor)),
                          verticalSpacer(width(context) * 0.01),
                          appText(
                              data: widget.billerData!.bILLERCOVERAGE,
                              size: width(context) * 0.04,
                              color: primaryColor)
                        ],
                      )
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.03,
                        vertical: width(context) * 0.02),
                    decoration: BoxDecoration(
                      color: txtColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2F535353),
                          blurRadius: 6.0,
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: width(context) * 0.016,
                      horizontal: width(context) * 0.056,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: width(context) * 0.016,
                        bottom: width(context) * 0.044,
                      ),
                      child: inputSignatureItems!.isNotEmpty
                          ? Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if ((widget.billerData?.cATEGORYNAME
                                          .toString()
                                          .toLowerCase() ==
                                      "mobile prepaid"))
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: width(context) * 0.013,
                                              horizontal:
                                                  width(context) * 0.016,
                                            ),
                                            child: appText(
                                              data: "Mobile number",
                                              size: width(context) * 0.037,
                                              color: txtSecondaryDarkColor,
                                            ),
                                          ),
                                          TextFormField(
                                            initialValue: mobileNumberValue,
                                            enabled: false,
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: disableColor,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: disableColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: txtHintColor),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: width(context) * 0.013,
                                              horizontal:
                                                  width(context) * 0.016,
                                            ),
                                            child: appText(
                                              data: "Circle",
                                              size: width(context) * 0.037,
                                              color: txtSecondaryDarkColor,
                                            ),
                                          ),
                                          TextFormField(
                                            initialValue: circleValue,
                                            enabled: false,
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: disableColor,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: disableColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: txtHintColor),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: width(context) * 0.013,
                                              horizontal:
                                                  width(context) * 0.016,
                                            ),
                                            child: appText(
                                              data: "Operator",
                                              size: width(context) * 0.037,
                                              color: txtSecondaryDarkColor,
                                            ),
                                          ),
                                          TextFormField(
                                            enabled: false,
                                            initialValue: widget
                                                .billerData?.bILLERNAME
                                                .toString(),
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: disableColor,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: disableColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: txtHintColor),
                                            ),
                                          ),
                                        ]),
                                  for (int q = 0;
                                      q < inputSignatureItems!.length;
                                      q++)
                                    if (!(widget.billerData?.cATEGORYNAME
                                            .toString()
                                            .toLowerCase() ==
                                        "mobile prepaid"))
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: width(context) * 0.013,
                                              horizontal:
                                                  width(context) * 0.016,
                                            ),
                                            child: appText(
                                              data: inputSignatureItems![q]
                                                  .pARAMETERNAME,
                                              size: width(context) * 0.037,
                                              color: txtSecondaryDarkColor,
                                            ),
                                          ),
                                          TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            enabled: true,
                                            controller:
                                                inputSignatureControllers[q],
                                            autocorrect: false,
                                            enableSuggestions: false,
                                            keyboardType: getInputType(
                                                inputSignatureItems![q]
                                                    .pARAMETERTYPE),

                                            onChanged: (s) {
                                              FormValidation(q, false);
                                            },
                                            // inputFormatters: [
                                            //   FilteringTextInputFormatter.allow(
                                            //       RegExp(r'^[0-9]*'))
                                            // ],
                                            // inputFormatters: [
                                            //   inputSignatureItems![q].rEGEX ==
                                            //           null
                                            //       ? FilteringTextInputFormatter
                                            //           .allow(RegExp(
                                            //               r'^[a-z0-9A-Z ]*'))
                                            //       : FilteringTextInputFormatter
                                            //           .allow(RegExp(
                                            //               'r"${inputSignatureItems![q].rEGEX}"'))
                                            // ],
                                            key: _fieldKey[q],

                                            validator: (inputValue) {
                                              final _regex =
                                                  "${inputSignatureItems![q].rEGEX}";
                                              final fieldRegExp = RegExp(
                                                  "${inputSignatureItems![q].rEGEX}");

                                              debugPrint(fieldRegExp
                                                  .hasMatch(inputValue!)
                                                  .toString());
                                              if (inputValue.length <
                                                  inputSignatureItems![q]
                                                      .mINLENGTH!
                                                      .toInt()) {
                                                if (inputSignatureItems![q]
                                                        .mINLENGTH ==
                                                    inputSignatureItems![q]
                                                        .mAXLENGTH) {
                                                  return ("${inputSignatureItems![q].pARAMETERNAME} should be of ${inputSignatureItems![q].mAXLENGTH} ${inputSignatureItems![q].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}");
                                                } else {
                                                  return "${inputSignatureItems![q].pARAMETERNAME} should have at least ${inputSignatureItems![q].mINLENGTH} ${inputSignatureItems![q].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}";
                                                }
                                              } else if (inputValue.length >
                                                  inputSignatureItems![q]
                                                      .mAXLENGTH!
                                                      .toInt()) {
                                                if (inputSignatureItems![q]
                                                        .mINLENGTH ==
                                                    inputSignatureItems![q]
                                                        .mAXLENGTH) {
                                                  return ("${inputSignatureItems![q].pARAMETERNAME} should be of ${inputSignatureItems![q].mAXLENGTH} ${inputSignatureItems![q].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}");
                                                } else {
                                                  // If the input type is numeric then append digits to the error message else append characters

                                                  return "${inputSignatureItems![q].pARAMETERNAME} should have no more than ${inputSignatureItems![q].mAXLENGTH} ${inputSignatureItems![q].pARAMETERTYPE!.toLowerCase() == 'numeric' ? 'digits' : 'characters'}";
                                                }
                                              } else if (!fieldRegExp
                                                      .hasMatch(inputValue) &&
                                                  inputSignatureItems![q]
                                                          .rEGEX !=
                                                      null) {
                                                debugPrint(
                                                    "fieldRegExp====> $_regex");
                                                debugPrint(
                                                    "RegExp validate====> ${fieldRegExp.hasMatch(inputValue)}");

                                                return "${inputSignatureItems![q].pARAMETERNAME} Must be Valid";
                                              }
                                              return null;
                                            },

                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: fillColor,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: disableColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: primaryBodyColor,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              hintText:
                                                  "Enter ${inputSignatureItems![q].pARAMETERNAME}",
                                              hintStyle: TextStyle(
                                                  color: txtHintColor),
                                            ),
                                          ),
                                        ],
                                      ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: width(context) * 0.020,
                                      horizontal: width(context) * 0.016,
                                    ),
                                    child: Row(
                                      children: [
                                        appText(
                                          data: "Bill Name ",
                                          size: width(context) * 0.038,
                                          color: txtSecondaryDarkColor,
                                        ),
                                        appText(
                                          data: " (Nick Name)",
                                          size: width(context) * 0.038,
                                          color: txtSecondaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Bill Name Textformfield
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: width(context) * 0.032,
                                    ),
                                    child: TextFormField(
                                      maxLength: 20,
                                      controller: billNameController,
                                      key: _billnameKey,
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[a-z0-9A-Z ]*'))
                                      ],
                                      onChanged: (s) {
                                        if (widget.billerData?.cATEGORYNAME
                                                .toString()
                                                .toLowerCase() !=
                                            "mobile prepaid") {
                                          FormValidation(9999, true);
                                        } else {
                                          if (billNameController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              isValidBillName = true;
                                              isButtonActive = true;
                                            });
                                          } else {
                                            setState(() {
                                              isValidBillName = false;
                                              isButtonActive = false;
                                            });
                                          }
                                        }

                                        // if (s.isEmpty) {
                                        //   setState(() {
                                        //     isButtonActive = false;
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     isButtonActive = true;
                                        //   });
                                        // }
                                      },
                                      validator: (inputValue) {
                                        if (inputValue!.isEmpty) {
                                          return "Bill Name Should Not be Empty";
                                        }
                                      },
                                      decoration: InputDecoration(
                                        fillColor: primaryBodyColor,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryBodyColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryBodyColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryBodyColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryBodyColor,
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        hintText: "Enter Bill Name",
                                        hintStyle:
                                            TextStyle(color: txtHintColor),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // height: height(context) * 0.1,
                                    width: width(context),
                                    decoration: BoxDecoration(
                                      color: primaryBodyColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: width(context) * 0.016,
                                        vertical: width(context) * 0.044,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            width(context) * 0.016),
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      actions: [
                                                        myAppButton(
                                                          context: context,
                                                          buttonName: "Done",
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 40,
                                                            left: 40,
                                                            top: 0,
                                                          ),
                                                          onpress: () =>
                                                              goBack(context),
                                                        )
                                                      ],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      elevation: 3,
                                                      content:
                                                          SingleChildScrollView(
                                                        padding: EdgeInsets.all(
                                                            width(context) *
                                                                0.024),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            HtmlWidget(
                                                                bbpsSettingInfo!
                                                                    .tERMSANDCONDITIONS
                                                                    .toString()),
                                                          ],
                                                        ),
                                                      ));
                                                });
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontFamily: appFont,
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(text: tcTextContent),
                                                TextSpan(
                                                  text: tcText,
                                                  style: TextStyle(
                                                      fontFamily: appFont,
                                                      color: txtAmountColor,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // if (widget.billerData?.cATEGORYNAME
                                  //         .toString()
                                  //         .toLowerCase() !=
                                  //     "mobile prepaid")
                                  //   Row(children: [
                                  //     Checkbox(
                                  //       value: isAddtoMybill,
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           this.isAddtoMybill = !isAddtoMybill;
                                  //         });
                                  //       },
                                  //     ),
                                  //     horizondalSpacer(width(context) * 0.01),
                                  //     appText(
                                  //       data: "Add Operator to my Billing list",
                                  //       size: width(context) * 0.04,
                                  //       color: txtPrimaryColor,
                                  //     ),
                                  //   ]), //Checkbox],),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: height(context) * 0.8,
                              width: width(context),
                              child: Center(
                                child: Image.asset(
                                  LoaderGif,
                                  height: height(context) * 0.07,
                                  width: height(context) * 0.07,
                                ),
                              )),
                    ),
                  ),
                  myAppButton(
                    context: context,
                    buttonName: "Next",
                    onpress: isButtonActive && isValidBillName
                        ? () {
                            if (!(widget.billerData?.cATEGORYNAME
                                    .toString()
                                    .toLowerCase() ==
                                "mobile prepaid")) {
                              submitForm();
                            } else {
                              addMobilePrepaid();
                            }
                          }
                        : null,
                    margin: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: width(context) * 0.042,
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
  }
}
