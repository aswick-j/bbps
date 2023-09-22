import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer';
import '../../bloc/home/home_cubit.dart';
import '../../model/saved_billers_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/shimmerCell.dart';

class MyBillersHome extends StatefulWidget {
  const MyBillersHome({Key? key}) : super(key: key);

  @override
  State<MyBillersHome> createState() => _MyBillersHomeState();
}

class _MyBillersHomeState extends State<MyBillersHome> {
  List<SavedBillersData>? savedBillersData = [];
  bool isLoading = true;
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getSavedBillers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is SavedBillersLoading) {
            isLoading = true;
          } else if (state is SavedBillersSuccess) {
            savedBillersData = state.savedBillersData;
            isLoading = false;
          } else if (state is SavedBillersFailed) {
            showSnackBar(state.message, context);
          } else if (state is SavedBillersError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          return isLoading
              ? Container(
                  color: primaryBodyColor,
                  height: height(context),
                  width: width(context),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: width(context) * 0.044,
                      left: width(context) * 0.044,
                    ),
                    width: width(context),
                    decoration: BoxDecoration(
                      color: txtColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(width(context) * 0.044),
                      width: width(context),
                      decoration: BoxDecoration(
                        color: primaryBodyColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          height: 200,
                          child: Shimmer.fromColors(
                            baseColor: divideColor,
                            highlightColor: iconColor,
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (_, __) => SizedBox(width: 15),
                              itemCount: 7,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width(context) * 0.004),
                                  child: Row(
                                    children: [
                                      ShimmerCell(
                                          cellheight: 65.0, cellwidth: 65),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ShimmerCell(
                                              cellheight: 10.0,
                                              cellwidth: width(context) / 2),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: width(context) * 0.020),
                                            child: ShimmerCell(
                                                cellheight: 10.0,
                                                cellwidth:
                                                    width(context) / 2.4),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )),
                    ),
                  ),
                )
              : MyBillersUI(
                  savedBillersData: savedBillersData,
                );
        },
      ),
    );
  }
}

class MyBillersUI extends StatefulWidget {
  List<SavedBillersData>? savedBillersData;

  MyBillersUI({Key? key, @required this.savedBillersData}) : super(key: key);

