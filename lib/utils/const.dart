//Colors
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/biller_model.dart';
import '../../model/saved_billers_model.dart';

const String appName = "BBPS";
// message
const String noInternetMessage = "Please check internet connection, try again";
const String trylaterMessage = "Please try again later";

const platform_channel =
    MethodChannel('com.iexceed.equitas.consumer/bbpsMethodChannel');

// from const
const String fromAutoPayDelete = "AutoPayDelte";
const String fromAutoPayEdit = "AutoPayEdit";
const String fromAutoPayCreate = "AutoPayCreate";
const String fromAddnewBillOtp = "AddNewBillOtp";
const String fromConfirmPaymentOtp = "ConfirmPaymentOtp";
// const String fromUpcomingDelete = "AutoPayDelte";
const String fromUpcomingDisable = "UpcomingDisable";

getUniqId() {
  var rng = Random();
  return List.generate(1, (_) => rng.nextInt(100000));
}

// route names
const String splashRoute = '/';
const String homeRoute = '/home';
const String myBillRoute = '/allMyBill';
const String addMyBillRoute = '/addMyBills';
const String autoPayEditRoute = '/autoPayEdit';
const String setupAutoPayRoute = '/setupAutoPay';
const String otpRoute = '/otp';
const String historyRoute = '/history';
const String complaintRoute = '/complaint';
const String confirmPaymentDoneRoute = '/confirmpaymentdoneRoute';
const String complaintNewRoute = '/newComplaint';
const String viewComplaintRoute = '/viewComplaint';
const String complaintRegisterRoute = '/registerComplaint';

const String billFlowRoute = '/billflow';
const String confirmPaymentRoute = '/Confirmpayment';
const String failedPaymentRoute = '/ConfirmpaymentFailed';
const String transactionReceiptRoute = '/transaction_receipt';
const String transactionDetailsRoute = '/transactionDetails';
const String addNewBill = '/addNewBill';
const String editBill = '/editBill';
const String billerSearchRoute = "/billers_search";
const String prepaidAddBillerRoute = "/prepaid_add_biller";

const String pdfPreviewPageRoute = "/pdf_preview_page";
const requestTimeoutDuration = 120;

// Urls
/// The line `// const String baseUrl = "https://digiservicesuat.equitasbank.com/api";` is a commented
/// out line of code. It is not being executed or used in the program. It is likely a URL that was used
/// in development or testing but is not currently being used in the production version of the code.
const String baseUrl = "https://digiservicesuat.equitasbank.com/api";
// const String baseUrl = "http://192.168.25.237:5000/api";
// const String baseUrl = "http://192.168.1.33:5000/api";
// https://digiservicesuat.equitasbank.com/bbps-node-uat/api/auth/redirect

//BBPS_UAT_URL
// const String baseUrl = "http://172.18.84.36:5000/api";

//BBPS_PROD_URL
// const String baseUrl = "";

BillersData? billerDataTemp;
// InputSignaturesData? inputSignaturesModelTemp;
List<PARAMETERS>? inputSignaturesModelTemp;

// endpoints
const String redirectUrl = "/auth/redirect";
const String loginUrl = "/auth/login/";
const String historyUrl = "/transactions/";
const String complaintUrl = "/complaints/";
const String transactionUrl = "/transactions/";

const String autoPayUrl = "/auto-pay/";
const String upcomingDisableUrl = "/auto-pay/status/";
const String removeAutoPayUrl = "/auto-pay/delete/";
const String fetchAutoPayMaxAmountUrl = "/auto-pay/max-amount/";
const String deletebillerUrl = "/billers/delete/";
const String generateOtpUrl = "/user-services/generate-otp";
const String validateOtpUrl = "/user-services/validate-otp";

const String savedBillersUrl = "/billers/saved/";
const String allUpcomingDues = "/billers/all-upcoming-dues/";
const String allLocation = "/billers/location";
const String savedbilldetails = "/billers/get-saved-details/";
const String searchBillersUrl = "/billers/search";
const String billerUrl = "/billers/billers-by-category/";
const String statesDataUrl = "/billers/states-data/";

const String categoriesUrl = "/categories/";

const String amountByDateUrl = "/payment/amount-by-date/";
const String fetchBillUrl = "/payment/fetch-bill";
const String accountInfoUrl = "/payment/account-info";
const String prepaidFetchPlansUrl = "/payment/prepaid-fetch-plans";
const String validateBillUrl = "/payment/validate-bill";
const String addUpdateUpcomingDueUrl = "/billers/add-update-upcoming-due";
const String updateUpcomingDueUrl = "/billers/update-upcoming-dues";

const String chartUrl = '/charts';
const String complaintsConfigUrl = '/complaints/config';
const String inputsignatures = "/billers/input-signatures/";
const String addNewBillerUrl = "/billers/add-biller";
const String payBillUrl = "/payment/bill";
const String updateBill = "/billers/update";
const String bbpsSettings = "/user-services/bbps-settings";
const String paymentInformationUrl = "/billers/payment-information/";
const String deleteUpcomingDueUrl = "/billers/upcoming-due/";
// shared pref
const String TOKEN = 'TOKEN';
const String ENCRYPTION_KEY = 'ENCRYPTION_KEY';

// fonts
const String appFont = 'Rubik-Regular';

//colors
Color primaryColorDark = Color.fromARGB(255, 17, 1, 42);

