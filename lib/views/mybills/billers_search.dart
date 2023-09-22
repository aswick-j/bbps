import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/home/home_cubit.dart';
import '../../model/biller_model.dart';
import '../../model/billers_search_model.dart';
import '../../model/categories_model.dart';
import '../../model/saved_billers_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class BillersSearch extends StatefulWidget {
  const BillersSearch({super.key});

  @override
  State<BillersSearch> createState() => _BillersSearchState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _BillersSearchState extends State<BillersSearch> {
  final searchTxtController = TextEditingController();
  List<CategorieData>? categoriesList = [];
  List<String>? LocationList = [];
  List<String>? LocationListSmall = [];
  String _selectedCategory = "All";
  String _selectedLocation = "All";
  List<BillersData>? BillerSearchResults = [];
  List<SavedBillersData>? SavedBiller = [];
  List<SavedBillersData>? findSavedBiller = [];
  String lastSearchValue = "";

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getAllCategories();
    BlocProvider.of<HomeCubit>(context).getStateAndCities();
    BlocProvider.of<HomeCubit>(context).getSavedBillers();
    //Temporarily Im Setting Ms.Senthil
    BlocProvider.of<HomeCubit>(context)
        .searchBiller(" ", _selectedCategory, _selectedLocation);
    super.initState();
  }

  @override
  void dispose() {
    searchTxtController.dispose();
    if (Loader.isShown) {
      Loader.hide();
    }
    super.dispose();
  }

  searchData(searchTxt) {
    lastSearchValue = searchTxt;
    BlocProvider.of<HomeCubit>(context).searchBiller(
        searchTxtController.text, _selectedCategory, _selectedLocation);
    var temp = SavedBiller?.where((item) =>
        item.bILLNAME!
            .toLowerCase()
            .contains(searchTxtController.text.toLowerCase()) ||
        item.bILLERNAME!
            .toLowerCase()
            .contains(searchTxtController.text.toLowerCase())).toList();
    temp?.sort((a, b) {
      return b.bILLNAME.toString().compareTo(a.bILLNAME.toString());
    });

    setState(() {
      findSavedBiller = temp;
    });
    inspect(SavedBiller);
    inspect(findSavedBiller);
  }

  bool? alert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryBodyColor,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: txtAmountColor,
          ),
        ),
        backgroundColor: txtColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        actions: [
          SizedBox(
              width: width(context) * 0.97,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(left: width(context) / 7),
                child: TextField(
                  controller: searchTxtController,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-z0-9A-Z ]*'))
                  ],
                  onChanged: (searchQuery) {
                    if (lastSearchValue != searchQuery) {
                      searchData(searchQuery);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: ' Search..',
                    hintStyle: TextStyle(
                      color: divideColor,
                      fontSize: width(context) * 0.045,
                      // color: primaryColor,
                      fontFamily: 'Rubik-Regular',
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
              ))),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is CategoriesLoading) {
          } else if (state is CategoriesSuccess) {
            categoriesList = state.CategoriesList;
          } else if (state is CategoriesFailed) {
            showSnackBar(state.message, context);
          } else if (state is CategoriesError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
          if (state is LocationLoading) {
          } else if (state is LocationSuccess) {
            LocationList = state.LocationList;
            LocationListSmall = LocationList!
                .map((LocationList) => LocationList.toLowerCase())
                .toList();
          } else if (state is LocationFailed) {
            if (Loader.isShown) {
              Loader.hide();
            }
            showSnackBar(state.message, context);
          } else if (state is LocationError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }
          if (state is SavedBillerLoading) {
          } else if (state is SavedBillersSuccess) {
            SavedBiller = state.savedBillersData;
            findSavedBiller = state.savedBillersData;
          } else if (state is SavedBillersFailed) {
            showSnackBar(state.message, context);
          } else if (state is SavedBillersError) {
            if (Loader.isShown) {
              Loader.hide();
            }
            goToUntil(context, splashRoute);
          }

          if (state is BillersSearchLoading) {
            if (!Loader.isShown) {
              showLoader(context);
            }
          } else if (state is BillersSearchSuccess) {
            if (Loader.isShown) {
              Loader.hide();
            }
            BillerSearchResults = state.searchResultsData;
            if (BillerSearchResults!.isEmpty) alert = true;
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
          return categoriesList!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(width(context) * 0.010),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width(context) / 2.1,
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
                                    items: categoriesList!
                                        .map<DropdownMenuItem<String>>(
                                            (CategorieData value) {
                                      return DropdownMenuItem<String>(
                                        value: value.cATEGORYNAME.toString(),
                                        child: Text(
                                            value.cATEGORYNAME.toString(),
                                            overflow: TextOverflow.ellipsis),
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory =
                                                value.cATEGORYNAME.toString();
                                          });
                                        },
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    hint: Padding(
                                      padding: EdgeInsets.only(
                                        left: width(context) * 0.016,
                                      ),
                                      child: appText(
                                        data: "All",
                                        size: width(context) * 0.04,
                                        color: txtPrimaryColor,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      print(value.toString());
                                      setState(() {
                                        _selectedCategory = value!;
                                      });
                                      searchData(searchTxtController.text);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width(context) / 2.04,
                              child: Autocomplete<String>(optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                }

                                return LocationListSmall!
                                    .where((String option) {
                                  return option.contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              }, onSelected: (String selection) {
                                setState(() {
                                  _selectedLocation = selection;
                                });
                                searchData(searchTxtController.text);
                              }, fieldViewBuilder: (context, controller,
                                  focusNode, onEditingComplete) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onEditingComplete: onEditingComplete,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: width(context) * 0.004,
                                        left: width(context) * 0.020),
                                    fillColor: txtColor,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: divideColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: divideColor),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    hintText: "City/State",
                                    prefixIcon: Icon(Icons.location_on_outlined,
                                        color: txtCheckBalanceColor),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      !BillerSearchResults!.isNotEmpty && alert == true
                          ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  top: height(context) / 6,
                                  left: width(context) * 0.016,
                                  right: width(context) * 0.016),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: width(context) * 0.044,
                                        bottom: width(context) * 0.016),
                                    child: SvgPicture.asset(alertSvg),
                                  ),
                                  verticalSpacer(height(context) * 0.01),
                                  appText(
                                    data: "No Results Found",
                                    size: width(context) * 0.04,
                                    color: txtPrimaryColor,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                if (findSavedBiller!.isNotEmpty)
                                  Padding(
                                    padding:
                                        EdgeInsets.all(width(context) * 0.016),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.only(
                                                top: 7, left: 16),
                                            width: width(context),
                                            decoration: BoxDecoration(
                                              color: txtColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16),
                                                      topRight:
                                                          Radius.circular(16)),
                                            ),
                                            child: appText(
                                                data: "Saved Biller",
                                                size: width(context) * 0.05,
                                                weight: FontWeight.bold,
                                                align: TextAlign.left,
                                                color: primaryColor)),
                                        Container(
                                          constraints: BoxConstraints(
                                            minHeight: height(context) / 10,
                                            maxHeight: height(context) / 3.2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: txtColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                    bottomRight:
                                                        Radius.circular(16)),
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.all(
                                                width(context) * 0.013),
                                            width: width(context),
                                            decoration: BoxDecoration(
                                              color: primaryBodyColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    findSavedBiller!.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          width(context) *
                                                              0.008,
                                                      vertical: width(context) *
                                                          0.003,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: txtColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: ListTile(
                                                      onTap: () => goToData(
                                                          context, editBill, {
                                                        "data":
                                                            findSavedBiller![
                                                                index],
                                                      }),
                                                      dense: true,
                                                      visualDensity: VisualDensity
                                                          .adaptivePlatformDensity,
                                                      leading: Image.asset(
                                                        bNeumonic,
                                                        height:
                                                            height(context) *
                                                                0.07,
                                                      ),
                                                      title: appText(
                                                          data:
                                                              findSavedBiller![
                                                                      index]
                                                                  .bILLERNAME
                                                                  .toString(),
                                                          size: width(context) *
                                                              0.04,
                                                          color:
                                                              txtSecondaryColor,
                                                          weight:
                                                              FontWeight.w400),
                                                      subtitle: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            appText(
                                                              data:
                                                                  findSavedBiller![
                                                                          index]
                                                                      .bILLNAME,
                                                              size: width(
                                                                      context) *
                                                                  0.034,
                                                              color:
                                                                  txtPrimaryColor,
                                                              maxline: 1,
                                                            ),
                                                            appText(
                                                                data: findSavedBiller![
                                                                        index]
                                                                    .bILLERCOVERAGE,
                                                                size: width(
                                                                        context) *
                                                                    0.034,
                                                                color:
                                                                    txtPrimaryColor,
                                                                maxline: 1,
                                                                weight:
                                                                    FontWeight
                                                                        .w600)
                                                          ]),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                if (BillerSearchResults!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width(context) * 0.016,
                                        top: width(context) * 0.016),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: width(context) * 0.02,
                                              left: width(context) * 0.04,
                                              bottom: 2),
                                          width: width(context),
                                          decoration: BoxDecoration(
                                            color: txtColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16)),
                                          ),
                                          child: appText(
                                              data: "Add New Biller",
                                              size: width(context) * 0.05,
                                              weight: FontWeight.bold,
                                              align: TextAlign.left,
                                              color: primaryColor),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: txtColor,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                    bottomRight:
                                                        Radius.circular(16)),
                                          ),
                                          constraints: BoxConstraints(
                                            //   minHeight: height(context) / 10,
                                            //   maxHeight: height(context) / 1,
                                            // ),
                                            maxHeight: findSavedBiller!.isEmpty
                                                ? height(context) / 1.3
                                                : findSavedBiller!.length == 1
                                                    ? height(context) / 1.6
                                                    : findSavedBiller!.length ==
                                                            2
                                                        ? height(context) / 1.8
                                                        : findSavedBiller!
                                                                    .length ==
                                                                3
                                                            ? height(context) /
                                                                2.2
                                                            : findSavedBiller!
                                                                        .length >
                                                                    3
                                                                ? height(
                                                                        context) /
                                                                    2.48
                                                                : height(
                                                                        context) /
                                                                    1.41,
                                          ),
                                          // height: findSavedBiller!.isEmpty
                                          //     ? height(context) / 1.3
                                          //     : height(context) / 1.41,
                                          child: Container(
                                            margin: EdgeInsets.all(
                                                width(context) * 0.013),
                                            width: width(context),
                                            decoration: BoxDecoration(
                                              color: primaryBodyColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ScrollConfiguration(
                                              behavior: MyBehavior(),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    BillerSearchResults!.length,
                                                itemBuilder: (context, index) =>
                                                    Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        width(context) * 0.008,
                                                    vertical:
                                                        width(context) * 0.003,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: txtColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: ListTile(
                                                    onTap: () {
                                                      if (BillerSearchResults![
                                                              index]
                                                          .cATEGORYNAME
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(
                                                              "mobile prepaid")) {
                                                        if (baseUrl
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(
                                                                "digiservicesuat")) {
                                                          goToData(
                                                              context,
                                                              prepaidAddBillerRoute,
                                                              {
                                                                "id": "",
                                                                "name": BillerSearchResults![
                                                                        index]
                                                                    .cATEGORYNAME
                                                                    .toString(),
                                                                "billerData":
                                                                    BillerSearchResults![
                                                                        index],
                                                                "isSavedBill":
                                                                    false
                                                              });
                                                        } else {
                                                          customDialog(
                                                              context: context,
                                                              message:
                                                                  "This is an upcoming feature.",
                                                              message2: "",
                                                              message3: "",
                                                              title: "Alert!",
                                                              buttonName:
                                                                  "Okay",
                                                              dialogHeight:
                                                                  height(context) /
                                                                      2.5,
                                                              buttonAction: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                              iconSvg:
                                                                  alertSvg);
                                                        }
                                                      } else {
                                                        inspect(
                                                            BillerSearchResults![
                                                                index]);
                                                        log(
                                                            jsonEncode(
                                                                BillerSearchResults![
                                                                    index]),
                                                            name:
                                                                "BillerSearchResults![index");
                                                        goToData(context,
                                                            addNewBill, {
                                                          "billerData":
                                                              BillerSearchResults![
                                                                  index],
                                                        });
                                                      }
                                                    },
                                                    dense: true,
                                                    visualDensity: VisualDensity
                                                        .adaptivePlatformDensity,
                                                    leading: Image.asset(
                                                      bNeumonic,
                                                      height: height(context) *
                                                          0.07,
                                                    ),
                                                    title: appText(
                                                        data:
                                                            BillerSearchResults![
                                                                    index]
                                                                .bILLERNAME
                                                                .toString(),
                                                        size: width(context) *
                                                            0.04,
                                                        color:
                                                            txtSecondaryColor,
                                                        weight:
                                                            FontWeight.w400),
                                                    subtitle: appText(
                                                        data:
                                                            BillerSearchResults![
                                                                    index]
                                                                .bILLERCOVERAGE,
                                                        size: width(context) *
                                                            0.04,
                                                        color: txtPrimaryColor,
                                                        maxline: 1,
                                                        weight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            )
                    ],
                  ),
                )
              : Center(
                  child: Image.asset(
                    "assets/images/loader.gif",
                    height: height(context) * 0.07,
                    width: height(context) * 0.07,
                  ),
                );
        },
      ),
    );
  }
}
