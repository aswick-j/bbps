import 'package:bbps/bloc/home/home_cubit.dart';
import 'package:bbps/model/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/shimmerCell.dart';

billCategory(
  img,
  name,
  id,
  context,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          // log(name.toString(), name: "category name ::::");
          // if (name.toString().toLowerCase().contains("mobile prepaid")) {
          //   if (baseUrl.toString().toLowerCase().contains("digiservicesuat")) {
          //     goToData(context, billFlowRoute, {
          //       "id": id,
          //       "name": name,
          //     });
          //   } else {
          //     customDialog(
          //         context: context,
          //         message: "This is an upcoming feature.",
          //         message2: "",
          //         message3: "",
          //         title: "Alert!",
          //         buttonName: "Okay",
          //         dialogHeight: height(context) / 2.5,
          //         buttonAction: () {
          //           Navigator.pop(context, true);
          //         },
          //         iconSvg: alertSvg);
          //   }
          // } else {
          goToData(context, billFlowRoute, {
            "id": id,
            "name": name,
          });
          // }
        },
        child: Container(
          width: width(context) * 0.13,
          height: height(context) * 0.06,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ], borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                CatLogo(img ?? "-"),
                // height: height(context) * 0.07,
              )),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(top: width(context) * 0.016),
          child: Column(
            children: [
              SizedBox(
                width: width(context) * 0.20,
                height: width(context) / 12,
                child: Text(
                  textAlign: TextAlign.center,
                  name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: width(context) * 0.03,
                    color: txtSecondaryDarkColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: appFont,
                  ),
                ),
              ),
            ],
          ))
    ],
  );
}

class BillCategory extends StatefulWidget {
  const BillCategory({Key? key}) : super(key: key);

  @override
  State<BillCategory> createState() => _BillCategoryState();
}

class _BillCategoryState extends State<BillCategory> {
  List<CategorieData>? categoriesData = [];
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<HomeCubit>(context).getAllCategories();
    // BlocProvider.of<HomeCubit>(context).getSavedBillers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is CategoriesLoading) {
        } else if (state is CategoriesSuccess) {
          categoriesData = state.CategoriesList;
        } else if (state is CategoriesFailed) {
          showSnackBar(state.message, context);
        } else if (state is CategoriesError) {
          if (Loader.isShown) {
            Loader.hide();
          }
          goToUntil(context, splashRoute);
        }
      },
      builder: (context, state) {
        return BillCategoryUI(
          categoriesData: categoriesData,
        );
      },
    );
  }
}

class BillCategoryUI extends StatefulWidget {
  List<CategorieData>? categoriesData;
  BillCategoryUI({Key? key, @required this.categoriesData}) : super(key: key);

  @override
  _BillCategoryUIState createState() => _BillCategoryUIState();
}

class _BillCategoryUIState extends State<BillCategoryUI> {
  @override
  Widget build(BuildContext context) {
    return widget.categoriesData!.isNotEmpty
        ? Container(
            width: width(context),
            color: primaryBodyColor,
            child: GridView(
              padding: EdgeInsets.only(
                top: height(context) * 0.008,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: height(context) * 0.014,
              ),
              physics: const BouncingScrollPhysics(),
              children: [
                for (int i = 0; i < widget.categoriesData!.length; i++)
                  billCategory(
                    widget.categoriesData![i].cATEGORYNAME.toString(),
                    widget.categoriesData![i].cATEGORYNAME,
                    widget.categoriesData![i].iD,
                    context,
                  ),
              ],
            ),
          )
        : Container(
            width: width(context),
            color: primaryBodyColor,
            child: GridView(
                padding: EdgeInsets.only(
                    top: width(context) * 0.044,
                    left: width(context) * 0.044,
                    bottom: width(context) * 0.064),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: height(context) * 0.014,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  for (int i = 0; i < 12; i++)
                    Shimmer.fromColors(
                        baseColor: dashColor,
                        highlightColor: divideColor,
                        child: ShimmerCell(cellheight: 55.0, cellwidth: 55.0))
                ]));
  }
}