Color primaryColor = const Color(0xff21084A);
Color primarySubColor = const Color(0xffCFB0FF);
Color primaryBodyColor = const Color(0xffF8F3FF);
Color pillColor = const Color(0x75D0B0FF);
Color txtColor = const Color(0xffFFFFFF);
Color txtPrimaryColor = const Color(0xff161950);
Color txtSecondaryColor = const Color(0xff9395BE);
Color txtSecondaryDarkColor = const Color(0xff5B5D88);
Color txtAmountColor = const Color(0xff5518B5);
Color txtCheckBalanceColor = const Color(0xFF5518B5);
Color txtRejectColor = const Color(0xffD63031);
Color txtHintColor = const Color(0xffBBBCD7);
Color txtCursorColor = Colors.black;

Color alertPendingColor = const Color(0xffF39C12);
Color alertFailedColor = const Color(0xffD63031);
Color alertSuccessColor = const Color(0xff2ECC71);
Color alertWaitingColor = Color(0xFF1286F3);
Color fillColor = Colors.white;
Color shadowColor = Color(0xFFCBCBCB);
Color disableColor = Color(0x47CECECE);
//Icon Color
Color iconColor = const Color(0xffC2BDDC);

//Dash Color
Color dashColor = const Color(0xffD1D2E8);

//Divider
Color divideColor = const Color(0xffE1E2F2);
Color divideDarkColor = const Color(0xffe9eaf5);

//Smooth page indicator
Color smoothPageIndicatorColor = const Color(0xffDAD3E4);

const String flashLogo = 'packages/bbps/packages/bbps/assets/images/flash.svg';
const String historyLogo = "packages/bbps/assets/images/history.svg";
const String complaintsLogo = "packages/bbps/assets/images/complaints.svg";
const String complaintsLogoNew =
    "packages/bbps/assets/logo/logo_complaints.svg";
const String alertSvg = "packages/bbps/assets/images/Alert.svg";
const String bbSvg = "packages/bbps/assets/images/b_mnemonic.svg";

const String iconSuccessSvg = "packages/bbps/assets/images/success.svg";
const String iconAppHomeSvg = "packages/bbps/assets/images/app_home_icon.svg";
const String iconAppHomeSelectedSvg =
    "packages/bbps/assets/images/app_home_icon_selected.svg";
const String iconMyBillSvg = "packages/bbps/assets/images/my_bills_icon.svg";
const String iconMyBillSelectedSvg =
    "packages/bbps/assets/images/my_bills_icon_selected.svg";

const String noUpcomingDues = 'packages/bbps/assets/images/noAutoPayment.svg';
const String noUpcomingPayment =
    'packages/bbps/assets/images/noUpcomingPayments.svg';
// const String bNeumonic = 'packages/bbps/assets/images/b_new_neumonic.svg';

// Symbol Images
const String rupeeSvg = "packages/bbps/assets/images/rupee.svg";

const String NodataFoundSvg = "packages/bbps/assets/images/NoDataFound.svg";

//Png images
const String BLogo = 'packages/bbps/assets/images/BB_default.png';

const String bbpspngLogo = 'packages/bbps/assets/images/BBPSpng.png';
const String equitaspngLogo = 'packages/bbps/assets/images/Equitaspng.png';
const String bNeumonic = 'packages/bbps/assets/images/b_new_neumonic.png';

const String LoaderGif = 'packages/bbps/assets/images/loader.gif';

const String iconCalender = 'packages/bbps/assets/images/iconCalender.png';

const String bbpsAssuredLogo =
    'packages/bbps/assets/images/be_assured_logo.png';
const String clrpappersLogo = 'packages/bbps/assets/images/clrpappers.png';
const String clrpappersFailLogo =
    'packages/bbps/assets/images/clrpappersfail.png';
const String tickmarkLogo = 'packages/bbps/assets/images/tickmark.png';
const String iconFailure = 'packages/bbps/assets/images/icon_failur_png.png';
const String iconDownload = 'packages/bbps/assets/images/iconDownload.png';

//
final String todaysDate =
    DateTime.parse(new DateTime.now().toString()).day.toString();
final String currentMonth =
    DateTime.parse(new DateTime.now().toString()).month.toString();

// symbol

const String rupee = "\u{20B9}";
int otpTimerDuration = 180;
int autoRedirectSeconds = 5;

const String tcTextContent = "By continuing, you agree to accept our ";
const String tcText = "Terms and Conditions";

//Black Text
void logInfo(String msg) {
  developer.log('\x1b[47m\x1b[5m\x1B[30m$msg\x1B[0m');
}

// Green text
void logSuccess(String msg, String? name) {
  developer.log('\x1B[92m$msg\x1B[0m', name: '\x1B[32m$name\x1B[0m');
}

// Yellow text
void logWarning(String msg, String? name) {
  developer.log('\x1B[93m$msg\x1B[0m', name: '\x1B[33m$name\x1B[0m');
}

// Red text
void logError(String msg, String? name) {
  developer.log('\x1B[91m$msg\x1B[0m', name: '\x1B[31m$name\x1B[0m');
}

//Cyan Text
void logConsole(String msg, String? name) {
  developer.log('\x1B[90m$msg\x1B[0m', name: '\x1B[93m$name\x1B[0m');
}

//API ERROR
errorResponseLog(e, from, method) {
  developer.log('\x1b[47m\x1b[5m\x1B[31m${e.toString()}',
      name:
          '\x1b[47m\x1b[5m\x1B[30m${'[$method method] Error at $from api call =>\x1B[0m'}');
}

//API RES

debugLog(reponse, from, data) {
  if (data.statusCode == 200) {
    developer.log(
      '\x1b[32m${jsonEncode(reponse)}',
      name: '\x1B[93m(${data.request.method}) $from API RESPONSE =>',
    );
  } else {
    developer.log('\x1b[47m\x1b[5m\x1B[31m${jsonEncode(reponse)}',
        name: '\x1b[32m { Error at $from api call =>\x1B[0m');
  }
}
