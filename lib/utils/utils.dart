import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:bbps/bloc/autopay/autopay_cubit.dart';
import 'package:bbps/bloc/complaint/complaint_cubit.dart';
import 'package:bbps/bloc/history/history_cubit.dart';
import 'package:bbps/bloc/home/home_cubit.dart';
import 'package:bbps/bloc/mybill/mybill_cubit.dart';
import 'package:bbps/bloc/otp/otp_cubit.dart';
import 'package:bbps/model/complaints_model.dart';
import 'package:bbps/model/history_model.dart';
import 'package:bbps/views/auto_pay/setupAutoPay.dart';
import 'package:bbps/views/complaints/complaint_list.dart';
import 'package:bbps/views/complaints/complaint_submit.dart';
import 'package:bbps/views/complaints/new_complaint_tab.dart';
import 'package:bbps/views/history/history_tab_module.dart';
import 'package:bbps/views/home/home_tab.dart';
import 'package:bbps/views/mobile_prepaid/prepaid_add_biller.dart';
import 'package:bbps/views/mybills/billers_search.dart';
import 'package:bbps/views/otp/otp_validation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:timeago/timeago.dart' as timeago;
import '../api/api_repository.dart';
import '../bloc/home/billflow_cubit.dart';
import '../bloc/splash/splash_cubit.dart';
import '../model/confirm_done_model.dart';
import '../model/decoded_model.dart';
import '../views/ManageBillers/add_new_bill.dart';
import '../views/ManageBillers/edit_bill.dart';
import '../views/Payment/confirm_payment.dart';
import '../views/Payment/confirm_payment_done.dart';
import '../views/Payment/failed_transaction.dart';
import '../views/Payment/transaction_receipt.dart';
import '../views/auto_pay/edit_auto_pay.dart';
import '../views/complaints/complaint_view.dart';
import '../views/history/transaction_details.dart';
import '../views/home/bill_flow.dart';
import '../views/home/pdf_preview_page.dart';
import '../views/mybills/my_bill.dart';
import '../views/splash_screen.dart';
import 'const.dart';

// hide softkeyboar programatically
hideKeyboard() => SystemChannels.textInput.invokeMethod('TextInput.hide');
List<Accounts>? myAccounts = [];
bool isSavedBillFrom = true;
bool isMobilePrepaidFrom = false;
// BillerData? billerDataTemp;
// // InputSignaturesData? inputSignaturesModelTemp;
// List<PARAMETERS>? inputSignaturesModelTemp;
isUpiValid(upiId) {
  return RegExp("[a-zA-Z0-9\.\-]\@[a-zA-Z][a-zA-Z]").hasMatch(upiId);
}

// get device height width Dimentions
height(context) => MediaQuery.of(context).size.height;
width(context) => MediaQuery.of(context).size.width;
deviceAspectRatio(context) => MediaQuery.of(context).size.aspectRatio;
String userName = "Hi User";
// named route navigation functions
goTo(context, routeName) => Navigator.pushNamed(context, routeName);
goToReplace(context, routeName) =>
    Navigator.pushReplacementNamed(context, routeName);
goToData(context, routeName, arg) =>
    Navigator.pushNamed(context, routeName, arguments: arg);
goToReplaceData(context, routeName, arg) =>
    Navigator.pushReplacementNamed(context, routeName, arguments: arg);
goToUntil(context, routeName) =>
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
goBack(context) => Navigator.pop(context);

showLoaderSplash(context, Image? equitasImage) {
  Loader.show(context,
      isSafeAreaOverlay: true,
      isBottomBarOverlay: true,
      overlayFromBottom: 0,
      overlayColor: Colors.transparent,
      progressIndicator: equitasImage ??
          Image.asset(
            LoaderGif,
            height: height(context) * 0.07,
            width: height(context) * 0.07,
          ),
      themeData: Theme.of(context).copyWith(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: primarySubColor)));
}

showLoader(context) {
  Loader.show(context,
      isSafeAreaOverlay: true,
      isBottomBarOverlay: true,
      overlayFromBottom: 0,
      overlayColor: Colors.transparent,
      progressIndicator: Image.asset(
        LoaderGif,
        height: height(context) * 0.07,
        width: height(context) * 0.07,
      ),
      // progressIndicator: CircularProgressIndicator(backgroundColor: Colors.red),
      themeData: Theme.of(context).copyWith(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: primarySubColor)));
}

// navigation route setting

class MyRouter {
  ApiCall apicall = ApiCall();
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        Widget splashScreen = SplashScreen(
          redirectData: const {},
        );
        if (settings.arguments != null) {
          final args = settings.arguments as Map<String, dynamic>;

          logConsole(args.toString(), "at generateRoute() ::: args 1 ::");

          if (args['redirectionRequest'] != null) {
            logConsole(jsonEncode(args).toString(),
                "at generateRoute() ::: args 2 :: ");
            logConsole(args.toString(), "at generateRoute() :::args 3 ::");
            if (args['redirectionRequest']['msgBdy'] != null &&
                args['redirectionRequest']['checkSum'] != null) {
              splashScreen = SplashScreen(
                redirectData: args['redirectionRequest']['msgBdy'],
                checkSum: args['redirectionRequest']['checkSum'],
              );
            } else {
              splashScreen = SplashScreen(
                redirectData: {},
                checkSum: "",
              );
              debugPrint("NO SUFFICIENT DATA SENT");
            }
          }
        }

