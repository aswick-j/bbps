import 'package:bbps/bloc/complaint/complaint_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/complaints_config_model.dart';
import '../../model/history_model.dart';
import '../../model/transection_model.dart';
import '../../utils/commen.dart';
import '../../utils/const.dart';
import '../../utils/utils.dart';
import '../../widgets/shimmerCell.dart';

class NewComplaint extends StatefulWidget {
  const NewComplaint({Key? key}) : super(key: key);

  @override
  State<NewComplaint> createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {
  List<HistoryData>? transactionList = [];
  List<ComplaintTransactionDurations>? complaint_transaction_durations = [];
  List<ComplaintTransactionReasons>? complaint_transaction_reasons = [];
  @override
  void initState() {
    BlocProvider.of<ComplaintCubit>(context).getAllTransactions();
    BlocProvider.of<ComplaintCubit>(context).getComplaintConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ComplaintCubit, ComplaintState>(
        listener: (context, state) {
          if (state is ComplaintTransactionLoading) {
          } else if (state is ComplaintTransactionSuccess) {
            transactionList = state.transactionList;
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
          return NewComplaintUI(
              transactionList: transactionList,
              CT_durations: complaint_transaction_durations,
              CT_reasons: complaint_transaction_reasons);
        },
      ),
    );
  }
}

class NewComplaintUI extends StatefulWidget {
  List<HistoryData>? transactionList;
  List<ComplaintTransactionDurations>? CT_durations;
  List<Map<String, dynamic>>? AllTransections = [
    {
      "TRANSACTION_ID": 784,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 9612.1,
      "COMPLETION_DATE": "2022-07-28T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-failed",
      "BILLER_ID": "BHIM00000NAT03",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "7977563530",
      "EQUITAS_TRANSACTION_ID": "7a46a268-04a3-41d7-844c-abe491b3e2b7",
      "BILLER_NAME": "BHIM Biller 003",
      "CATEGORY_NAME": "Mobile Postpaid",
      "CATEGORY_ID": "Mobile Postpaid",
      "CUSTOMER_BILL_ID": 921,
      "BILL_NAME": "AIRTEL POSTPAID",
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": "Account No",
      "PARAMETER_VALUE": "123",
      "AUTOPAY_ID": 221,
      "ROW_NUMBER": 2,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": "Account No", "PARAMETER_VALUE": "123"},
        {"PARAMETER_NAME": "Mobile Number", "PARAMETER_VALUE": "7977563530"},
        {"PARAMETER_NAME": "Account No", "PARAMETER_VALUE": "123"},
        {"PARAMETER_NAME": "Mobile Number", "PARAMETER_VALUE": "7977563530"}
      ]
    },
    {
      "TRANSACTION_ID": 788,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 7749.2,
      "COMPLETION_DATE": "2022-07-28T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-failed",
      "BILLER_ID": "BHIM00000NAT10",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "1234567890",
      "EQUITAS_TRANSACTION_ID": "6b0d8a19-2236-43bd-ba2e-39f6de3b7eb8",
      "BILLER_NAME": "BHIM Biller 10",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": 943,
      "BILL_NAME": "10",
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": "BU",
      "PARAMETER_VALUE": "1234567890",
      "AUTOPAY_ID": 251,
      "ROW_NUMBER": 5,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": "BU", "PARAMETER_VALUE": "1234567890"},
        {"PARAMETER_NAME": "Consumer No", "PARAMETER_VALUE": "12345"}
      ]
    },
    {
      "TRANSACTION_ID": 721,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 4327.92,
      "COMPLETION_DATE": "2022-07-28T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-failed",
      "BILLER_ID": "BHIM00000NAT04",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "11111",
      "EQUITAS_TRANSACTION_ID": "10bac806-b26e-4205-ac7e-fb6969684339",
      "BILLER_NAME": "BHIM Biller 004",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 7,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 763,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211321000000297017",
      "BILL_AMOUNT": 7678.58,
      "COMPLETION_DATE": "2022-07-28T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT02",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "9884358125",
      "CUSTOMER_NAME": "MR. Swapnil Dhande",
      "APPROVAL_REF_NO": "20211117184321",
      "FEE": "0",
      "BILL_NUMBER": "4551321544",
      "EQUITAS_TRANSACTION_ID": "7cfad2dd-3966-45a0-9b89-1467bb6de92b",
      "BILLER_NAME": "BHIM Biller 002",
      "CATEGORY_NAME": "DTH",
      "CATEGORY_ID": "DTH",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 8,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 781,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211323000000297987",
      "BILL_AMOUNT": 9612.1,
      "COMPLETION_DATE": "2022-07-28T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT03",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "9884358125",
      "CUSTOMER_NAME": "MR. Amol Jagtap",
      "APPROVAL_REF_NO": "20211119174321",
      "FEE": "0",
      "BILL_NUMBER": "7977563530",
      "EQUITAS_TRANSACTION_ID": "a730753b-bdb3-4758-a785-78df0c216dc2",
      "BILLER_NAME": "BHIM Biller 003",
      "CATEGORY_NAME": "Mobile Postpaid",
      "CATEGORY_ID": "Mobile Postpaid",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 9,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 742,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211320000000296371",
      "BILL_AMOUNT": 7863.56,
      "COMPLETION_DATE": "2022-07-27T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "TELECOM00NAT01",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "7977563530",
      "CUSTOMER_NAME": "MR. Amol Jagtap",
      "APPROVAL_REF_NO": "20211116200514",
      "FEE": "0",
      "BILL_NUMBER": "52156",
      "EQUITAS_TRANSACTION_ID": "178e6258-92ee-4a75-a8be-50cf0a7b5c9a",
      "BILLER_NAME": "Air Voice",
      "CATEGORY_NAME": "Mobile Postpaid",
      "CATEGORY_ID": "Mobile Postpaid",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 11,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 702,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211299000000293641",
      "BILL_AMOUNT": 1421.83,
      "COMPLETION_DATE": "2022-07-26T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT04",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "9884358125",
      "CUSTOMER_NAME": "MR. Sibsankar Debnath",
      "APPROVAL_REF_NO": "20211026164453",
      "FEE": "0",
      "BILL_NUMBER": "11111",
      "EQUITAS_TRANSACTION_ID": "b3ecda85-6763-428d-aa49-84b559b784fd",
      "BILLER_NAME": "BHIM Biller 004",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 12,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 743,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211320000000296377",
      "BILL_AMOUNT": 9507.44,
      "COMPLETION_DATE": "2022-07-25T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT03",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "7977563530",
      "CUSTOMER_NAME": "MR. Arnab Moitra",
      "APPROVAL_REF_NO": "20211116200907",
      "FEE": "0",
      "BILL_NUMBER": "7977563530",
      "EQUITAS_TRANSACTION_ID": "408fd278-4cf8-4af6-9f59-7d115014b022",
      "BILLER_NAME": "BHIM Biller 003",
      "CATEGORY_NAME": "Mobile Postpaid",
      "CATEGORY_ID": "Mobile Postpaid",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 13,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 701,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211299000000293635",
      "BILL_AMOUNT": 254.81,
      "COMPLETION_DATE": "2022-07-25T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT02",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "9884358125",
      "CUSTOMER_NAME": "MR. Manoj Bhoir",
      "APPROVAL_REF_NO": "20211026163341",
      "FEE": "0",
      "BILL_NUMBER": "1234543",
      "EQUITAS_TRANSACTION_ID": "dfc4e6f0-17de-44c2-aad0-088857fa598f",
      "BILLER_NAME": "BHIM Biller 002",
      "CATEGORY_NAME": "DTH",
      "CATEGORY_ID": "DTH",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 14,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 786,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 4343.07,
      "COMPLETION_DATE": "2022-06-23T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-response-unknown",
      "BILLER_ID": "TELECOM00NAT01",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "52156",
      "EQUITAS_TRANSACTION_ID": "82acc6d7-5a80-49c0-b2d7-9734a94acfc5",
      "BILLER_NAME": "Air Voice",
      "CATEGORY_NAME": "Mobile Postpaid",
      "CATEGORY_ID": "Mobile Postpaid",
      "CUSTOMER_BILL_ID": 901,
      "BILL_NAME": "BHIM Biller",
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": "Customer Reference Field 2",
      "PARAMETER_VALUE": "52156ABC",
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 15,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {
          "PARAMETER_NAME": "Customer Reference Field 2",
          "PARAMETER_VALUE": "52156ABC"
        },
        {
          "PARAMETER_NAME": "Customer Reference Field 1",
          "PARAMETER_VALUE": "52156"
        }
      ]
    },
    {
      "TRANSACTION_ID": 787,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 7749.2,
      "COMPLETION_DATE": "2022-06-23T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-failed",
      "BILLER_ID": "BHIM00000NAT10",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "1234567890",
      "EQUITAS_TRANSACTION_ID": "04bcba09-4c40-4b06-8623-176001706c64",
      "BILLER_NAME": "BHIM Biller 10",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": 943,
      "BILL_NAME": "10",
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": "BU",
      "PARAMETER_VALUE": "1234567890",
      "AUTOPAY_ID": 251,
      "ROW_NUMBER": 16,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": "BU", "PARAMETER_VALUE": "1234567890"},
        {"PARAMETER_NAME": "Consumer No", "PARAMETER_VALUE": "12345"}
      ]
    },
    {
      "TRANSACTION_ID": 801,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211344000000302445",
      "BILL_AMOUNT": 2709.64,
      "COMPLETION_DATE": "2022-06-23T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT04",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "7977563530",
      "CUSTOMER_NAME": "MR. Prabodh Bohra",
      "APPROVAL_REF_NO": "20211210131539",
      "FEE": "0",
      "BILL_NUMBER": "11111",
      "EQUITAS_TRANSACTION_ID": "7433d4d8-1397-420d-be39-f2915ea5d414",
      "BILLER_NAME": "BHIM Biller 004",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 18,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 804,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211344000000312456",
      "BILL_AMOUNT": 1987.3,
      "COMPLETION_DATE": "2022-06-23T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT10",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "9884358125",
      "CUSTOMER_NAME": "MR. Prabodh Bohra",
      "APPROVAL_REF_NO": "20211210132540",
      "FEE": "0",
      "BILL_NUMBER": "12345",
      "EQUITAS_TRANSACTION_ID": "7433d4d8-1397-420d-be39-f2915ea5de14",
      "BILLER_NAME": "BHIM Biller 10",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": 943,
      "BILL_NAME": "10",
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": "BU",
      "PARAMETER_VALUE": "1234567890",
      "AUTOPAY_ID": 251,
      "ROW_NUMBER": 19,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": "BU", "PARAMETER_VALUE": "1234567890"},
        {"PARAMETER_NAME": "Consumer No", "PARAMETER_VALUE": "12345"}
      ]
    },
    {
      "TRANSACTION_ID": 785,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 119.42,
      "COMPLETION_DATE": "2022-06-23T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-failed",
      "BILLER_ID": "TELECOM00NAT01",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "122222",
      "EQUITAS_TRANSACTION_ID": "2286ec7e-7fbb-4890-989c-6072e214ba85",
      "BILLER_NAME": "Air Voice",
      "CATEGORY_NAME": "Mobile Postpaid",
      "CATEGORY_ID": "Mobile Postpaid",
      "CUSTOMER_BILL_ID": 962,
      "BILL_NAME": "T2",
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": "Customer Reference Field 1",
      "PARAMETER_VALUE": "122222",
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 21,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {
          "PARAMETER_NAME": "Customer Reference Field 1",
          "PARAMETER_VALUE": "122222"
        },
        {
          "PARAMETER_NAME": "Customer Reference Field 2",
          "PARAMETER_VALUE": "121212121"
        }
      ]
    },
    {
      "TRANSACTION_ID": 764,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": "EQ211321000000297155",
      "BILL_AMOUNT": 3045.48,
      "COMPLETION_DATE": "2022-06-23T18:30:00.000Z",
      "TRANSACTION_STATUS": "success",
      "BILLER_ID": "BHIM00000NAT10",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": "Internet Banking",
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": "9884358125",
      "CUSTOMER_NAME": "MR. Sibsankar Debnath",
      "APPROVAL_REF_NO": "20211117191323",
      "FEE": "0",
      "BILL_NUMBER": "1234567890",
      "EQUITAS_TRANSACTION_ID": "a20f80a0-1f33-4ec6-8b3d-33a7c7975086",
      "BILLER_NAME": "BHIM Biller 10",
      "CATEGORY_NAME": "Health Insurance",
      "CATEGORY_ID": "Health Insurance",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 22,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    },
    {
      "TRANSACTION_ID": 722,
      "CUSTOMER_ID": "7738591",
      "TRANSACTION_REFERENCE_ID": null,
      "BILL_AMOUNT": 1549.63,
      "COMPLETION_DATE": "2022-07-29T18:30:00.000Z",
      "TRANSACTION_STATUS": "aggregator-failed",
      "BILLER_ID": "BHIM00000NAT02",
      "PAYMENT_CHANNEL": "IB",
      "PAYMENT_MODE": null,
      "ACCOUNT_NUMBER": "100002396268",
      "MOBILE_NUMBER": null,
      "CUSTOMER_NAME": null,
      "APPROVAL_REF_NO": null,
      "FEE": null,
      "BILL_NUMBER": "7777777",
      "EQUITAS_TRANSACTION_ID": "a51cd276-fce1-452e-8cdb-db379e75d366",
      "BILLER_NAME": "BHIM Biller 002",
      "CATEGORY_NAME": "DTH",
      "CATEGORY_ID": "DTH",
      "CUSTOMER_BILL_ID": null,
      "BILL_NAME": null,
      "BILLER_ACCEPTS_ADHOC": "N",
      "PARAMETER_NAME": null,
      "PARAMETER_VALUE": null,
      "AUTOPAY_ID": null,
      "ROW_NUMBER": 1,
      "TOTAL_PAGES": 1,
      "START_POSITION": 1,
      "END_POSITION": 50,
      "PAGE_SIZE": 50,
      "PARAMETERS": [
        {"PARAMETER_NAME": null, "PARAMETER_VALUE": null}
      ]
    }
  ];
  List<ComplaintTransactionReasons>? CT_reasons;
  NewComplaintUI(
      {Key? key,
      @required this.transactionList,
      @required this.CT_durations,
      @required this.CT_reasons})
      : super(key: key);

  @override
  State<NewComplaintUI> createState() => _NewComplaintUIState();
}

