import 'dart:convert';

import 'package:bbps/bloc/complaint/complaint_cubit.dart';
import 'package:bbps/model/complaints_config_model.dart';
import 'package:bbps/views/complaints/transaction_item_radio_btn.dart';
import 'package:bbps/widgets/complaint_shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/history_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';

class ComplaintThisWeekTxns extends StatefulWidget {
  const ComplaintThisWeekTxns({Key? key}) : super(key: key);

  @override
  State<ComplaintThisWeekTxns> createState() => _ComplaintThisWeekTxnsState();
}

class _ComplaintThisWeekTxnsState extends State<ComplaintThisWeekTxns> {
  List<HistoryData>? historyData = [];
  List<ComplaintTransactionDurations>? complaint_transaction_durations = [];
  List<ComplaintTransactionReasons>? complaint_transaction_reasons = [];
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ComplaintCubit>(context).getHistoryDetails('This Week');

    BlocProvider.of<ComplaintCubit>(context).getComplaintConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: txtColor,
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintTransactionLoading) {
          } else if (state is ComplaintTransactionSuccess) {
            // Listing all transactions
            // historyData = state.transactionList;

            //Avoid listing failed transaction
            historyData = state.transactionList;
            logInfo(jsonEncode(historyData));
            // ?.where((element) => !element.tRANSACTIONSTATUS!
            //     .toLowerCase()
            //     .contains("failed"))
            // .toList();
          } else if (state is ComplaintTransactionFailed) {
            showSnackBar(state.message, context);
          } else if (state is ComplaintTransactionError) {
            goToUntil(context, splashRoute);
          }
          if (state is ComplaintConfigLoading) {
          } else if (state is ComplaintConfigSuccess) {
            complaint_transaction_durations =
                state.ComplaintConfigList!.complaintTransactionDurations;
            complaint_transaction_reasons =
                state.ComplaintConfigList!.complaintTransactionReasons;
          } else if (state is ComplaintConfigFailed) {
            showSnackBar(state.message, context);
          } else if (state is ComplaintConfigError) {
            goToUntil(context, splashRoute);
          }
        },
        builder: (context, state) {
          if (state is ComplaintTransactionLoading ||
              state is ComplaintConfigLoading) {
            return const ComplaintShimmerEffect();
          }
          return ComplaintThisWeekTxnsUI(
              historyData: historyData,
              CT_durations: complaint_transaction_durations,
              CT_reasons: complaint_transaction_reasons);
        },
      ),
    );
  }
}

class ComplaintThisWeekTxnsUI extends StatefulWidget {
  List<HistoryData>? historyData;
  List<ComplaintTransactionReasons>? CT_reasons;
  List<ComplaintTransactionDurations>? CT_durations;
  ComplaintThisWeekTxnsUI(
      {Key? key,
      @required this.historyData,
      @required this.CT_durations,
      @required this.CT_reasons})
      : super(key: key);

  @override
  State<ComplaintThisWeekTxnsUI> createState() =>
      _ComplaintThisWeekTxnsUIState();
}

class _ComplaintThisWeekTxnsUIState extends State<ComplaintThisWeekTxnsUI> {
  int? SelectedTransaction;
  bool isButtonActive = false;
  updateRadioBtn(value) {
    setState(() {
      SelectedTransaction = value;
      isButtonActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.historyData!.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width(context) * 0.044),
                child: Row(
                  children: [
                    appText(
                        data: "Select Transaction",
                        size: width(context) * 0.056,
                        color: txtPrimaryColor,
                        weight: FontWeight.bold),
                    horizondalSpacer(3),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.historyData!.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => TransactionItemRadioBtn(
                      historyData: widget.historyData,
                      index: index,
                      SelectedTxns: SelectedTransaction,
                      updatedRadioBtn: updateRadioBtn),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: double.infinity),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: primaryBodyColor,
                ),
                margin: EdgeInsets.only(
                  left: width(context) * 0.044,
                  top: width(context) * 0.044,
                  right: width(context) * 0.044,
                  bottom: width(context) * 0.016,
                ),
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
                                data: "  Note",
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
                              "Complaints can be registered for transactions done within the last 90 days.",
                          size: width(context) * 0.032,
                          color: txtSecondaryColor,
                          maxline: 5,
                          weight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: myAppButton(
                    context: context,
                    margin: EdgeInsets.symmetric(
                      vertical: width(context) * 0.032,
                      horizontal: width(context) * 0.044,
                    ),
                    buttonName: "Next",
                    onpress: isButtonActive
                        ? () {
                            goToData(context, complaintRegisterRoute, {
                              "data": widget
                                  .historyData![SelectedTransaction!.toInt()],
                              "reasons": widget.CT_reasons
                            });
                          }
                        : null),
              ),
            ],
          )
        : Center(
            child: appText(
                data: "No Transaction Found",
                size: width(context) * 0.04,
                color: txtHintColor),
          );
  }
}