        //change UI with if coundition and based on args data;
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SplashCubit(repository: apicall),
                  child: splashScreen,
                ));
      case homeRoute:
        final homeCubit = HomeCubit(repository: apicall);
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => homeCubit,
                  child: const HomeTabScreen(),
                ));
      case billerSearchRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apicall),
                  child: const BillersSearch(),
                ));
      case myBillRoute:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => MybillCubit(repository: apicall),
                  child: const MyBillScreen(),
                ));

      case otpRoute:
        Widget otpScreen = OtpVerification(
          from: '',
          templateName: '',
        );
        final args = settings.arguments as Map<String, dynamic>;
        // logInfo(jsonEncode(args).toString());
        if (args['from'] == fromAutoPayDelete) {
          logInfo('fromAutoPayDelete');
          otpScreen = OtpVerification(
            from: args['from'],
            templateName: args['templateName'],
            autopayData: args['data'],
          );
        } else if (args['from'] == fromAutoPayEdit) {
          logInfo('fromAutoPayEdit');
          otpScreen = OtpVerification(
              from: args['from'],
              id: args['id'].toString(),
              templateName: args['templateName'],
              data: args['data']);
        } else if (args['from'] == fromAutoPayCreate) {
          logInfo('fromAutoPayCreate');
          otpScreen = OtpVerification(
              from: args['from'],
              id: args['id'].toString(),
              templateName: args['templateName'],
              data: args['data']);
        } else if (args['from'] == myBillRoute) {
          logInfo('myBillRoute');
          otpScreen = OtpVerification(
              from: args['from'],
              templateName: args['templateName'],
              data: args['data']);
        } else if (args['from'] == confirmPaymentRoute) {
          logInfo('confirmPaymentRoute');
          otpScreen = OtpVerification(
              from: args['from'],
              templateName: args['templateName'],
              data: args['data']);
        } else if (args['from'] == fromUpcomingDisable) {
          logInfo('fromUpcomingDisable');
          // logInfo(args['from'].toString());
          otpScreen = OtpVerification(
            from: args['from'],
            templateName: args['templateName'],
            data: args['data'],
          );
        } else if (args['from'] == fromAddnewBillOtp) {
          logInfo('fromAddnewBillOtp');
          otpScreen = OtpVerification(
            from: args['from'],
            templateName: args['templateName'],
            data: args['data'],
          );
        }
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => OtpCubit(repository: apicall),
                  child: otpScreen,
                ));
      case historyRoute:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HistoryCubit(repository: apicall),
                  child: const HistoryTabViewScreen(),
                  // child: const HistoryTabScreen(),
                ));
      case complaintRoute:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apicall),
                  child: const ComplaintScreen(),
                ));
      case confirmPaymentDoneRoute:
        final args = settings.arguments as Map<String, dynamic>;
        debugPrint("confirmPaymentDone args=============>");
        inspect(args);
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apicall),
                  child: ConfirmPaymentDone(
                    tnxData: args['data'],
                  ),
                ));

      case failedPaymentRoute:
        final args = settings.arguments as Map<String, dynamic>;
        debugPrint("confirmPayment failed args=============>");
        inspect(args);
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apicall),
                  child: FailedTransaction(tnxData: args['data']),
                ));

      case complaintNewRoute:
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apicall),
                  // child: const NewComplaint(),
                  child: const NewComplaintTabViewScreen(),
                ));
      case transactionDetailsRoute:
        HistoryData? historyData;
        final args = settings.arguments as Map<String, dynamic>;
        historyData = args['data'];
        return MaterialPageRoute(
            builder: (_) => TransactionDetails(historyData: historyData));
      case viewComplaintRoute:
        ComplaintsData? complaintData;
        final args = settings.arguments as Map<String, dynamic>;
        complaintData = args['data'];
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apicall),
                  child: ComplaintView(complaintData: complaintData),
                ));

      case complaintRegisterRoute:
        HistoryData? historyData;
        final args = settings.arguments as Map<String, dynamic>;
        historyData = args["data"];
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ComplaintCubit(repository: apicall),
                  child: ComplaintSubmit(
                      txnData: historyData, reasonsdata: args["reasons"]),
                ));
      case autoPayEditRoute:
        final args = settings.arguments as Map<String, dynamic>;
        logInfo(jsonEncode(args).toString());
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AutopayCubit(repository: apicall),
                  child: EditAutoPayScreen(
                      id: args['customerBillID'],
                      autoPayData: args['autoPayData'],
                      billerName: args['billerName'],
                      billName: args['billName'],
                      lastPaidAmount: args['lastPaidAmount'],
                      maxAllowedAmount: args['limit']),
                ));

      case setupAutoPayRoute:
        final args = settings.arguments as Map<String, dynamic>;
        logInfo(jsonEncode(args).toString());
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AutopayCubit(repository: apicall),
            child: SetupAutoPay(
                paidAmount: args['paidAmount'],
                billID: args['customerBillID'],
                billerName: args['billername'],
                billName: args['billname'],
                inputSignatures: args['inputSignatures'],
                dueAmount: args['dueAmount'],
                maxAllowedAmount: args['limit']),
          ),
        );
      case billFlowRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(repository: apicall),
            child: BillFlow(id: args['id'], name: args['name']),
          ),
        );

      //mobile prepaid
      case prepaidAddBillerRoute:
        final args = settings.arguments as Map<String, dynamic>;
        inspect(args);

        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(repository: apicall),
            child: PrepaidAddBiller(
                isSavedBill: args['isSavedBill'],
                id: args['id'],
                billerData: args['billerData'],
                name: args['name'],
                savedBillersData: args['savedBillersData']),
          ),
        );
      case pdfPreviewPageRoute:
        final args = settings.arguments as Map<String, dynamic>;
        debugPrint("PdfPreviewPage args=============>");
        inspect(args);
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apicall),
                  child: PdfPreviewPage(
                    transactionReceiptData: args['data'],
                  ),
                ));
      case confirmPaymentRoute:
        final args = settings.arguments as Map<String, dynamic>;
        logConsole(args.toString(), "AT CONFIRMPAYMENTROUTE ");

        // args['savedBillersData']
        //     .forEach((key, value) => debugPrint("$key = $value"));
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => billFlowCubit(repository: apicall),
                  child: ConfirmPayment(
                      billID: args['billID'],
                      billerName: args['name'],
                      billName: args['billName'],
                      isSavedBill: args["isSavedBill"],
                      billerData: args['billerData'],
                      inputParameters: args['inputParameters'],
                      inputSignatureItems: args['inputSignatureItems'],
                      savedBillersData: args['savedBillersData'],
                      selectedPrepaidPlan: args['selectedPrepaidPlan'],
                      isMobilePrepaid: args['isMobilePrepaid'],
                      selectedCircle: args['selectedCircle'],
                      mobileNumber: args['mobileNumber']),
                ));

      case transactionReceiptRoute:
        // final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => billFlowCubit(repository: apicall),
                  child: TransactionReceipt(),
                ));

      case addNewBill:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apicall),
                  child: AddNewBill(
                      billerData: args['billerData'],
                      inputSignatureData: args['inputSignatureData'] ?? []),
                ));

      case editBill:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => HomeCubit(repository: apicall),
                  child: EditBill(
                    billData: args['data'],
                  ),
                ));
      default:
        return null;
    }
  }
}

isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    return true;
  }
  return false;
}

setSharedValue(key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
  return true;
}

setSharedBoolValue(key, value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
  return true;
}

getSharedValue(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

getSharedBoolValue(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

clearSharedValues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

validateJWT() async {
  try {
    var token = await getSharedValue(TOKEN);
    bool hasExpired = JwtToken.isExpired(token);
    if (hasExpired != true) {
      logConsole(hasExpired.toString(), "HASH EXPIRED ??? : ");
      var decodedToken = JwtToken.payload(token);
      DecodedModel? model = DecodedModel.fromJson(decodedToken);

      // log(model.accounts!.length.toString(), name: "JWT MODEL");
      return model;
    } else {
      logError("Expired", "TOKEN");
      return 'restart';
    }
  } catch (e) {
    print(e);
  }
}

Future<List<Accounts>> getDecodedAccounts() async {
  List<Accounts> decodedAccounts = [];
  try {
    DecodedModel? decodedModel = await validateJWT();
    logConsole(jsonEncode(decodedModel).toString(), "TRUE CONDITION");

    if (decodedModel.toString() != 'restart') {
      decodedAccounts = decodedModel!.accounts!;
    }
  } catch (e) {
    print(e);
  }

  return decodedAccounts;
}

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime getLastSixMonths(DateTime d) => DateTime(d.year, d.month - 6, d.day);
// dynamic getTimeAgo(DateTime d) {
//   try {
//     dynamic value = '';
//     final now = DateTime.now();
//     final recvDate = d.toLocal();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = DateTime(now.year, now.month, now.day - 1);
//     final date = DateTime(recvDate.year, recvDate.month, recvDate.day);
//     // final forChecking = DateTime.now().subtract(Duration(hours: 23));
//     if (date == today) {
//       // value = "Today";
//       final curtimeNow = timeago.format(d);
//       if (curtimeNow == 'a day ago') {
//         value = "1 day ago";
//       } else if (curtimeNow == 'about an hour ago') {
//         value = "1 hour ago";
//       } else {
//         value = curtimeNow;
//       }
//     } else if (date == yesterday) {
//       value = "1 day ago";
//     } else {
//       value = DateFormat('dd MMM yyyy').format(date);
//     }
//     return value;
//   } catch (e) {
//     log(e.toString(), name: "getTimeAgo (fn)");
//   }
// }

// API CALL
var client = http.Client();

api1(
    {@required String? method,
    @required String? url,
    Map<String, dynamic>? body,
    token,
    checkSum}) async {
  try {
    if (method!.toLowerCase().contains("post")) {
      return client
          .post(Uri.parse(url!),
              body: json.encode(body),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : checkSum != null
                      ? {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                          "checksum": checkSum,
                        }
                      : {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                        })
          .timeout(
        const Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("put")) {
      // log(await getSharedBoolValue(TOKEN));
      return client
          .put(Uri.parse(url!),
              body: json.encode(body),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : checkSum != null
                      ? {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                          "checksum": checkSum,
                        }
                      : {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                        })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("get")) {
      logConsole(await getSharedValue(TOKEN), "TOKEN ::::");
      return client
          .get(Uri.parse(url!),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("delete")) {
      logConsole(await getSharedValue(TOKEN), "TOKEN ::::");
      return client
          .delete(Uri.parse(url!),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    })
          .timeout(
        const Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    }
  } catch (e) {
    logError(e.toString(), "API CALL FUNCTION ERROR:::: ");
  }
}

api(
    {@required String? method,
    @required String? url,
    Map<String, dynamic>? body,
    token,
    checkSum}) async {
  late String bodyPayload;

  if (url.toString().contains(redirectUrl) ||
      url.toString().contains(loginUrl)) {
    bodyPayload = json.encode(body);
  } else if (method!.toLowerCase().contains("put") ||
      method.toLowerCase().contains("post")) {
    var publicKey = await getSharedValue(ENCRYPTION_KEY);

    final rsaencryption = encrypt.Encrypter(
      encrypt.RSA(
          publicKey: CryptoUtils.rsaPublicKeyFromPem(publicKey),
          encoding: encrypt.RSAEncoding.OAEP),
    );

    List<String> splitByLength(String value, int length) {
      List<String> SplitDatas = [];

      for (int i = 0; i < value.length; i += length) {
        int offset = i + length;
        SplitDatas.add(
            value.substring(i, offset >= value.length ? value.length : offset));
      }
      return SplitDatas;
    }

    final data = splitByLength(jsonEncode(body), 64);

    final iv = encrypt.IV.fromUtf8("1234567890123456");

    List<String> newChunks = [];
    for (var chunk in data) {
      final encryptedChunk = rsaencryption.encrypt(chunk, iv: iv).base64;
      newChunks.add(encryptedChunk);
    }

    final chunksstring = newChunks.join("");

    bodyPayload =
        json.encode({"encryptedData": chunksstring, "fromMobile": true});
    logConsole(bodyPayload, "api() : EncryptedBody for :: $url ::");
  }

  try {
    if (method!.toLowerCase().contains("post")) {
      return client
          .post(Uri.parse(url!),
              body: bodyPayload,
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : checkSum != null
                      ? {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                          "checksum": checkSum,
                        }
                      : {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                        })
          .timeout(
        const Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("put")) {
      // log(await getSharedBoolValue(TOKEN));
      return client
          .put(Uri.parse(url!),
              body: bodyPayload,
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : checkSum != null
                      ? {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                          "checksum": checkSum,
                        }
                      : {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.acceptHeader: "application/json",
                          HttpHeaders.accessControlAllowOriginHeader: '*',
                        })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("get")) {
      logConsole(await getSharedValue(TOKEN), "TOKEN ::::");
      return client
          .get(Uri.parse(url!),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    })
          .timeout(
        Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    } else if (method.toLowerCase().contains("delete")) {
      logConsole(await getSharedValue(TOKEN), "TOKEN ::::");
      return client
          .delete(Uri.parse(url!),
              headers: token == true
                  ? {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${await getSharedValue(TOKEN)}',
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    }
                  : {
                      HttpHeaders.contentTypeHeader: 'application/json',
                      HttpHeaders.acceptHeader: "application/json",
                      HttpHeaders.accessControlAllowOriginHeader: '*',
                    })
          .timeout(
        const Duration(seconds: requestTimeoutDuration),
        onTimeout: () {
          final Map<String, dynamic> errData = {
            "status": 500,
            "message": "Request Timed Out",
            "data": "Error"
          };

          return http.Response(jsonEncode(errData), 500);
        },
      );
    }
  } catch (e) {
    logError(e.toString(), "API CALL FUNCTION ERROR:::: ");
  }
}

List<String> calendarMonths = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

dynamic getMonthName(_month) {
  debugPrint("object" + _month);
  String returnMonth = "";
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  months.asMap().forEach((key, value) {
    if (_month == "12") {
      returnMonth = months[0];
    } else if (key.toString() == _month) {
      returnMonth = months[key].toString();
    }
  });
  return returnMonth;
  // return months[int.parse(currentMonth) + 1].toString();
}

dynamic numberPrefixSetter(String inputNumber) {
  return '${inputNumber}${inputNumber.split("").last == "1" && inputNumber != "11" ? "st" : inputNumber.split("").last == "2" && inputNumber != "12" ? "nd" : inputNumber.split("").last == "3" && inputNumber != "13" ? "rd" : "th"}';
}

dynamic getMonthName2(int? isBimonthly) {
  var month = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  // today's date
  // var todaysDate = new Date();
  // // selecting the month number from today's date
  // var monthNumber = todaysDate.getMonth() + 1;
  // // selecting the current year
  // var year = todaysDate.getFullYear();

  var todaysDate = DateTime.parse(DateTime.now().toString()).day.toString();
  var monthNumber = DateTime.parse(DateTime.now().toString()).month;
  var year = DateTime.parse(DateTime.now().toString()).year;

  // declaring nextMonth and nextToNextMonth variables
  String nextMonth, nextToNextMonth;
  // if the value of isBimonthly is zero select nextMonth and nextToNextMonth
  if (isBimonthly == 0) {
    //if monthNumber is less than or equal to 10 add 1 to the current month and 2 to the next month
    if (monthNumber >= 1 && monthNumber <= 10) {
      nextMonth = '${month[monthNumber + 1]} ${year}';
      nextToNextMonth = '${month[monthNumber + 2]} ${year}';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 11 set nextMonth as 12 and nextToNextMonth 11 - 10 = 1 and year = year + 1
    else if (monthNumber == 11) {
      nextMonth = '${month[monthNumber + 1]} ${year}';
      nextToNextMonth = '${month[monthNumber - 10]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 12 set nextMonth as 12 - 11 = 1 and 12 - 10 = 2 and year = year + 1
    else {
      nextMonth = '${month[monthNumber - 11]} ${year + 1}';
      nextToNextMonth = '${month[monthNumber - 10]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
  }
  //if the value of isBimonthly is one select second and fourth month from current month
  else if (isBimonthly == 1) {
    // if monthNumber is less than or equal to 8, add 2 for nextMonth and 4 for nextToNextMonth
    if (monthNumber >= 1 && monthNumber <= 8) {
      nextMonth = '${month[monthNumber + 2]} ${year}';
      nextToNextMonth = '${month[monthNumber + 4]} ${year}';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 9 or 10, add 2 for nextMonth and subtract 8 for nextToNextMonth and add one for next year
    else if (monthNumber == 9 || monthNumber == 10) {
      nextMonth = '${month[monthNumber + 2]} ${year}';
      nextToNextMonth = '${month[monthNumber - 8]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
    // if monthNumber is 11 or 12, subtract 10 for nextMonth and 8 for nextToNextMonth as well add 1 for the next year
    else {
      nextMonth = '${month[monthNumber - 10]} ${year + 1}';
      nextToNextMonth = '${month[monthNumber - 8]} ${year + 1}';
      return [nextMonth, nextToNextMonth];
    }
  }
  // condition to display the nextMonth only while editing the autopay
  else {
    // if monthNumber is less than equal to 11 add 1 for the nextMonth
    if (monthNumber >= 1 && monthNumber <= 11) {
      nextMonth = '${month[monthNumber + 1]} ${year}';
      return [nextMonth];
    }
    // if monthNumber is 12 set nextMonth as 12 - 11 = 1 and 12 - 10 = 2 and year = year + 1
    else {
      nextMonth = '${month[monthNumber - 11]} ${year + 1}';
      return [nextMonth];
    }
  }
}

dynamic getDecodedToken() async {
  var token = await getSharedValue(TOKEN);
  final encodedPayload = token?.split('.')[1];
  dynamic decodedToken =
      utf8.fuse(base64).decode(base64.normalize(encodedPayload));

  return jsonDecode(decodedToken);
}

dynamic getTransactionDateForComplaint(transactionType) async {
  try {
    final Map<String, dynamic> returnResponse = {
      "startDate": "",
      "endDate": ""
    };
    logConsole(transactionType, 'transactionType');

    var curDateTime = DateTime.now();
    var parsetoday = getDate(curDateTime);
    var thisWeekDay = curDateTime.weekday;
    var thisMonthFirstDay = DateTime(curDateTime.year, curDateTime.month, 1);
    thisMonthFirstDay = thisMonthFirstDay.subtract(Duration(days: 0));
    DateTime last3MonthFirstDay = parsetoday.subtract(Duration(days: 90));
    logConsole(last3MonthFirstDay.toString(), "last3MonthLastDay ::");

    // DateTime last3MonthFirstDay = DateTime(
    //     last3MonthLastDay.year, last3MonthLastDay.month, last3MonthLastDay.day);
    // log(last3MonthFirstDay.toString(), name: "last3MonthFirstDay ::");

    DateTime lastMonthlastDay = DateTime(curDateTime.year, curDateTime.month, 1)
        .subtract(Duration(days: 0));

    DateTime lastMonthFirstDay =
        DateTime(lastMonthlastDay.year, lastMonthlastDay.month - 1, 1);
    lastMonthFirstDay = lastMonthFirstDay.subtract(Duration(days: 0));

    var thisWeekStartDate = parsetoday.subtract(Duration(days: thisWeekDay));
    DateTime thisWeekFirstDay =
        getDate(curDateTime.subtract(Duration(days: curDateTime.weekday)));
    DateTime prevWeekFirstDay = thisWeekFirstDay.subtract(Duration(days: 8));
    var todayStartDate = getDate(curDateTime.subtract(Duration(days: 0)));

    var yesterdayStartDate = getDate(curDateTime.subtract(Duration(days: 1)));
    var yesterdayEndDateTemp = getDate(curDateTime.subtract(Duration(days: 1)));
    var yesterdayEndDate = DateTime(yesterdayEndDateTemp.year,
        yesterdayEndDateTemp.month, yesterdayEndDateTemp.day, 23, 59, 59);

    var lastWeekFirstDay = getDate(prevWeekFirstDay.add(Duration(days: 1)));
    var lastWeekLastDay = getDate(prevWeekFirstDay.add(Duration(days: 7)));
    // var lastWeekFirstDay =
    //     getDate(prevWeekFirstDay.add(Duration(days: prevWeekFirstDay.weekday)));
    // var lastWeekLastDay = getDate(prevWeekFirstDay
    //     .add(Duration(days: DateTime.daysPerWeek - prevWeekFirstDay.weekday)));

    var today = parsetoday.toLocal().toIso8601String();
    var yesterday = yesterdayStartDate.toLocal().toIso8601String();
    var thisWeekStartDt = thisWeekStartDate.toLocal().toIso8601String();
    var lastWeekStartDt = lastWeekFirstDay.toLocal().toIso8601String();
    var lastWeekEndDt = lastWeekLastDay.toLocal().toIso8601String();
    var thisMonthStartDt = thisMonthFirstDay.toLocal().toIso8601String();
    var lastMonthStartDt = lastMonthFirstDay.toLocal().toIso8601String();
    var lastMonthEndDt = lastMonthlastDay.toLocal().toIso8601String();
    var last3MonthStartDt = last3MonthFirstDay.toLocal().toIso8601String();

    var currTime = curDateTime.toLocal().toIso8601String();
    logInfo(transactionType);
    logInfo(currTime);
    if (transactionType == "Today") {
      // returnResponse['startDate'] = today;
      returnResponse['endDate'] = currTime;
      returnResponse['startDate'] = todayStartDate.toString();
      // returnResponse['endDate'] = today.toString();
    }
    if (transactionType == "Yesterday") {
      returnResponse['startDate'] = yesterday;
      returnResponse['endDate'] = yesterdayEndDate.toString();
    } else if (transactionType == "This Week") {
      returnResponse['startDate'] = thisWeekStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "Last Week") {
      returnResponse['startDate'] = lastWeekStartDt;
      returnResponse['endDate'] = lastWeekEndDt;
    } else if (transactionType == "This Month") {
      returnResponse['startDate'] = thisMonthStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "Last Month") {
      returnResponse['startDate'] = lastMonthStartDt;
      returnResponse['endDate'] = lastMonthEndDt;
    } else if (transactionType == "last 3 Months") {
      returnResponse['startDate'] = last3MonthStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "customDate") {
      // body = {
      //   "startDate": last3MonthStartDt,
      //   "endDate": currTime,
      //   "pageNumber": 1
      // };
    }
    return returnResponse;
  } catch (e) {
    logError(e.toString(), "getTransactionHistoryDate (fn)");
  }
}

dynamic getTransactionHistoryDate(transactionType) async {
  try {
    final Map<String, dynamic> returnResponse = {
      "startDate": "",
      "endDate": ""
    };
    logConsole(transactionType, 'transactionType');

    var curDateTime = DateTime.now();
    var parsetoday = getDate(curDateTime);
    var thisWeekDay = curDateTime.weekday;
    var thisMonthFirstDay = DateTime(curDateTime.year, curDateTime.month, 1);
    DateTime last3MonthLastDay = thisMonthFirstDay.subtract(Duration(days: 90));

    DateTime last3MonthFirstDay = DateTime(
        last3MonthLastDay.year, last3MonthLastDay.month, last3MonthLastDay.day);
    DateTime lastMonthlastDay = DateTime(curDateTime.year, curDateTime.month, 1)
        .subtract(Duration(days: 0));
    DateTime lastMonthFirstDay =
        DateTime(lastMonthlastDay.year, lastMonthlastDay.month - 1, 1);
    lastMonthFirstDay = lastMonthFirstDay.subtract(Duration(days: 0));
    var thisWeekStartDate = parsetoday.subtract(Duration(days: thisWeekDay));
    DateTime thisWeekFirstDay =
        getDate(curDateTime.subtract(Duration(days: curDateTime.weekday)));
    DateTime prevWeekFirstDay = thisWeekFirstDay.subtract(Duration(days: 7));
    var parseyesterday = getDate(curDateTime.subtract(Duration(days: 1)));

    var lastWeekFirstDay = getDate(prevWeekFirstDay);
    var lastWeekLastDay = getDate(prevWeekFirstDay.add(Duration(days: 6)));
    // var lastWeekFirstDay =
    //     getDate(prevWeekFirstDay.add(Duration(days: prevWeekFirstDay.weekday)));
    // var lastWeekLastDay = getDate(prevWeekFirstDay
    //     .add(Duration(days: DateTime.daysPerWeek - prevWeekFirstDay.weekday)));

    var today = parsetoday.toLocal().toIso8601String();
    var yesterday = parseyesterday.toLocal().toIso8601String();
    var thisWeekStartDt = thisWeekStartDate.toLocal().toIso8601String();
    var lastWeekStartDt = lastWeekFirstDay.toLocal().toIso8601String();
    var lastWeekEndDt = lastWeekLastDay.toLocal().toIso8601String();
    var thisMonthStartDt = thisMonthFirstDay.toLocal().toIso8601String();
    var lastMonthStartDt = lastMonthFirstDay.toLocal().toIso8601String();
    var lastMonthEndDt = lastMonthlastDay.toLocal().toIso8601String();
    var last3MonthStartDt = last3MonthFirstDay.toLocal().toIso8601String();

    var currTime = curDateTime.toLocal().toIso8601String();
    logInfo(transactionType);
    logInfo(currTime);
    if (transactionType == "Today") {
      returnResponse['startDate'] = today;
      returnResponse['endDate'] = currTime;
    }
    if (transactionType == "Yesterday") {
      returnResponse['startDate'] = yesterday;
      returnResponse['endDate'] = today;
    } else if (transactionType == "This Week") {
      returnResponse['startDate'] = thisWeekStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "Last Week") {
      returnResponse['startDate'] = lastWeekStartDt;
      returnResponse['endDate'] = lastWeekEndDt;
    } else if (transactionType == "This Month") {
      returnResponse['startDate'] = thisMonthStartDt;
      returnResponse['endDate'] = currTime;
    } else if (transactionType == "Last Month") {
      returnResponse['startDate'] = lastMonthStartDt;
      returnResponse['endDate'] = lastMonthEndDt;
    } else if (transactionType == "last 3 Months") {
      returnResponse['startDate'] = last3MonthStartDt;
      returnResponse['endDate'] = lastMonthEndDt;
    } else if (transactionType == "customDate") {
      // body = {
      //   "startDate": last3MonthStartDt,
      //   "endDate": currTime,
      //   "pageNumber": 1
      // };
    }
    return returnResponse;
  } catch (e) {
    logError(e.toString(), "getTransactionHistoryDate (fn)");
  }
}

Map<String, dynamic> getBillerType(
    String? fetchRequirement,
    String? blrAcceptsAdhoc,
    String? supportBillValidation,
    String? paymentExactness) {
  bool fetchBill = false;
  bool amountEditable = false;
  bool validateBill = false;
  String billerType = "";
  bool isAdhoc = false;
  bool quickPay = true;

  switch (fetchRequirement) {
    //   If the case is MANDATORY and OPTIONAL then check the adhoc parameter
    case "MANDATORY":
    case "OPTIONAL":
      // If the biller accepts adhoc then mark fetch Bill and amount Editable as true
      if (blrAcceptsAdhoc == "Y") {
        fetchBill = true;
        amountEditable = true;
        billerType = "adhoc";
        validateBill = false;
        isAdhoc = true;
        quickPay = true;
      } else {
        //   Checking the payment exactness field to make the field editable
        if (paymentExactness == "Exact") {
          amountEditable = false;
        } else if (paymentExactness == "Exact and Above") {
          amountEditable = true;
        } else {
          amountEditable = true;
        }
        billerType = "billFetch";
        fetchBill = true;
        validateBill = false;
        isAdhoc = false;
        quickPay = false;
      }
      break;
    //   If the case is NOT_SUPPORTED then check for supportBillValidation
    case "NOT_SUPPORTED":
      // If the billvalidation is MANDATORY then mark validateBill , amountEditable and fetchBill
      if (supportBillValidation == "MANDATORY") {
        validateBill = true;
        fetchBill = false;
        amountEditable = true;
        billerType = "validate";
        isAdhoc = true;
        quickPay = true;
      }
      //   Else mark all the fields as false
      else {
        validateBill = false;
        amountEditable = true;
        fetchBill = false;
        billerType = "instant";
        isAdhoc = true;
        quickPay = true;
      }
      break;
    default:
      break;
  }
  //   Return the all the fields
  return {
    "fetchBill": fetchBill,
    "amountEditable": amountEditable,
    "validateBill": validateBill,
    "billerType": billerType,
    "isAdhoc": isAdhoc,
    "quickPay": quickPay,
  };
}

getBillPaymentDetails(
    PaymentDetails? payBillInfo, bool isAdhoc, String? equitasTransactionId) {
  double? totalAmount = 0;
  String paymentDate = "";
  String? txnReferenceId = "";
  String cbsTransactionReferenceId = "";
  String? paymentMode = "";
  String? paymentChannel = "";
  String? customerName = "";
  String? mobileNumber = "";
  int? fee = 0;
  bool? success = false;
  String? approvalRefNum = "";
  bool isAdhocBIller = false;
  bool failed = false;
  bool bbpsTimeout = false;

  // date formatting options
  // const options = {
  //   weekday: "long",
  //   year: "numeric",
  //   month: "long",
  //   day: "numeric",
  //   hour: "numeric",
  //   minute: "numeric",
  // };

  if (payBillInfo != null) {
    if (payBillInfo.failed == true) {
      paymentDate = payBillInfo.created!;

      // new Intl.("en-IN",)
      //   .format(new Date(payBillInfo.created))
      //   .replace("pm", "PM")
      //   .replace("am", "AM");
      failed = true;
    } else {
      // If the Biller Supports Adhoc then Store the folowing details
      if (isAdhoc) {
        totalAmount = (payBillInfo.tran != null
            ? payBillInfo.tran!.totalAmount!.toDouble()
            : 0);
        paymentDate = payBillInfo.tran!.created.toString();

        txnReferenceId = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse!.data!.txnReferenceId
            : "-";
        cbsTransactionReferenceId = equitasTransactionId!;
        paymentMode =
            (payBillInfo.tran != null ? payBillInfo.tran?.paymentMode : "-");
        paymentChannel =
            (payBillInfo.tran != null ? payBillInfo.tran?.paymentChannel : "-");
        customerName = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.billerResponse!.customerName
            : "-";
        mobileNumber = payBillInfo.tran != null
            ? payBillInfo.tran?.mobile.toString()
            : "-";
        fee = payBillInfo.tran != null ? payBillInfo.tran!.fee : 0;

        approvalRefNum = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.approvalRefNum
            : "-";
        success = payBillInfo.success!;
        isAdhocBIller = true;
        bbpsTimeout = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.response == "CU timed out"
                ? true
                : false
            : false;
      } else {
        // If the Biller does not support adhoc then store this detail
        totalAmount = (payBillInfo.tran != null
            ? payBillInfo.tran?.totalAmount!.toDouble()
            : 0) as double?;
        paymentDate = payBillInfo.tran!.created.toString();

        txnReferenceId = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.txnReferenceId
            : "-";
        cbsTransactionReferenceId = equitasTransactionId!;
        paymentMode =
            payBillInfo.tran != null ? payBillInfo.tran?.paymentMode : "-";
        paymentChannel =
            payBillInfo.tran != null ? payBillInfo.tran?.paymentChannel : "-";
        customerName = (payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.data?.billerResponse?.customerName
            : "-");
        mobileNumber = payBillInfo.tran != null
            ? payBillInfo.tran?.mobile.toString()
            : "-";
        fee = payBillInfo.tran != null ? payBillInfo.tran!.fee : 0;
        success = payBillInfo.success;
        approvalRefNum =
            payBillInfo.tran != null ? payBillInfo.tran?.approvalRefNo : "-";
        bbpsTimeout = payBillInfo.bbpsResponse != null
            ? payBillInfo.bbpsResponse?.response == "CU timed out"
                ? true
                : false
            : false;
      }
    }
  }
  // Map<String, dynamic> result = {
  //   totalAmount,
  //   paymentDate,
  //   txnReferenceId,
  //   cbsTransactionReferenceId,
  //   paymentMode,
  //   paymentChannel,
  //   customerName,
  //   mobileNumber,
  //   fee,
  //   success,
  //   approvalRefNum,
  //   failed,
  //   bbpsTimeout,
  // } as Map<String, dynamic>;
  // debugPrint(result);
  return {
    "totalAmount": totalAmount,
    "paymentDate": paymentDate,
    "txnReferenceId": txnReferenceId,
    "cbsTransactionReferenceId": cbsTransactionReferenceId,
    "paymentMode": paymentMode,
    "paymentChannel": paymentChannel,
    "customerName": customerName,
    "mobileNumber": mobileNumber,
    "fee": fee,
    "success": success,
    "approvalRefNum": approvalRefNum,
    "failed": failed,
    "bbpsTimeout": bbpsTimeout,
  };
}

dynamic getInputType(String? value) {
  switch (value) {
    case "NUMERIC":
      return TextInputType.number;
      break;
    case "ALPHANUMERIC":
      return TextInputType.text;
      break;
    default:
      TextInputType.text;
  }
}

String ComplaintStatus(String statusID) {
  switch (statusID) {
    case "ASSIGNED":
      return "Assigned";

    case "ESCALATED":
      return "Escalated";

    case "RE_ASSIGNED":
      return "Re Assigned";

    case "ASSIGNED_TO_COU":
      return "Assigned to COU";

    case "ASSIGNED_TO_BOU":
      return "Assigned to BOU";

    case "ASSIGNED_TO_OU":
      return "Assigned to OU";

    case "RESOLVED":
      return "Resolved";

    case "UNRESOLVED":
      return "Unresolved";

    case "PENDING_WITH_BBPOU":
      return "Pending With BBPOU";

    default:
      return statusID.toString();
  }
}

extension StringExtension on String {
  String capitalizeByWord() {
    if (trim().isEmpty) {
      return '';
    }
    return split(' ')
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}
