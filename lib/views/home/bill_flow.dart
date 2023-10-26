import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bbps/widgets/shimmerCell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/home/home_cubit.dart';
import '../../model/biller_model.dart';
import '../../model/saved_billers_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

final searchTxtController = TextEditingController();

class BillFlow extends StatefulWidget {
  dynamic id;
  String name;
  BillFlow({
    Key? key,
    @required this.id,
    required this.name,
  }) : super(key: key);

  @override
  _BillFlowState createState() => _BillFlowState();
}

class _BillFlowState extends State<BillFlow> {
  List<SavedBillersData>? SavedBiller = [];
  List<SavedBillersData>? SavedBillerOrg = [];

  List<SavedBillersData>? SavedBillerFilterTemp1 = [];
  List<SavedBillersData>? SavedBillerFilterTemp2 = [];

  List<BillersData>? Allbiller = [];
  List<BillersData>? AllbillerSearch = [];

  String _selectedCategory = "All";
  final String _selectedLocation = "All";
  String lastSearchValue = "";
  List<BillersData>? BillerSearchResults = [];
  bool isLoading = false;

  bool showbane = true;
  final infiniteScrollController = ScrollController();

  bool showSearch = false;

  void initScrollController(context) {
    infiniteScrollController.addListener(() {
      if (infiniteScrollController.position.atEdge) {
        if (infiniteScrollController.position.pixels != 0) {
          BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id);
        }
      }
    });
  }

  bool isSavedBillersLoading = true;
  bool allBillersLoading = true;

  searchData(searchTxt) {
    setState(() {
      showSearch = true;
    });
    if (searchTxt.length > 1) {
      setState(() {
        SavedBiller = SavedBillerOrg?.where((item) =>
            item.bILLNAME!
                .toLowerCase()
                .contains(searchTxtController.text.toLowerCase()) ||
            item.bILLERNAME!
                .toLowerCase()
                .contains(searchTxtController.text.toLowerCase())).toList();
      });
    } else if (searchTxt.isEmpty) {
      setState(() {
        SavedBiller = SavedBillerOrg;
      });
    }
    if (searchTxt.length >= 1) {
      lastSearchValue = searchTxt;

      BlocProvider.of<HomeCubit>(context).searchBiller(
          searchTxtController.text, widget.name, _selectedLocation);
    } else {}
  }

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getSavedBillers();
    setState(() {
      _selectedCategory = widget.name.toString();
    });

    initScrollController(context);
    super.initState();
  }

  @override
  void dispose() {
    showSearch = false;
    searchTxtController.text = "";
    AllbillerSearch = [];

    // searchTxtController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBodyColor,
      // appBar: myAppBar(
      //   context: context,
      //   backgroundColor: primaryColor,
      //   title: widget.name,
      //   bottom: PreferredSize(
      //     preferredSize: Size(width(context), 8.0),
      //     child: Container(
      //       width: width(context),
      //       color: primaryBodyColor,
      //     ),
      //   ),
      // ),

      appBar: AppBar(
        centerTitle: false,
        backgroundColor: showSearch ? txtColor : primaryColor,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: !showSearch ? txtColor : primaryColor,
          ),
        ),
        title: !showSearch
            ? appText(
                data: widget.name,
                size: width(context) * 0.06,
                weight: FontWeight.w500,
              )
            : TextFormField(
                autofocus: true,
                controller: searchTxtController,
                onChanged: (searchTxt) {
                  if (searchTxt.isEmpty) {
                    Loader.hide();
                  }
                  if (lastSearchValue != searchTxt) {
                    searchData(searchTxt);
                  }
                },
                onFieldSubmitted: (_) {},
                keyboardType: TextInputType.text,
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-z0-9A-Z. ]*'))
                ],
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      searchTxtController.clear();

                      setState(() {
                        showSearch = false;
                        // historyData = cloneData;
                      });
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 26,
                      color: primaryColor,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: txtHintColor),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
        actions: showSearch
            ? null
            : [
                IconButton(
                  splashRadius: 25,
                  onPressed: () => setState(() {
                    showSearch = true;
                  }),
                  icon: Icon(
                    Icons.search,
                    color: txtColor,
                  ),
                )
              ],
        elevation: 0,
      ),
      body: Container(
        height: height(context),
        decoration: BoxDecoration(
          color: txtColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (showbane)
              SingleChildScrollView(child:
                  BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
                if (state is SavedBillerLoading) {
                  isSavedBillersLoading = true;
                } else if (state is SavedBillersSuccess) {
                  isSavedBillersLoading = false;

                  SavedBillerFilterTemp1 = state.savedBillersData
                      ?.where((item) => item.cATEGORYNAME == widget.name)
                      .toList();

                  SavedBiller = SavedBillerFilterTemp1;
                  SavedBillerOrg = SavedBiller?.where(
                      (item) => item.cATEGORYNAME == widget.name).toList();
                  Future.delayed(
                    const Duration(milliseconds: 1),
                    () => {
                      BlocProvider.of<HomeCubit>(context)
                          .getAllBiller(widget.id),
                      setState(() {
                        if (SavedBiller!.isEmpty) {
                          showbane = false;
                        }
                      })
                    },
                  );
                } else if (state is SavedBillersFailed) {
                  isSavedBillersLoading = false;
                  showSnackBar(state.message, context);
                } else if (state is SavedBillersError) {
                  goToUntil(context, splashRoute);
                }
                return Column(children: [
                  if (isSavedBillersLoading || SavedBiller!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: width(context) * 0.024,
                          horizontal: width(context) * 0.044),
                      alignment: Alignment.centerLeft,
                      child: appText(
                        data: "Saved Billers",
                        size: width(context) * 0.05,
                        color: primaryColor,
                        weight: FontWeight.bold,
                      ),
                    ),
                  if (isSavedBillersLoading || SavedBiller!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(width(context) * 0.016),
                      child: isSavedBillersLoading
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              height: height(context) / 3.6,
                              child: Shimmer.fromColors(
                                baseColor: divideColor,
                                highlightColor: iconColor,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  scrollDirection: Axis.vertical,
                                  // separatorBuilder: (_, __) => SizedBox(width: 15),
                                  itemCount: 3,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: width(context) * 0.016),
                                      child: Row(
                                        children: [
                                          ShimmerCell(
                                              cellheight: 60.0, cellwidth: 60),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ShimmerCell(
                                                  cellheight: 10.0,
                                                  cellwidth:
                                                      width(context) / 2),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        width(context) * 0.020),
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
                              ))
                          : Container(
                              constraints: BoxConstraints(
                                minHeight: height(context) / 8.2,
                                maxHeight: height(context) / 3.2,
                              ),

                              // height: height(context) / 3.2,
                              decoration: BoxDecoration(
                                color: primaryBodyColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: SavedBiller?.length,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: txtColor),
                                  margin: EdgeInsets.only(
                                    top: width(context) * 0.02,
                                    right: width(context) * 0.02,
                                    left: width(context) * 0.02,
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          if (SavedBiller![index]
                                              .cATEGORYNAME
                                              .toString()
                                              .toLowerCase()
                                              .contains("mobile prepaid")) {
                                            isSavedBillFrom = true;
                                            isMobilePrepaidFrom = true;
                                            // if (baseUrl
                                            //     .toString()
                                            //     .toLowerCase()
                                            //     .contains("digiservicesuat")) {
                                            goToData(context,
                                                prepaidAddBillerRoute, {
                                              "id": widget.id,
                                              "name": SavedBiller![index]
                                                  .cATEGORYNAME
                                                  .toString(),
                                              "savedBillersData":
                                                  SavedBiller![index],
                                              "isSavedBill": true
                                            });
                                          } else {
                                            isSavedBillFrom = true;
                                            isMobilePrepaidFrom = false;
                                            goToData(
                                                context, confirmPaymentRoute, {
                                              "billID": SavedBiller![index]
                                                  .cUSTOMERBILLID,
                                              "name": SavedBiller![index]
                                                  .bILLERNAME,
                                              "number": SavedBiller![index]
                                                  .pARAMETERVALUE,
                                              "billerID":
                                                  SavedBiller![index].bILLERID,
                                              "savedBillersData":
                                                  SavedBiller![index],
                                              "isSavedBill": true
                                            });
                                          }
                                        },
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 0.036,
                                          vertical: width(context) * 0.02,
                                        ),
                                        // leading: SvgPicture.asset(
                                        //   airtelLogo,
                                        // ),
                                        leading: Container(
                                          width: width(context) * 0.13,
                                          height: height(context) * 0.06,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomRight,
                                                  stops: [
                                                    0.1,
                                                    0.9
                                                  ],
                                                  colors: [
                                                    Colors.deepPurple
                                                        .withOpacity(.16),
                                                    Colors.grey.withOpacity(.08)
                                                  ])),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                BillerLogo(
                                                    SavedBiller![index]
                                                        .bILLERNAME
                                                        .toString(),
                                                    SavedBiller![index]
                                                        .cATEGORYNAME
                                                        .toString()),
                                                // height: height(context) * 0.07,
                                              )),
                                        ),

                                        title: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: width(context) * 0.008),
                                          child: appText(
                                            data: SavedBiller![index].bILLNAME,
                                            size: width(context) * 0.04,
                                            color: txtSecondaryColor,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(
                                              top: width(context) * 0.016),
                                          child: appText(
                                            data:
                                                SavedBiller![index].bILLERNAME,
                                            size: width(context) * 0.04,
                                            color: txtPrimaryColor,
                                            maxline: 1,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: iconColor,
                                          ),
                                          onSelected: (value) {
                                            if (value == 0) {
                                              goToData(context, editBill, {
                                                "data": SavedBiller![index],
                                              });
                                            } else if (value == 1) {
                                              customDialog(
                                                  context: context,
                                                  message: SavedBiller![index]
                                                              .cATEGORYNAME ==
                                                          "Mobile Prepaid"
                                                      ? "You will no longer receive any notifications about the biller in future"
                                                      : "You will no longer receive any notifications about the biller in future and all auto pay setups would be disabled effectively from the next cycle",
                                                  message2: "",
                                                  message3: "",
                                                  title: "Alert!",
                                                  buttonName: "Delete",
                                                  isMultiBTN: true,
                                                  dialogHeight:
                                                      height(context) / 2.5,
                                                  buttonAction: () {
                                                    Navigator.pop(
                                                        context, true);

                                                    goToData(
                                                        context, otpRoute, {
                                                      "from": myBillRoute,
                                                      "templateName":
                                                          "delete-biller-otp",
                                                      "data": {
                                                        "bILLERNAME":
                                                            SavedBiller![index]
                                                                .bILLERNAME,
                                                        "cbid":
                                                            SavedBiller![index]
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
                                              child: const Text('Edit'),
                                            ),
                                            PopupMenuItem(
                                              value: 1,
                                              onTap: () => {},
                                              height: height(context) * 0.045,
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // trailing: IconButton(
                                      //     icon: const Icon(
                                      //       Icons.more_vert,
                                      //     ),
                                      //     // the method which is called
                                      //     // when button is pressed
                                      //     onPressed: () {
                                      //       showModalBottomSheet(
                                      //         context: context,
                                      //         shape:
                                      //             const RoundedRectangleBorder(
                                      //           borderRadius:
                                      //               BorderRadius.vertical(
                                      //             top:
                                      //                 Radius.circular(20.0),
                                      //           ),
                                      //         ),
                                      //         backgroundColor:
                                      //             primaryBodyColor,
                                      //         builder:
                                      //             (BuildContext context) {
                                      //           return SizedBox(
                                      //             child: Wrap(
                                      //               children: [
                                      //                 Container(
                                      //                     margin: EdgeInsets.only(
                                      //                         top: width(
                                      //                                 context) *
                                      //                             0.024,
                                      //                         left: width(
                                      //                                 context) *
                                      //                             0.044,
                                      //                         right: width(
                                      //                                 context) *
                                      //                             0.044),
                                      //                     child: Padding(
                                      //                       padding: EdgeInsets.symmetric(
                                      //                           horizontal:
                                      //                               width(context) *
                                      //                                   0.044),
                                      //                       child: Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .spaceBetween,
                                      //                         children: [
                                      //                           appText(
                                      //                             data:
                                      //                                 "Select Option",
                                      //                             size: width(
                                      //                                     context) *
                                      //                                 0.04,
                                      //                             color:
                                      //                                 primaryColor,
                                      //                             weight: FontWeight
                                      //                                 .bold,
                                      //                           ),
                                      //                           IconButton(
                                      //                             icon: Icon(
                                      //                                 Icons
                                      //                                     .close,
                                      //                                 color:
                                      //                                     primaryColor),
                                      //                             onPressed:
                                      //                                 () {
                                      //                               Navigator.pop(
                                      //                                   context);
                                      //                             },
                                      //                           )
                                      //                         ],
                                      //                       ),
                                      //                     )),
                                      //                 Divider(
                                      //                   thickness: 1,
                                      //                   endIndent: 16.0,
                                      //                   indent: 16.0,
                                      //                   color: divideColor,
                                      //                 ),
                                      //                 Padding(
                                      //                   padding: EdgeInsets
                                      //                       .symmetric(
                                      //                           horizontal:
                                      //                               width(context) *
                                      //                                   0.044),
                                      //                   child: ListTile(
                                      //                     leading: Icon(
                                      //                         Icons.edit,
                                      //                         color: Colors
                                      //                             .green),
                                      //                     title: appText(
                                      //                       data: "Edit",
                                      //                       size: width(
                                      //                               context) *
                                      //                           0.04,
                                      //                       color:
                                      //                           primaryColor,
                                      //                       weight:
                                      //                           FontWeight
                                      //                               .bold,
                                      //                     ),
                                      //                     onTap: () {
                                      //                       Navigator.pop(
                                      //                           context);
                                      //                       goToData(
                                      //                           context,
                                      //                           editBill,
                                      //                           {
                                      //                             "data": SavedBiller![
                                      //                                 index],
                                      //                           });
                                      //                     },
                                      //                   ),
                                      //                 ),
                                      //                 Padding(
                                      //                   padding: EdgeInsets
                                      //                       .symmetric(
                                      //                           horizontal:
                                      //                               width(context) *
                                      //                                   0.044),
                                      //                   child: ListTile(
                                      //                     leading: Icon(
                                      //                         Icons.delete,
                                      //                         color:
                                      //                             txtRejectColor),
                                      //                     title: appText(
                                      //                       data: "Delete",
                                      //                       size: width(
                                      //                               context) *
                                      //                           0.04,
                                      //                       color:
                                      //                           primaryColor,
                                      //                       weight:
                                      //                           FontWeight
                                      //                               .bold,
                                      //                     ),
                                      //                     onTap: () {
                                      //                       Navigator.pop(
                                      //                           context);
                                      //                       customDialogConsole(
                                      //                         context:
                                      //                             context,
                                      //                         message: SavedBiller![index]
                                      //                                     .cATEGORYNAME ==
                                      //                                 "Mobile Prepaid"
                                      //                             ? "You will no longer receive any notifications about the biller in future"
                                      //                             : "You will no longer receive any notifications about the biller in future and all auto pay setups would be disabled effectively from the next cycle",
                                      //                         message2: "",
                                      //                         message3: "",
                                      //                         title:
                                      //                             "Alert!",
                                      //                         buttonName:
                                      //                             "Delete",
                                      //                         isMultiBTN:
                                      //                             true,
                                      //                         dialogHeight:
                                      //                             height(context) /
                                      //                                 2.5,
                                      //                         buttonAction:
                                      //                             () {
                                      //                           // Navigator.pop(
                                      //                           //     context,
                                      //                           //     true);
                                      //                           goToData(
                                      //                               context,
                                      //                               otpRoute,
                                      //                               {
                                      //                                 "from":
                                      //                                     myBillRoute,
                                      //                                 "templateName":
                                      //                                     "delete-biller-otp",
                                      //                                 "data":
                                      //                                     {
                                      //                                   "bILLERNAME":
                                      //                                       SavedBiller![index].bILLERNAME,
                                      //                                   "cbid":
                                      //                                       SavedBiller![index].cUSTOMERBILLID.toString()
                                      //                                 }
                                      //                               });
                                      //                         },
                                      //                         iconSvg:
                                      //                             alertSvg,
                                      //                       );
                                      //                     },
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           );
                                      //         },
                                      //       );
                                      //     })),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                ]);
              })),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: width(context) * 0.024,
                  horizontal: width(context) * 0.044),
              child: appText(
                data: "All Billers",
                size: width(context) * 0.05,
                color: primaryColor,
                weight: FontWeight.bold,
              ),
            ),
            searchTxtController.text.isEmpty
                ? Expanded(
                    child: SizedBox(
                        height: showbane ? height(context) / 2.17 : null,
                        child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                          if (state is AllbillerLoading && state.isFirstFetch) {
                            allBillersLoading = true;
                          }
                          bool isLoading = false;
                          if (state is AllbillerLoading) {
                            Allbiller = state.prevData;
                            isLoading = true;
                          } else if (state is AllbillerSuccess) {
                            allBillersLoading = false;
                            Allbiller = state.allbillerList;
                            isLoading = false;
                          } else if (state is AllbillerFailed) {
                            allBillersLoading = false;
                            showSnackBar(state.message, context);
                          } else if (state is AllbillerError) {
                            goToUntil(context, splashRoute);
                          }

                          return allBillersLoading
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  height: height(context) / 3.1,
                                  child: Shimmer.fromColors(
                                    baseColor: divideColor,
                                    highlightColor: iconColor,
                                    child: ListView.builder(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      scrollDirection: Axis.vertical,
                                      // separatorBuilder: (_, __) => SizedBox(width: 15),
                                      itemCount: 16,
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: 0,
                                              bottom: width(context) * 0.020),
                                          child: Row(
                                            children: [
                                              ShimmerCell(
                                                  cellheight: 60.0,
                                                  cellwidth: 60),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ShimmerCell(
                                                      cellheight: 10.0,
                                                      cellwidth:
                                                          width(context) / 2),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: width(context) *
                                                            0.020),
                                                    child: ShimmerCell(
                                                        cellheight: 10.0,
                                                        cellwidth:
                                                            width(context) /
                                                                2.4),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Container(
                                  margin:
                                      EdgeInsets.all(width(context) * 0.024),
                                  decoration: BoxDecoration(
                                    color: primaryBodyColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Allbiller!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: Allbiller!.length +
                                              (isLoading ? 1 : 0),
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          controller: infiniteScrollController,
                                          itemBuilder: (context, index) {
                                            if (index < Allbiller!.length) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: txtColor),
                                                margin: EdgeInsets.only(
                                                  top: width(context) * 0.02,
                                                  right: width(context) * 0.02,
                                                  left: width(context) * 0.02,
                                                ),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        logConsole(
                                                            jsonEncode(
                                                                    Allbiller![
                                                                        index])
                                                                .toString(),
                                                            "Allbiller![index]");
                                                        if (Allbiller![index]
                                                            .cATEGORYNAME
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(
                                                                "mobile prepaid")) {
                                                          // if (baseUrl
                                                          //     .toString()
                                                          //     .toLowerCase()
                                                          //     .contains(
                                                          //         "digiservicesuat")) {
                                                          goToData(
                                                              context,
                                                              prepaidAddBillerRoute,
                                                              {
                                                                "id": widget.id,
                                                                "name": Allbiller![
                                                                        index]
                                                                    .cATEGORYNAME
                                                                    .toString(),
                                                                "billerData":
                                                                    Allbiller![
                                                                        index],
                                                                "isSavedBill":
                                                                    false
                                                              });
                                                          // } else {
                                                          //   customDialogConsole(
                                                          //       context:
                                                          //           context,
                                                          //       message:
                                                          //           "This is an upcoming feature.",
                                                          //       message2: "",
                                                          //       message3: "",
                                                          //       title: "Alert!",
                                                          //       buttonName:
                                                          //           "Okay",
                                                          //       dialogHeight:
                                                          //           height(context) /
                                                          //               2.5,
                                                          //       buttonAction:
                                                          //           () {
                                                          //         Navigator.pop(
                                                          //             context,
                                                          //             true);
                                                          //       },
                                                          //       iconSvg:
                                                          //           alertSvg);
                                                          // }
                                                        } else {
                                                          goToData(context,
                                                              addNewBill, {
                                                            "billerData":
                                                                Allbiller![
                                                                    index],
                                                          });
                                                        }
                                                      },
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            width(context) *
                                                                0.036,
                                                        vertical:
                                                            width(context) *
                                                                0.02,
                                                      ),
                                                      // leading: SvgPicture.asset(rupeeSvg,),

                                                      leading: Container(
                                                        width: width(context) *
                                                            0.13,
                                                        height:
                                                            height(context) *
                                                                0.06,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .bottomRight,
                                                                stops: [
                                                                  0.1,
                                                                  0.9
                                                                ],
                                                                colors: [
                                                                  Colors
                                                                      .deepPurple
                                                                      .withOpacity(
                                                                          .16),
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          .08)
                                                                ])),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SvgPicture
                                                                .asset(
                                                              BillerLogo(
                                                                  Allbiller![
                                                                          index]
                                                                      .bILLERNAME
                                                                      .toString(),
                                                                  Allbiller![
                                                                          index]
                                                                      .cATEGORYNAME
                                                                      .toString()),
                                                              height: height(
                                                                      context) *
                                                                  0.07,
                                                            )),
                                                      ),

                                                      title: Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                width(context) *
                                                                    0.006),
                                                        child: appText(
                                                          data:
                                                              Allbiller![index]
                                                                  .bILLERNAME,
                                                          size: width(context) *
                                                              0.04,
                                                          color:
                                                              txtSecondaryColor,
                                                        ),
                                                      ),
                                                      subtitle: Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                width(context) *
                                                                    0.006),
                                                        child: appText(
                                                          data: Allbiller![
                                                                  index]
                                                              .bILLERCOVERAGE!,
                                                          size: width(context) *
                                                              0.04,
                                                          color:
                                                              txtPrimaryColor,
                                                          maxline: 1,
                                                          weight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              Timer(
                                                  const Duration(
                                                      milliseconds: 10), () {
                                                infiniteScrollController.jumpTo(
                                                    infiniteScrollController
                                                        .position
                                                        .maxScrollExtent);
                                              });
                                              return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4),
                                                  height: 200,
                                                  child: Shimmer.fromColors(
                                                    baseColor: divideColor,
                                                    highlightColor: iconColor,
                                                    child: ListView.builder(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      // separatorBuilder: (_, __) => SizedBox(width: 15),
                                                      itemCount: 3,
                                                      itemBuilder: (_, index) {
                                                        return Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: width(
                                                                          context) *
                                                                      0.004),
                                                          child: Row(
                                                            children: [
                                                              ShimmerCell(
                                                                  cellheight:
                                                                      60.0,
                                                                  cellwidth:
                                                                      60),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ShimmerCell(
                                                                      cellheight:
                                                                          10.0,
                                                                      cellwidth:
                                                                          width(context) /
                                                                              2),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: width(context) *
                                                                            0.024),
                                                                    child: ShimmerCell(
                                                                        cellheight:
                                                                            10.0,
                                                                        cellwidth:
                                                                            width(context) /
                                                                                2.4),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ));
                                            }
                                          },
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              verticalSpacer(
                                                  width(context) * 0.04),
                                              SvgPicture.asset(alertSvg),
                                              verticalSpacer(
                                                  width(context) * 0.04),
                                              appText(
                                                  data: "No results found",
                                                  size: 16.6,
                                                  color: txtPrimaryColor)
                                            ],
                                          ),
                                        ),
                                );
                        })),
                  )
                : Expanded(
                    child: BlocConsumer<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state is BillersSearchLoading) {
                          if (!Loader.isShown) {
                            showLoader(context);
                          }
                        } else if (state is BillersSearchSuccess) {
                          BillerSearchResults = state.searchResultsData;
                          // if (BillerSearchResults!.isEmpty) alert = true;
                          int dataLength = state.searchResultsData != null
                              ? state.searchResultsData!.length
                              : 0;
                          BillersData newData;
                          setState(() {
                            AllbillerSearch = [];
                          });
                          if (dataLength > 0) {
                            List<BillersData>? AllbillerSearchTemp = [];

                            for (var billerData in BillerSearchResults!) {
                              Map<String, dynamic> eachData = {
                                "BILLER_ID": billerData.bILLERID,
                                "BILLER_NAME": billerData.bILLERNAME,
                                "BILLER_ICON": billerData.bILLERICON,
                                "BILLER_COVERAGE": billerData.bILLERCOVERAGE,
                                "BILLER_EFFECTIVE_FROM":
                                    billerData.bILLEREFFECTIVEFROM,
                                "BILLER_EFFECTIVE_TO":
                                    billerData.bILLEREFFECTIVETO,
                                "PAYMENT_EXACTNESS":
                                    billerData.pAYMENTEXACTNESS,
                                "BILLER_ACCEPTS_ADHOC":
                                    billerData.bILLERACCEPTSADHOC,
                                "FETCH_BILL_ALLOWED":
                                    billerData.fETCHBILLALLOWED,
                                "VALIDATE_BILL_ALLOWED":
                                    billerData.vALIDATEBILLALLOWED,
                                "FETCH_REQUIREMENT":
                                    billerData.fETCHREQUIREMENT,
                                "SUPPORT_BILL_VALIDATION":
                                    billerData.sUPPORTBILLVALIDATION,
                                "QUICK_PAY_ALLOWED": billerData.qUICKPAYALLOWED,
                                "CATEGORY_NAME": billerData.cATEGORYNAME,
                                "ROW_NUMBER": billerData.rOWNUMBER,
                                "TOTAL_PAGES": billerData.tOTALPAGES,
                                "START_POSITION": billerData.sTARTPOSITION,
                                "END_POSITION": billerData.eNDPOSITION,
                                "PAGE_SIZE": billerData.pAGESIZE,
                              };
                              newData = BillersData.fromJson(eachData);
                              AllbillerSearchTemp!.add(newData);
                            }
                            setState(() {
                              AllbillerSearch = AllbillerSearchTemp;
                            });
                            /*
                            for (int i = 0; i < dataLength; i++) {
                              Map<String, dynamic> eachData = {
                                "BILLER_ID": BillerSearchResults![i].bILLERID,
                                "BILLER_NAME": BillerSearchResults![i].bILLERNAME,
                                "BILLER_ICON": BillerSearchResults![i].bILLERICON,
                                "BILLER_COVERAGE":
                                    BillerSearchResults![i].bILLERCOVERAGE,
                                "BILLER_EFFECTIVE_FROM":
                                    BillerSearchResults![i].bILLEREFFECTIVEFROM,
                                "BILLER_EFFECTIVE_TO":
                                    BillerSearchResults![i].bILLEREFFECTIVETO,
                                "PAYMENT_EXACTNESS":
                                    BillerSearchResults![i].pAYMENTEXACTNESS,
                                "BILLER_ACCEPTS_ADHOC":
                                    BillerSearchResults![i].bILLERACCEPTSADHOC,
                                "FETCH_BILL_ALLOWED":
                                    BillerSearchResults![i].fETCHBILLALLOWED,
                                "VALIDATE_BILL_ALLOWED":
                                    BillerSearchResults![i].vALIDATEBILLALLOWED,
                                "FETCH_REQUIREMENT":
                                    BillerSearchResults![i].fETCHREQUIREMENT,
                                "SUPPORT_BILL_VALIDATION":
                                    BillerSearchResults![i].sUPPORTBILLVALIDATION,
                                "QUICK_PAY_ALLOWED":
                                    BillerSearchResults![i].qUICKPAYALLOWED,
                                "CATEGORY_NAME":
                                    BillerSearchResults![i].cATEGORYNAME,
                                "ROW_NUMBER": BillerSearchResults![i].rOWNUMBER,
                                "TOTAL_PAGES": BillerSearchResults![i].tOTALPAGES,
                                "START_POSITION":
                                    BillerSearchResults![i].sTARTPOSITION,
                                "END_POSITION":
                                    BillerSearchResults![i].eNDPOSITION,
                                "PAGE_SIZE": BillerSearchResults![i].pAGESIZE,
                              };
                              newData = BillersData.fromJson(eachData);
                              AllbillerSearch!.add(newData);
                            }
                            */
                          }
                          Loader.hide();
                        } else if (state is BillersSearchFailed) {
                          if (Loader.isShown) {
                            Loader.hide();
                          }
                          showSnackBar(state.message, context);
                        } else if (state is BillersSearchError) {
                          if (Loader.isShown) {
                            Loader.hide();
                          }
                          goToUntil(context, splashRoute);
                        }
                      },
                      builder: (context, state) {
                        return Container(
                            constraints: BoxConstraints(
                              minHeight: height(context) / 10,
                              maxHeight: height(context) / 1.5,
                            ),
                            margin: EdgeInsets.all(width(context) * 0.024),
                            decoration: BoxDecoration(
                              color: primaryBodyColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: AllbillerSearch!.isNotEmpty
                                ? ListView.builder(
                                    itemCount: AllbillerSearch!.length +
                                        (isLoading ? 1 : 0),
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    controller: infiniteScrollController,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: txtColor),
                                        margin: EdgeInsets.only(
                                          top: width(context) * 0.008,
                                          right: width(context) * 0.008,
                                          left: width(context) * 0.008,
                                        ),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                logConsole(
                                                    jsonEncode(AllbillerSearch![
                                                            index])
                                                        .toString(),
                                                    "AllbillerSearch![index]");
                                                if (AllbillerSearch![index]
                                                    .cATEGORYNAME
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(
                                                        "mobile prepaid")) {
                                                  // if (baseUrl
                                                  //     .toString()
                                                  //     .toLowerCase()
                                                  //     .contains(
                                                  //         "digiservicesuat")) {
                                                  goToData(context,
                                                      prepaidAddBillerRoute, {
                                                    "id": widget.id,
                                                    "name":
                                                        AllbillerSearch![index]
                                                            .cATEGORYNAME
                                                            .toString(),
                                                    "billerData":
                                                        AllbillerSearch![index],
                                                    "isSavedBill": false
                                                  });
                                                  // } else {
                                                  //   customDialogConsole(
                                                  //       context: context,
                                                  //       message:
                                                  //           "This is an upcoming feature.",
                                                  //       message2: "",
                                                  //       message3: "",
                                                  //       title: "Alert!",
                                                  //       buttonName: "Okay",
                                                  //       dialogHeight:
                                                  //           height(context) /
                                                  //               2.5,
                                                  //       buttonAction: () {
                                                  //         Navigator.pop(
                                                  //             context, true);
                                                  //       },
                                                  //       iconSvg: alertSvg);
                                                  // }
                                                } else {
                                                  goToData(
                                                      context, addNewBill, {
                                                    "billerData":
                                                        AllbillerSearch![index],
                                                  });
                                                }
                                              },
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal:
                                                    width(context) * 0.016,
                                                vertical:
                                                    width(context) * 0.001,
                                              ),
                                              // leading: SvgPicture.asset(rupeeSvg,),

                                              leading: Container(
                                                width: width(context) * 0.13,
                                                height: height(context) * 0.06,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .bottomRight,
                                                        stops: [
                                                          0.1,
                                                          0.9
                                                        ],
                                                        colors: [
                                                          Colors.deepPurple
                                                              .withOpacity(.16),
                                                          Colors.grey
                                                              .withOpacity(.08)
                                                        ])),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SvgPicture.asset(
                                                      BillerLogo(
                                                          AllbillerSearch![
                                                                  index]
                                                              .bILLERNAME
                                                              .toString(),
                                                          AllbillerSearch![
                                                                  index]
                                                              .cATEGORYNAME
                                                              .toString()),
                                                      // height: height(context) * 0.07,
                                                    )),
                                              ),

                                              title: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        width(context) * 0.006),
                                                child: appText(
                                                  data: AllbillerSearch![index]
                                                      .bILLERNAME,
                                                  size: width(context) * 0.04,
                                                  color: txtSecondaryColor,
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        width(context) * 0.006),
                                                child: appText(
                                                  data: AllbillerSearch![index]
                                                      .bILLERCOVERAGE!,
                                                  size: width(context) * 0.04,
                                                  color: txtPrimaryColor,
                                                  maxline: 1,
                                                  weight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                : SavedBiller!.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            verticalSpacer(
                                                width(context) * 0.04),
                                            SvgPicture.asset(alertSvg),
                                            verticalSpacer(
                                                width(context) * 0.04),
                                            appText(
                                                data: "No results found",
                                                size: 16.6,
                                                color: txtPrimaryColor)
                                          ],
                                        ),
                                      )
                                    : Container());
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
