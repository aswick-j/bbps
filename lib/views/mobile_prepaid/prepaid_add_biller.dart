import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../bloc/home/home_cubit.dart';
import '../../model/bbps_settings_model.dart';
import '../../model/biller_model.dart';
import '../../model/categories_model.dart';
import '../../model/input_signatures_model.dart';
import '../../model/prepaid_fetch_plans_model.dart';
import '../../model/saved_billers_model.dart';
import '../../model/states_data_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import 'prepaid_plan_item.dart';

class PrepaidAddBiller extends StatefulWidget {
  SavedBillersData? savedBillersData;
  BillersData? billerData;
  dynamic? id;
  bool isSavedBill;

  String name;
  PrepaidAddBiller(
      {Key? key,
      this.id,
      this.savedBillersData,
      this.billerData,
      required this.name,
      required this.isSavedBill});

  @override
  State<PrepaidAddBiller> createState() => _PrepaidAddBillerState();
}

class _PrepaidAddBillerState extends State<PrepaidAddBiller>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bbpsSettingsData? BbpsSettingInfo;
  List<BillersData>? Allbiller = [];
  List<StatesData>? statesData = [];
  List<PrepaidPlansData>? prepaidPlansData = [];
  List categoryList = [];
  bool? showPrepaidPlans;
  final inputTxtController = TextEditingController();
  dynamic operatorValue;
  bool? isLoading = true;
  PrepaidPlansData? selectedPrepaidPlan;
  String? selectedCircle;
  List<InputSignaturesData>? inputSignatureItems = [];
  List<CategorieData>? categoriesData = [];
  String? categoryId = "";
  String? mobileNumberValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inspect(widget.savedBillersData);
    // inspect(widget.billerData);
    log(jsonEncode(widget.savedBillersData),
        name: "received savedBillersData :::");
    if (widget.isSavedBill) {
      mobileNumberValue = widget.savedBillersData?.pARAMETERS!
          .firstWhere(
            (param) =>
                param.pARAMETERNAME.toString().toLowerCase() == 'mobile number',
          )
          .pARAMETERVALUE
          .toString();
      setState(() {
        operatorValue = widget.savedBillersData?.bILLERID;
        inputTxtController.text = mobileNumberValue!;
      });
    } else {
      setState(() {
        operatorValue = widget.billerData?.bILLERID;
        inputTxtController.text = "";
      });
    }

    /* setState(() {
      operatorValue = widget.isSavedBill
          ? widget.savedBillersData?.bILLERID
          : widget.billerData?.bILLERID;
      inputTxtController.text = widget.isSavedBill
          ? widget.savedBillersData!.pARAMETERS!
              .firstWhere(
                (param) => param.pARAMETERNAME == 'Mobile Number',
              )
              .pARAMETERVALUE!
              .toString() /* ; widget.savedBillersData!.pARAMETERVALUE.toString() */
          : '';
    }); */
    if (widget.id == null || widget.id.toString().isEmpty || widget.id == "") {
      BlocProvider.of<HomeCubit>(context).getAllCategories();
    } else {
      BlocProvider.of<HomeCubit>(context).getAllBiller(widget.id);
    }
    BlocProvider.of<HomeCubit>(context).fetchStatesData();
    BlocProvider.of<HomeCubit>(context).getBbpsSettings();

    if (widget.isSavedBill) {
      widget.savedBillersData!.pARAMETERS!.forEach((element) {
        if (element.pARAMETERNAME.toString().toLowerCase() == "circle") {
          setState(() {
            selectedCircle = element.pARAMETERVALUE;
          });
        }
      });

      fetchPrepaidFetchPlans(widget.savedBillersData!.bILLERID);
    } else {
      fetchPrepaidFetchPlans(widget.billerData!.bILLERID);
    }
  }

  updateSelectedPlan(PrepaidPlansData? selectedData) {
    setState(() {
      selectedPrepaidPlan = selectedData;
    });
    gotoConfirmpaymentScreen();
    log(selectedData.toString(), name: "SELECTED PLAN DATA:::");
  }

  gotoConfirmpaymentScreen() {
    if (widget.isSavedBill) {
      isSavedBillFrom = true;
      isMobilePrepaidFrom = true;
      goToData(context, confirmPaymentRoute, {
        "billID": widget.savedBillersData!.cUSTOMERBILLID,
        "name": widget.savedBillersData!.bILLERNAME,
        "number": widget.savedBillersData?.pARAMETERS!
            .firstWhere(
              (param) =>
                  param.pARAMETERNAME.toString().toLowerCase() ==
                  'mobile number',
            )
            .pARAMETERVALUE
            .toString(),
        "savedBillersData": widget.savedBillersData!,
        "isSavedBill": true,
        "selectedPrepaidPlan": selectedPrepaidPlan,
        "isMobilePrepaid": true,
        "selectedCircle": selectedCircle,
      });
    } else {
      final String? txtError = _validateTextField(inputTxtController.text);
      if (txtError == null) {
        // textfield is valid, do something
        final String? dropDownError = _validateDropDown(selectedCircle);
        if (dropDownError == null) {
          BlocProvider.of<HomeCubit>(context)
              .getInputSingnature(widget.billerData!.bILLERID);
          inspect(widget.billerData);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(dropDownError),
            ),
          );
        }
      } else {
        // display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(txtError),
          ),
        );
      }
    }
  }

  fetchPrepaidFetchPlans(dynamic billerId) {
    BlocProvider.of<HomeCubit>(context).fetchPrepaidFetchPlans(billerId);
  }

  handleCatgoryList() {
    var tempList = [];
    prepaidPlansData?.forEach((element) {
      if (!tempList.contains(element.categoryType!.toString())) {
        tempList.add(element.categoryType);
      }
    });
    tempList.insert(0, 'All');
    dynamic uniqueList =
        Map.fromEntries(tempList.map((e) => MapEntry(e.toLowerCase(), e)))
            .values
            .toList();

    setState(() {
      categoryList = uniqueList;
      _tabController = TabController(
          length: uniqueList.length, vsync: this, initialIndex: 0);
    });
  }

