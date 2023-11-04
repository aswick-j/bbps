import 'package:bbps/bbps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/home/home_cubit.dart';
import '../../model/bbps_settings_model.dart';
import '../../model/edit_bill_modal.dart';
import '../../model/input_signatures_model.dart';
import '../../model/saved_billers_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class EditBill extends StatefulWidget {
  SavedBillersData? billData;
  EditBill({Key? key, this.billData}) : super(key: key);

  @override
  _EditBillState createState() => _EditBillState();
}

class _EditBillState extends State<EditBill> {
  bool isButtonActive = false;
  dynamic billNameController = TextEditingController();
  final GlobalKey<FormFieldState> _billnameKey = GlobalKey<FormFieldState>();
  bbpsSettingsData? BbpsSettingInfo;
  List<TextEditingController> InputSignatureControllers = [];
  List<InputSignaturess>? EditInputItems = [];
  List<InputSignaturesData>? InputSignatureItems = [];
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context)
        .getEditBill(widget.billData!.cUSTOMERBILLID);
    BlocProvider.of<HomeCubit>(context).getBbpsSettings();
    super.initState();
  }

  submitForm() {
    Map<String, dynamic> inputParameters = {
      "billName": billNameController.text,
      "categoryName": widget.billData!.cATEGORYNAME,
      "customerBillId": widget.billData!.cUSTOMERBILLID,
    };

    BlocProvider.of<HomeCubit>(context).updateBill(inputParameters);
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
          title: "Edit Biller",
          bottom: PreferredSize(
            preferredSize: Size(width(context), 8.0),
            child: Container(
              width: width(context),
              color: primaryBodyColor,
            ),
          ),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is InputSignatureLoading) {
            } else if (state is InputSignatureSuccess) {
              InputSignatureItems = state.InputSignatureList;
              for (int i = 0; i < InputSignatureItems!.length; i++) {
                var textEditingController = TextEditingController(text: "");
                InputSignatureControllers.add(textEditingController);
              }
            } else if (state is InputSignatureFailed) {
              showSnackBar(state.message, context);
            } else if (state is InputSignatureError) {
              goToUntil(context, splashRoute);
            }

            if (state is EditBillLoading) {
            } else if (state is EditBillSuccess) {
              EditInputItems = state.EditBillList?.inputSignaturess;

              for (int m = 0; m < EditInputItems!.length; m++) {
                var textEditingController = TextEditingController(
                    text: EditInputItems![m].pARAMETERVALUE);
                billNameController = TextEditingController(
                    text: state.EditBillList!.billName![0].bILLNAME);
                InputSignatureControllers.add(textEditingController);
              }
            } else if (state is EditBillFailed) {
              showSnackBar(state.message, context);
            } else if (state is EditBillError) {
              goToUntil(context, splashRoute);
            }
            if (state is BbpsSettingsLoading) {
            } else if (state is BbpsSettingsSuccess) {
              BbpsSettingInfo = state.BbpsSettingsDetails!.data;
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
          },
          builder: (context, state) {
            return ListView(children: [
              Column(
                children: [
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
                        child: EditInputItems!.isNotEmpty
                            ? Form(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int q = 0;
                                        q < EditInputItems!.length;
                                        q++)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (widget.billData?.cATEGORYNAME
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "mobile prepaid" &&
                                              EditInputItems![q]
                                                      .pARAMETERNAME
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "id")
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    width(context) * 0.013,
                                                horizontal:
                                                    width(context) * 0.016,
                                              ),
                                              child: appText(
                                                data: EditInputItems![q]
                                                    .pARAMETERNAME,
                                                size: width(context) * 0.037,
                                                color: txtSecondaryDarkColor,
                                              ),
                                            ),
                                          if (widget.billData?.cATEGORYNAME
                                                  .toString()
                                                  .toLowerCase() !=
                                              "mobile prepaid")
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical:
                                                    width(context) * 0.013,
                                                horizontal:
                                                    width(context) * 0.016,
                                              ),
                                              child: appText(
                                                data: EditInputItems![q]
                                                    .pARAMETERNAME,
                                                size: width(context) * 0.037,
                                                color: txtSecondaryDarkColor,
                                              ),
                                            ),
                                          if (widget.billData?.cATEGORYNAME
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "mobile prepaid" &&
                                              EditInputItems![q]
                                                      .pARAMETERNAME
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "id")
                                            TextFormField(
                                              enabled: false,
                                              controller:
                                                  InputSignatureControllers[q],
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
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: disableColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: primaryBodyColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: primaryBodyColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                hintText:
                                                    "Enter ${EditInputItems![q].pARAMETERNAME}",
                                                hintStyle: TextStyle(
                                                    color: txtHintColor),
                                              ),
                                            ),
                                          if (widget.billData?.cATEGORYNAME
                                                  .toString()
                                                  .toLowerCase() !=
                                              "mobile prepaid")
                                            TextFormField(
                                              enabled: false,
                                              controller:
                                                  InputSignatureControllers[q],
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
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: disableColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: primaryBodyColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: primaryBodyColor,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                hintText:
                                                    "Enter ${EditInputItems![q].pARAMETERNAME}",
                                                hintStyle: TextStyle(
                                                    color: txtHintColor),
                                              ),
                                            ),
                                        ],
                                      ),
                                    if (widget.billData?.cATEGORYNAME
                                            .toString()
                                            .toLowerCase() ==
                                        "mobile prepaid")
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
                                              data: "Biller Name",
                                              size: width(context) * 0.037,
                                              color: txtSecondaryDarkColor,
                                            ),
                                          ),
                                          TextFormField(
                                            enabled: false,
                                            initialValue: widget
                                                .billData?.bILLERNAME
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
                                        //EDIT BILLER CHANGED TO VIEW BILLER AS PER TL SAYING
                                        enabled: true,
                                        controller: billNameController,
                                        key: _billnameKey,
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        keyboardType: TextInputType.text,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^[a-z0-9A-Z ]*'))
                                        ],
                                        validator: (inputValue) {
                                          if (inputValue!.isEmpty) {
                                            return "Bill Name Should Not be Empty";
                                          }
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              isButtonActive = true;
                                            });
                                          } else {
                                            setState(() {
                                              isButtonActive = false;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryBodyColor,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          disabledBorder: OutlineInputBorder(
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
                                          hintStyle:
                                              TextStyle(color: txtHintColor),
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   height: height(context) * 0.1,
                                    //   width: width(context),
                                    //   decoration: BoxDecoration(
                                    //     color: primaryBodyColor,
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   child: Container(
                                    //     margin: EdgeInsets.symmetric(
                                    //       horizontal: width(context) * 0.016,
                                    //       vertical: width(context) * 0.044,
                                    //     ),
                                    //     child: Padding(
                                    //       padding: EdgeInsets.all(
                                    //           width(context) * 0.016),
                                    //       child: InkWell(
                                    //         onTap: () {
                                    //           showDialog(
                                    //               barrierDismissible: false,
                                    //               context: context,
                                    //               builder: (context) {
                                    //                 return AlertDialog(
                                    //                     actions: [
                                    //                       myAppButton(
                                    //                         context: context,
                                    //                         buttonName: "Done",
                                    //                         margin:
                                    //                             const EdgeInsets
                                    //                                 .only(
                                    //                           right: 40,
                                    //                           left: 40,
                                    //                           top: 0,
                                    //                         ),
                                    //                         onpress: () =>
                                    //                             goBack(context),
                                    //                       )
                                    //                     ],
                                    //                     shape:
                                    //                         RoundedRectangleBorder(
                                    //                       borderRadius:
                                    //                           BorderRadius
                                    //                               .circular(12),
                                    //                     ),
                                    //                     elevation: 3,
                                    //                     content:
                                    //                         SingleChildScrollView(
                                    //                       padding: EdgeInsets
                                    //                           .all(width(
                                    //                                   context) *
                                    //                               0.024),
                                    //                       child: Column(
                                    //                         mainAxisAlignment:
                                    //                             MainAxisAlignment
                                    //                                 .spaceBetween,
                                    //                         children: [
                                    //                           HtmlWidget(BbpsSettingInfo!
                                    //                               .tERMSANDCONDITIONS
                                    //                               .toString()),
                                    //                         ],
                                    //                       ),
                                    //                     ));
                                    //               });
                                    //         },
                                    //         child: RichText(
                                    //           text: TextSpan(
                                    //             style: const TextStyle(
                                    //               fontFamily: appFont,
                                    //               fontSize: 14.0,
                                    //               color: Colors.black,
                                    //             ),
                                    //             children: <TextSpan>[
                                    //               TextSpan(text: tcTextContent),
                                    //               TextSpan(
                                    //                 text: tcText,
                                    //                 style: TextStyle(
                                    //                     fontFamily: appFont,
                                    //                     color: txtAmountColor,
                                    //                     decoration:
                                    //                         TextDecoration
                                    //                             .underline),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    //Checkbox],),
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
                                ))),
                  ),
                  myAppButton(
                    context: context,
                    buttonName: "Update Biller",
                    onpress: isButtonActive
                        ? () {
                            submitForm();
                          }
                        : null,
                    margin: EdgeInsets.symmetric(
                      horizontal: width(context) * 0.04,
                      vertical: width(context) * 0.042,
                    ),
                  ),
                ],
              )
            ]);
          },
        ));
  }
}