  @override
  State<MyBillersUI> createState() => _MyBillersUIState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _MyBillersUIState extends State<MyBillersUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryBodyColor,
      height: height(context),
      width: width(context),
      child: Container(
        margin: EdgeInsets.only(
          right: width(context) * 0.044,
          left: width(context) * 0.044,
        ),
        width: width(context),
        decoration: BoxDecoration(
          color: txtColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          margin: EdgeInsets.all(width(context) * 0.044),
          width: width(context),
          decoration: BoxDecoration(
            color: primaryBodyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.savedBillersData!.isNotEmpty
              ? ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.savedBillersData!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        if (widget.savedBillersData![index].cATEGORYNAME
                            .toString()
                            .toLowerCase()
                            .contains("mobile prepaid")) {
                          isSavedBillFrom = true;
                          isMobilePrepaidFrom = true;
                          if (baseUrl
                              .toString()
                              .toLowerCase()
                              .contains("digiservicesuat")) {
                            goToData(context, prepaidAddBillerRoute, {
                              "id": "",
                              "name": widget
                                  .savedBillersData![index].cATEGORYNAME
                                  .toString(),
                              "savedBillersData":
                                  widget.savedBillersData![index],
                              "isSavedBill": true
                            });
                          } else {
                            customDialog(
                                context: context,
                                message: "This is an upcoming feature.",
                                message2: "",
                                message3: "",
                                title: "Alert!",
                                buttonName: "Okay",
                                dialogHeight: height(context) / 2.5,
                                buttonAction: () {
                                  Navigator.pop(context, true);
                                },
                                iconSvg: alertSvg);
                          }
                        } else {
                          isSavedBillFrom = true;
                          isMobilePrepaidFrom = false;
                          goToData(context, confirmPaymentRoute, {
                            "billID":
                                widget.savedBillersData![index].cUSTOMERBILLID,
                            "name": widget.savedBillersData![index].bILLERNAME,
                            "number":
                                widget.savedBillersData![index].pARAMETERVALUE,
                            "savedBillersData": widget.savedBillersData![index],
                            "isSavedBill": true
                          });
                        }
                      },
                      child: Container(
                        height:
                            widget.savedBillersData![index].aUTOPAYID == null &&
                                    widget.savedBillersData![index]
                                            .cUSTOMERBILLID !=
                                        null &&
                                    widget.savedBillersData![index]
                                            .tRANSACTIONSTATUS ==
                                        "success" &&
                                    widget.savedBillersData![index]
                                            .bILLERACCEPTSADHOC ==
                                        "N"
                                ? height(context) * 0.15
                                : height(context) * 0.12,
                        margin: EdgeInsets.symmetric(
                          horizontal: width(context) * 0.008,
                          vertical: width(context) * 0.008,
                        ),
                        decoration: BoxDecoration(
                          color: txtColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 14,
                              left: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Image.asset(
                                    bNeumonic,
                                    height: width(context) * 0.13,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: SizedBox(
                                      height: height(context) * 0.08,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          appText(
                                            data: widget
                                                .savedBillersData![index]
                                                .bILLERNAME!,
                                            size: width(context) * 0.035,
                                            color: txtSecondaryColor,
                                          ),
                                          appText(
                                              data: widget
                                                  .savedBillersData![index]
                                                  .bILLNAME,
                                              size: width(context) * 0.035,
                                              color: txtPrimaryColor,
                                              weight: FontWeight.bold),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: width(context) * 0.0001,
                            child: PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: iconColor,
                              ),
                              onSelected: (value) {
                                if (value == 0) {
                                  goToData(context, editBill, {
                                    "data": widget.savedBillersData![index]
                                  });
                                } else if (value == 1) {
                                  customDialog(
                                      context: context,
                                      message: widget.savedBillersData![index]
                                                  .cATEGORYNAME ==
                                              "Mobile Prepaid"
                                          ? "You will no longer receive any notifications about the biller in future"
                                          : "You will no longer receive any notifications about the biller in future and all auto pay setups would be disabled effectively from the next cycle",
                                      message2: "",
                                      message3: "",
                                      title: "Alert!",
                                      buttonName: "Delete",
                                      isMultiBTN: true,
                                      dialogHeight: height(context) / 2.5,
                                      buttonAction: () {
                                        Navigator.pop(context, true);
                                        goToData(context, otpRoute, {
                                          "from": myBillRoute,
                                          "templateName": "delete-biller-otp",
                                          "data": {
                                            "bILLERNAME": widget
                                                .savedBillersData![index]
                                                .bILLERNAME,
                                            "cbid": widget
                                                .savedBillersData![index]
                                                .cUSTOMERBILLID
                                                .toString()
                                          }
                                        });
                                      },
                                      iconSvg: alertSvg);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  onTap: () => {},
                                  height: height(context) * 0.045,
                                  child: const Text('View'),
                                ),

                                //  customPopupMenuItem(
                                //     context: context,
                                //     title: "Edit",
                                //     value: 0,
                                //     iconData: Icons.edit,
                                //     color: iconColor),
                                // customPopupMenuItem(
                                //     context: context,
                                //     title: "Delete",
                                //     value: 1,
                                //     iconData: Icons.delete,
                                //     color: iconColor),

                                PopupMenuItem(
                                  value: 1,
                                  onTap: () => {},
                                  height: height(context) * 0.045,
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                          // if (widget.savedBillersData![index].aUTOPAYID ==
                          //         null &&
                          //     widget.savedBillersData![index].cUSTOMERBILLID !=
                          //         null &&
                          //     widget.savedBillersData![index]
                          //             .tRANSACTIONSTATUS ==
                          //         "success" &&
                          //     widget.savedBillersData![index]
                          //             .bILLERACCEPTSADHOC ==
                          //         "N")
                          // Positioned(
                          //     bottom: 4,
                          //     right: 4,
                          //     child: Container(
                          //         height: height(context) * 0.030,
                          //         width: width(context) * 0.36,
                          //         // decoration: BoxDecoration(
                          //         //     color: alertSuccessColor,
                          //         //     borderRadius: const BorderRadius.only(
                          //         //         bottomRight: Radius.circular(10),
                          //         //         topLeft: Radius.circular(8))),
                          //         child: ElevatedButton(
                          //             style: ElevatedButton.styleFrom(
                          //                 minimumSize: Size(
                          //                     width(context) * 0.30, 40.0),
                          //                 backgroundColor: primaryColor),
                          //             child: Text(
                          //               "Eligible for Autopay",
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                 height: 1.4,
                          //                 color: Colors.white,
                          //                 fontSize: width(context) * 0.03,
                          //                 fontFamily: appFont,
                          //                 fontWeight: FontWeight.normal,
                          //               ),
                          //             ),
                          //             onPressed: () => goToData(
                          //                     context, setupAutoPayRoute, {
                          //                   "customerBillID": widget
                          //                       .savedBillersData![index]
                          //                       .cUSTOMERBILLID
                          //                       .toString(),
                          //                   "paidAmount": widget
                          //                       .savedBillersData![index]
                          //                       .bILLAMOUNT
                          //                       .toString(),
                          //                   "inputSignatures": widget
                          //                       .savedBillersData![index]
                          //                       .pARAMETERS,
                          //                   "billname": widget
                          //                       .savedBillersData![index]
                          //                       .bILLNAME,
                          //                   "billername": widget
                          //                       .savedBillersData![index]
                          //                       .bILLERNAME,
                          //                   "limit": "0"
                          //                 })))),

                          if (widget.savedBillersData![index].aUTOPAYID != null)
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  height: height(context) * 0.022,
                                  width: width(context) * 0.26,
                                  decoration: BoxDecoration(
                                      color: alertSuccessColor,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(7),
                                          topLeft: Radius.circular(8))),
                                  child: Text("Autopay Enabled",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1.4,
                                        color: Colors.white,
                                        fontSize: width(context) * 0.03,
                                        fontFamily: appFont,
                                        fontWeight: FontWeight.normal,
                                      )),
                                )),
                          if (widget.savedBillersData![index].aUTOPAYID ==
                                  null &&
                              widget.savedBillersData![index].cUSTOMERBILLID !=
                                  null &&
                              widget.savedBillersData![index]
                                      .tRANSACTIONSTATUS ==
                                  "success" &&
                              widget.savedBillersData![index]
                                      .bILLERACCEPTSADHOC ==
                                  "N")
                            Positioned(
                              bottom: height(context) * 0.008,
                              left: width(context) * 0.06,
                              child: Container(
                                  height: height(context) * 0.030,
                                  width: width(context) * 0.68,
                                  decoration: BoxDecoration(
                                      color: alertSuccessColor,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(8))),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              Size(width(context) * 0.30, 40.0),
                                          backgroundColor: primaryColor),
                                      child: Text(
                                        "Eligible for Autopay",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: 1.4,
                                          color: Colors.white,
                                          fontSize: width(context) * 0.03,
                                          fontFamily: appFont,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onPressed: () =>
                                          goToData(context, setupAutoPayRoute, {
                                            "customerBillID": widget
                                                .savedBillersData![index]
                                                .cUSTOMERBILLID
                                                .toString(),
                                            "paidAmount": widget
                                                .savedBillersData![index]
                                                .bILLAMOUNT
                                                .toString(),
                                            "inputSignatures": widget
                                                .savedBillersData![index]
                                                .pARAMETERS,
                                            "billname": widget
                                                .savedBillersData![index]
                                                .bILLNAME,
                                            "billername": widget
                                                .savedBillersData![index]
                                                .bILLERNAME,
                                            "limit": "0"
                                          }))),
                            )
                        ]),
                      ),
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconAppHomeSvg,
                      height: height(context) * 0.10,
                    ),
                    verticalSpacer(width(context) * 0.04),
                    appText(
                        data: "You have No Saved Biller",
                        size: 16.6,
                        color: txtPrimaryColor)
                  ],
                ),
        ),
      ),
    );
  }
}