//  List<Widget>  getCategoryList() {
//   List<Widget> childs = [];
//   for (var i = 0; i < categoryList.length; i++) {
//     childs.add(new LisIn(' ' + categoryList[i]));
//   }
//   return childs;

// }
  String? _validateTextField(String value) {
    if (value.isEmpty) {
      return 'Please enter the mobile number';
    } else if (value.length < 10) {
      return 'Please enter the valid mobile number';
    }
    return null;
  }

  String? _validateDropDown(String? value) {
    // log(value!);
    if (value == null || value == "null") {
      return 'Please select the circle';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          data: "Mobile Prepaid",
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
              margin: EdgeInsets.all(5),
              width: width(context) / 5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bbpspngLogo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
        if (state is CategoriesLoading) {
        } else if (state is CategoriesSuccess) {
          categoriesData = state.CategoriesList;

          for (var element in categoriesData!) {
            if (element.cATEGORYNAME!
                .toLowerCase()
                .contains("mobile prepaid")) {
              setState(() {
                categoryId = element.iD.toString();
              });
              break;
            }
          }
          BlocProvider.of<HomeCubit>(context).getAllBiller(categoryId);
        } else if (state is CategoriesFailed) {
          showSnackBar(state.message, context);
        } else if (state is CategoriesError) {
          if (Loader.isShown) {
            Loader.hide();
          }
          goToUntil(context, splashRoute);
        } else if (state is BbpsSettingsLoading) {
        } else if (state is BbpsSettingsSuccess) {
          BbpsSettingInfo = state.BbpsSettingsDetails!.data;
        } else if (state is BbpsSettingsFailed) {
          if (Loader.isShown) {
            Loader.hide();
          }
          customDialog(
              title: "Alert!",
              message: state.message.toString(),
              message2: "",
              message3: "",
              buttonName: "Okay",
              dialogHeight: height(context) / 3,
              buttonAction: () {
                goBack(context);
                goBack(context);
              },
              context: context,
              iconSvg: alertSvg);
          showSnackBar(state.message, context);
        } else if (state is BbpsSettingsError) {
          if (Loader.isShown) {
            Loader.hide();
          }
          goToUntil(context, splashRoute);
        }

        if (state is AllbillerLoading) {
          showLoader(context);
        } else if (state is AllbillerSuccess) {
          Allbiller = state.allbillerList;
          Loader.hide();
        } else if (state is AllbillerFailed) {
          Loader.hide();

          showSnackBar(state.message, context);
        } else if (state is AllbillerError) {
          Loader.hide();

          goToUntil(context, splashRoute);
        } else if (state is StatesDataLoading) {
          showLoader(context);
        } else if (state is StatesDataSuccess) {
          statesData = state.statesData;
          Loader.hide();
        } else if (state is StatesDataFailed) {
          Loader.hide();

          showSnackBar(state.message, context);
        } else if (state is StatesDataError) {
          Loader.hide();

          goToUntil(context, splashRoute);
        } else if (state is PrepaidFetchPlansLoading) {
          showLoader(context);
        } else if (state is PrepaidFetchPlansSuccess) {
          prepaidPlansData = state.prepaidPlansData;
          if (prepaidPlansData!.isNotEmpty) {
            setState(() {
              isLoading = false;
              showPrepaidPlans = true;
            });
          } else {
            setState(() {
              isLoading = false;
              showPrepaidPlans = false;
            });
          }

          handleCatgoryList();
          log(categoryList.toString(), name: "handleCatgoryList ::::");
          Loader.hide();
        } else if (state is PrepaidFetchPlansFailed) {
          Loader.hide();
          setState(() {
            isLoading = false;
            showPrepaidPlans = false;
          });
          // showSnackBar(state.message, context);
        } else if (state is PrepaidFetchPlansError) {
          Loader.hide();
          setState(() {
            isLoading = false;
            showPrepaidPlans = false;
          });
          goToUntil(context, splashRoute);
        } else if (state is InputSignatureLoading) {
          showLoader(context);
        } else if (state is InputSignatureSuccess) {
          inputSignatureItems = state.InputSignatureList;
          inspect(inputSignatureItems);
          inspect(widget.billerData);
          isSavedBillFrom = false;
          isMobilePrepaidFrom = true;
          Loader.hide();
          goToData(context, confirmPaymentRoute, {
            "selectedPrepaidPlan": selectedPrepaidPlan,
            "isMobilePrepaid": true,
            "selectedCircle": selectedCircle,
            "mobileNumber": inputTxtController.text,
            "billName": "CHANGE_HERE",
            "billerData": widget.billerData,
            "inputSignatureItems": inputSignatureItems,
            "isSavedBill": false
          });
        } else if (state is InputSignatureFailed) {
          Loader.hide();

          showSnackBar(state.message, context);
        } else if (state is InputSignatureError) {
          Loader.hide();

          goToUntil(context, splashRoute);
        }
      }, builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0, top: 20.0),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: width(context) * 0.83,
                      height: height(context) * 0.08,
                      child: Center(
                        child: TextField(
                          controller: inputTxtController,
                          readOnly: widget.isSavedBill ? true : false,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          autocorrect: false,
                          maxLength: 10,
                          enableSuggestions: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9]*'))
                          ],
                          onChanged: (searchQuery) {},
                          decoration: InputDecoration(
                              filled: widget.isSavedBill ? true : false,
                              fillColor:
                                  widget.isSavedBill ? disableColor : null,
                              prefixIcon: Icon(
                                Icons.call_outlined,
                                color: txtCheckBalanceColor,
                              ),
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: "",
                              hintText: 'Enter Mobile Number',
                              hintStyle: TextStyle(
                                color: divideColor,
                                fontSize: width(context) * 0.045,
                                // color: primaryColor,contentPadding: EdgeInsets.symmetric(vertical: 40)
                                fontFamily: 'Rubik-Regular',
                              ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.blue),
                              // ),
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0)),
                          style: TextStyle(
                            // fontSize: 20,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: width(context) / 2.5,
                            child: Container(
                              height: height(context) * 0.055,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1, color: divideColor)
                                  ],
                                  color: txtColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  value: operatorValue,
                                  isDense: false,
                                  menuMaxHeight: height(context) * 0.5,
                                  itemHeight: 55,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.widgets_outlined,
                                        color: txtCheckBalanceColor,
                                      ),
                                      contentPadding: EdgeInsets.all(
                                          width(context) * 0.016),
                                      border: InputBorder.none),
                                  items: Allbiller!
                                      .map<DropdownMenuItem<String>>(
                                          (BillersData value) {
                                    return DropdownMenuItem<String>(
                                      value: value.bILLERID.toString(),
                                      child: Text(value.bILLERNAME.toString(),
                                          textScaleFactor: 1.0,
                                          overflow: TextOverflow.ellipsis),
                                      onTap: () {},
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  hint: Padding(
                                    padding: EdgeInsets.only(
                                      left: width(context) * 0.016,
                                    ),
                                    child: appText(
                                      data: "Operator",
                                      size: width(context) * 0.04,
                                      color: txtPrimaryColor,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  onChanged: widget.isSavedBill
                                      ? (value) {
                                          fetchPrepaidFetchPlans(value);
                                          // fetchPrepaidFetchPlans(value);
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width(context) / 2.5,
                            child: Container(
                              height: height(context) * 0.055,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 1, color: divideColor)
                                  ],
                                  color: txtColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  alignment: Alignment.center,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                  ),
                                  // value: widget.billerData!.bILLERID,
                                  isDense: false,
                                  menuMaxHeight: height(context) * 0.5,
                                  itemHeight: 55,
                                  value: widget.isSavedBill
                                      ? selectedCircle
                                      : null,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.location_on_outlined,
                                        color: txtCheckBalanceColor,
                                      ),
                                      contentPadding: EdgeInsets.all(
                                          width(context) * 0.016),
                                      border: InputBorder.none),
                                  items: statesData!
                                      .map<DropdownMenuItem<String>>(
                                          (StatesData value) {
                                    return DropdownMenuItem<String>(
                                      value: value.sTATENAME.toString(),
                                      child: Text(
                                        value.sTATENAME.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textScaleFactor: 1.0,
                                      ),
                                      onTap: () {},
                                    );
                                  }).toList(),
                                  isExpanded: true,
                                  hint: Padding(
                                    padding: EdgeInsets.only(
                                      left: width(context) * 0.016,
                                    ),
                                    child: appText(
                                      data: "Circle",
                                      size: width(context) * 0.04,
                                      color: txtPrimaryColor,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    print(value.toString());
                                    setState(() {
                                      selectedCircle = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: width(context) * 0.03,
                      ),
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
                                        HtmlWidget(BbpsSettingInfo!
                                            .tERMSANDCONDITIONS
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
                                fontFamily: appFont),
                            children: <TextSpan>[
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: 11, color: txtSecondaryColor),
                                  text: tcTextContent),
                              TextSpan(
                                text: tcText,
                                style: TextStyle(
                                    color: txtAmountColor,
                                    fontSize: 12,
                                    fontFamily: appFont),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showPrepaidPlans == true)
                TabBar(
                  physics: const BouncingScrollPhysics(),
                  dragStartBehavior: DragStartBehavior.start,
                  isScrollable: true,
                  indicatorColor: Colors.transparent,
                  labelStyle: TextStyle(
                      fontSize: width(context) * 0.04,
                      fontWeight: FontWeight.bold),
                  unselectedLabelColor: txtSecondaryColor,
                  labelColor: txtAmountColor,
                  controller: _tabController,
                  tabs: <Widget>[
                    for (var item in categoryList)
                      Tab(
                        text: item,
                      ),
                  ],
                ),
              if (showPrepaidPlans == true)
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        for (var item in categoryList)
                          PrepaidPlanItem(
                              categoryType: item,
                              prepaidPlansData: prepaidPlansData,
                              updateSelectedPlan: updateSelectedPlan),
                      ],
                    ),
                  ),
                ),
              if (showPrepaidPlans == false)
                Center(
                  heightFactor: height(context) * 0.032,
                  child: appText(
                      align: TextAlign.center,
                      data:
                          "Not able to fetch plans at the moment. Please try again",
                      size: width(context) * 0.035,
                      weight: FontWeight.w100,
                      color: txtPrimaryColor),
                ),
              if (isLoading == true)
                Center(
                  heightFactor: height(context) * 0.0097,
                  child: Image.asset(
                    "assets/images/loader.gif",
                    height: height(context) * 0.07,
                    width: height(context) * 0.07,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