int? SelectedTransection;
bool isButtonActive = false;
String SelectedDuration = "Today";

class _NewComplaintUIState extends State<NewComplaintUI> {
  @override
  void initState() {
    super.initState();
    // SelectedDuration = widget.CT_durations![0].dURATION.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: txtColor,
      appBar: myAppBar(
        context: context,
        title: "Register Complaints",
      ),
      body: Column(
        children: [
          widget.CT_durations!.isNotEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  alignment: Alignment.centerLeft,
                  height: height(context) * 0.1,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: SelectedDuration,
                    icon: const Icon(Icons.filter_alt),
                    elevation: 6,
                    style: TextStyle(color: txtPrimaryColor),
                    underline: Container(
                      height: 2,
                      color: txtAmountColor,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        SelectedDuration = value!;
                      });
                    },
                    items: widget.CT_durations!.map<DropdownMenuItem<String>>(
                        (ComplaintTransactionDurations value) {
                      return DropdownMenuItem<String>(
                        value: value.dURATION,
                        child: Text(DropdownLable(value.dURATION.toString())),
                      );
                    }).toList(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Shimmer.fromColors(
                            baseColor: dashColor,
                            highlightColor: divideColor,
                            child: ShimmerCell(
                                cellheight: 15.0,
                                cellwidth: width(context) / 1.4)),
                        Shimmer.fromColors(
                            baseColor: dashColor,
                            highlightColor: divideColor,
                            child:
                                ShimmerCell(cellheight: 30.0, cellwidth: 30.0))
                      ]),
                ),
          divideLine(),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: widget.AllTransections!.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) => Column(
                    children: [
                      RadioListTile(
                          value: index,
                          groupValue: SelectedTransection,
                          activeColor: txtAmountColor,
                          secondary: Image.asset(
                            BLogo,
                            height: height(context) * 0.07,
                          ),
                          title: Row(children: [
                            appText(
                                data: widget.AllTransections![index]
                                    ['BILLER_NAME'],
                                maxline: 1,
                                size: width(context) * 0.034,
                                color: txtSecondaryDarkColor),
                            SizedBox(
                              width: 3,
                            ),
                            appText(
                                data:
                                    '(${widget.AllTransections![index]['CATEGORY_NAME']})',
                                size: width(context) * 0.024,
                                maxline: 1,
                                color: txtSecondaryDarkColor)
                          ]),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  // color: Colors.blue,
                                  width: width(context) * 0.3,
                                  child: Row(
                                    children: [
                                      appText(
                                          data: widget.AllTransections![index]
                                                  ['BILL_AMOUNT']
                                              .toString(),
                                          size: width(context) * 0.04,
                                          color: txtPrimaryColor,
                                          weight: FontWeight.bold),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      widget.AllTransections![index]
                                                  ['TRANSACTION_STATUS'] ==
                                              "success"
                                          ? Icon(
                                              Icons.cancel_outlined,
                                              color: alertFailedColor,
                                              size: width(context) * 0.05,
                                            )
                                          : Icon(
                                              Icons.check_circle_rounded,
                                              color: alertSuccessColor,
                                              size: width(context) * 0.05,
                                            ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  // color: Colors.yellow,
                                  width: width(context) * 0.24,
                                  child: Tooltip(
                                    message: widget.AllTransections![index]
                                        ['COMPLETION_DATE'],
                                    child: appText(
                                        data: widget.AllTransections![index]
                                                    ['COMPLETION_DATE'] !=
                                                null
                                            ? DateFormat('dd MMM yyyy')
                                                .format(DateTime.parse(
                                                        widget.AllTransections![
                                                                index]
                                                            ['COMPLETION_DATE'])
                                                    .toLocal())
                                                .toString()
                                            : "",
                                        size: width(context) * 0.031,
                                        color: txtSecondaryColor,
                                        align: TextAlign.right),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                          onChanged: (int? index) {
                            setState(() {
                              SelectedTransection = index;
                              isButtonActive = true;
                            });
                          }),
                      divideLine(),
                    ],
                  )),
            ),
          ),
          Expanded(
            flex: 0,
            child: myAppButton(
                context: context,
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                buttonName: "Next",
                onpress: isButtonActive
                    ? () {
                        goToData(context, complaintRegisterRoute, {
                          "data": widget
                              .AllTransections![SelectedTransection!.toInt()],
                          "reasons": widget.CT_reasons
                        });
                      }
                    : null),
          ),
        ],
      ),
    );
  }

  DropdownLable(value) {
    switch (value) {
      case "Month":
        return "This Month";
      case "Week":
        return "This Week";
      default:
        return value;
    }
  }
}
