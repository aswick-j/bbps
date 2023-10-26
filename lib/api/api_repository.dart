import 'dart:convert';
import 'dart:developer';

import 'package:bbps/model/login_model.dart';
import 'package:bbps/utils/Mock_Params.dart';
import 'package:flutter/material.dart';

import '../model/redirect_model.dart';
import '../utils/const.dart';
import '../utils/utils.dart';

abstract class Repository {
  Future redirect(whom, initParams, initCheckSum) async {}
  Future parentRedirect(params, checkSum) async {}
  Future login(id, hash) async {}
  Future getHistory(day) async {}
  Future getComplaints() async {}
  Future getComplaintConfig() async {}
  Future getTransactions() async {}
  Future getAllScheduledAutoPay() async {}
  Future fetchAutoPayMaxAmount() async {}
  Future submitTxnsComplaint(comlaint) async {}

  Future generateOtp({templateName, billerName}) async {}
  Future validateOtp(otp) async {}

  Future removeAutoPay(id, otp) async {}

  Future getAutopayEditData(id) async {}
  Future editAutopayData(id, data) async {}
  Future createAutopayData(playload) async {}
  Future deleteBiller(cid, cusId, otp) async {}
  Future disableUpcoming(id, status, otp) async {}

  Future getSavedBillers() async {}
  Future getSearchedBillers(String searchString, String category,
      String location, int pageNumber) async {}
  Future getAllUpcomingDues() async {}

  Future getCategories() async {}
  Future getLocation() async {}
  Future getBbpsSettings() async {}
  Future getSavedBillDetails(id) async {}
  // Future getBillers() async {}
  Future getAmountByDate() async {}

  Future getChartData() async {}
  Future getStatesData() async {}
  Future getInputSignature(id) async {}
  Future getPaymentInformation(id) async {}
  Future addNewBiller(String BillID, dynamic inputSignatures, String Billname,
      String otp) async {}
  Future validateBill(payload) async {}
  Future PrepaidFetchvalidateBill(payload) async {}
  Future prepaidPayBillApi(
      String billerID,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp,
      String paymentMode,
      String forChannel,
      String paymentChannel) async {}
  Future payBill(
      String billerID,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp) async {}
  Future getBillers(
    categoryId,
    pageNumber,
  ) async {}
  Future fetchBill(validateBill, billerID, billerParams, quickPay,
      quickPayAmount, adHocBillValidationRefKey, billName) async {}
  Future getAccountInfo(account) async {}
  Future fetchPrepaidFetchPlans(dynamic id) async {}

  Future updateBillDetails(payload) async {}
  Future getAddUpdateUpcomingDue(
      customerBillID, dueAmount, dueDate, billDate, billPeriod) async {}

  Future deleteUpcomingDue(customerBillID);

  Future updateUpcomingdue() async {}
}

class ApiCall implements Repository {
  @override
  Future redirect(whom, initParams, initCheckSum) async {
    try {
      var response = await api(
          method: "post",
          url: baseUrl + redirectUrl,
          body: initParams,
          checkSum: initCheckSum,
          token: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      logSuccess(decodedResponse.toString(), "REDIRECT RESPONSE ::: ");
      return decodedResponse;
    } catch (e) {
      logWarning(e.toString(), "REDIRECTION ERROR");
    }
  }

  Future parentRedirect(params, checkSum) async {
    RedirectModel? module;
    String id = getUniqId().toString().substring(1, 5);
    logConsole(id, "ID ::::: ");

    // debugPrint("FLUTTER :: REDIRECT PARAMS");
    // debugPrint(params);
    // debugPrint("FLUTTER :: REDIRECT checksum");
    // debugPrint(checkSum);

    try {
      var response = await api(
          method: "post",
          url: baseUrl + redirectUrl,
          // body: params,
          // checkSum: checkSum,
          body: p7['redirectionRequest']!['msgBdy'] as Map<String, dynamic>,
          checkSum: p7['redirectionRequest']!['checkSum'],
          token: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        logSuccess(decodedResponse.toString(), "PARENT REDIRECT RESPONSE ::: ");
        return decodedResponse;
      } else {
        logError(response.statusCode.toString(), "AT parentRedirect ");
        logError(response.body.toString(), "AT parentRedirect :::: ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "REDIRECTION ERROR", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
    // } catch (e) {
    //   logConsole(e.toString(), name: "REDIRECTION ERROR");
    // }
  }

  @override
  Future login(id, hash) async {
    try {
      LoginModel? loginModel;
      Map<String, dynamic>? requestBody = {
        "hash": hash,
      };
      logConsole(baseUrl + loginUrl + id, "API URL ::::");
      logConsole(requestBody.toString(), "REQUEST BODY :::::");
      var response = await api(
          method: "post",
          url: baseUrl + loginUrl + id,
          body: requestBody,
          token: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedResponse;
    } catch (e) {
      logError(e.toString(), "LOGIN API :::;");
    }
  }

  Future<dynamic> getHistory(payload) async {
    Map<String, dynamic> body = payload;

    try {
      logConsole(baseUrl + historyUrl, "HISTORY URL ::::");
      var response = await api(
          method: "post",
          url: baseUrl + historyUrl,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getHistory", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getHistory", "post");
    }
  }

  @override
  Future getComplaints() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + complaintUrl,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "getComplaints", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getComplaints", "get");
    }
  }

  @override
  Future getTransactions() async {
    var today = DateTime.now();
    Map<String, dynamic>? body = {
      "startDate": DateTime(today.year, today.month - 1, today.day)
          .toLocal()
          .toIso8601String(),
      "endDate": DateTime.now().toLocal().toIso8601String(),
      "pageNumber": 1
    };
    try {
      var response = await api(
          method: "post",
          url: baseUrl + transactionUrl,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "getTransactions", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getTransactions", "post");
    }
  }

  @override
  Future fetchAutoPayMaxAmount() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + fetchAutoPayMaxAmountUrl,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "fetchAutoPayMaxAmount", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "fetchAutoPayMaxAmount", "get");
    }
  }

  @override
  Future getAllScheduledAutoPay() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + autoPayUrl,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "getAllScheduledAutoPay", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getAllScheduledAutoPay", "get");
    }
  }

  @override
  Future removeAutoPay(id, otp) async {
    try {
      Map<String, dynamic> body = {"otp": otp};
      var response = await api(
          method: "post",
          url: baseUrl + removeAutoPayUrl + id.toString(),
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "removeAutoPay", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "removeAutoPay", "post");
    }
  }

  @override
  Future deleteBiller(cid, cusId, otp) async {
    try {
      Map<String, dynamic> body = {
        "customerBillId": cid,
        "customerId": cusId,
        "otp": otp
      };
      var response = await api(
          method: "post",
          url: baseUrl + deletebillerUrl,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "deleteBiller", response);

      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "deleteBiller", "post");
    }
  }

  @override
  Future generateOtp({templateName, billerName}) async {
    try {
      Map<String, dynamic> body = {
        "template": templateName,
        "templateVariables": {
          templateName != "confirm-payment" ? "billerName" : "billAmount":
              billerName
        }
      };
      var response = await api(
          method: "post",
          url: baseUrl + generateOtpUrl,
          body: body,
          token: true,
          checkSum: false);

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "generateOtp", response);
      return decodedResponse;
    } on Exception catch (e) {
      errorResponseLog(e.toString(), "generateOtp", "post");
    }
  }

  @override
  Future validateOtp(otp) async {
    try {
      Map<String, dynamic> body = {"otp": otp};
      var response = await api(
          method: 'post',
          body: body,
          url: baseUrl + validateOtpUrl,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "validateOtp", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "validateOtp", "post");
    }
  }

  @override
  Future getAutopayEditData(id) async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + savedbilldetails + id,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "getAutopayEditData", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getAutopayEditData", "get");
    }
  }

  @override
  Future editAutopayData(id, data) async {
    try {
      Map<String, dynamic> body = data;
      var response = await api(
          method: "put",
          url: baseUrl + autoPayUrl + id,
          token: true,
          body: body,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "editAutopayData", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "editAutopayData", "put");
    }
  }

  @override
  Future createAutopayData(payload) async {
    try {
      Map<String, dynamic> body = payload;
      var response = await api(
          method: "post",
          url: baseUrl + autoPayUrl,
          token: true,
          body: body,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "createAutopayData", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "createAutopayData", "post");
    }
  }

  @override
  Future disableUpcoming(id, status, otp) async {
    try {
      debugPrint(id.toString());
      Map<String, dynamic> body = {"status": int.parse(status), "otp": otp};
      logConsole(body.toString(), "disableUpcomingPay payload=>");
      var response = await api(
          method: "put",
          url: baseUrl + upcomingDisableUrl + id.toString(),
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "disableUpcoming", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "disableUpcoming", "put");
    }
  }

  @override
  Future getAllUpcomingDues() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + allUpcomingDues,
          token: true,
          checkSum: false);
      var decodedResponse = await jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getAllUpcomingDues", response);

      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getAllUpcomingDues", "get");
      return null;
    }
  }

  @override
  Future getSearchedBillers(String searchString, String? category,
      String? location, int? pageNumber) async {
    try {
      //{"searchString":"test","category":"All","location":"All","pageNumber":1}

      Map<String, dynamic> requestPayload = {
        "searchString": searchString,
        "category": category ?? "All",
        "location": location ?? "All",
        "pageNumber": pageNumber ?? 1
      };
      var response = await api(
          method: "post",
          url: baseUrl + searchBillersUrl,
          body: requestPayload,
          token: true,
          checkSum: false);
      var decodedResponse = await jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getSearchedBillers", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getSearchedBillers", "post");
      return null;
    }
  }

  @override
  Future getSavedBillers() async {
    try {
      var response = await api(
        method: "get",
        url: baseUrl + savedBillersUrl,
        token: true,
        checkSum: false,
      );
      var decodedResponse = await jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getSavedBillers", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getSavedBillers", "get");
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future getBillers(
    categoryId,
    pageNumber,
  ) async {
    try {
      Map<String, dynamic> body = {
        "categoryId": categoryId,
        "pageNumber": pageNumber
      };
      var response = await api(
          method: "post",
          url: baseUrl + billerUrl,
          body: body,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getBillers", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getBillers", "post");
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future getCategories() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + categoriesUrl,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getCategories", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getCategories", "get");
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future getLocation() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + allLocation,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "getLocation", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "getLocation", "get");
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future fetchPrepaidFetchPlans(dynamic id) async {
    try {
      var response = await api(
          method: "get",
          url:
              "$baseUrl${prepaidFetchPlansUrl}?billerId=$id&pageNumber=1&pageSize=10",
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "fetchPrepaidFetchPlans", response);
        return decodedResponse;
      } else {
        logConsole(
            response.statusCode.toString(), "AT fetchPrepaidFetchPlans : ");
        logConsole(response.body.toString(), "AT fetchPrepaidFetchPlans : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "fetchPrepaidFetchPlans", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getAccountInfo(account) async {
    /*
     {"message":"Successfully retrieved the account Info","status":200,"data":[{"accountNumber":"100003504880","balance":236655}]}
     */

    try {
      Map<String, dynamic> body = {"accountInfo": account};
      debugPrint("====================================");
      debugPrint(jsonEncode(account));
      var response = await api(
          method: "post",
          url: baseUrl + accountInfoUrl,
          body: body,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "getAccountInfo", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getAccountInfo", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getAccountInfo : ");
        logConsole(response.body.toString(), "AT getAccountInfo : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getAccountInfo", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future deleteUpcomingDue(customerBillID) async {
    try {
      logConsole(
          customerBillID.toString(), "deleteUpcomingDue ::customerBillID ");
      var response = await api(
        method: "delete",
        url: baseUrl + deleteUpcomingDueUrl + customerBillID.toString(),
        token: true,
        checkSum: false,
      );

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        debugLog(decodedResponse, "deleteUpcomingDue", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT deleteUpcomingDue : ");

        logConsole(response.body.toString(), "AT deleteUpcomingDue : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }

      // return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "deleteUpcomingDue", "delete");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getAddUpdateUpcomingDue(
      customerBillID, dueAmount, dueDate, billDate, billPeriod) async {
    /**
     {"data":{"billName":"Aishu","billerAcceptsAdhoc":"Y","billerCoverage":"IND","billerID":"OTO125007XXA63","billerIcon":"OTO12","billerName":"OTO12","billerParams":{"a":"26","a b":"70","a b c":"688","a b c d":"572","a b c d e":"582"},"categoryID":5,"customerBillID":2395,"fetchRequirement":"OPTIONAL","paymentExactness":"Exact","supportBillValidation":"NOT_SUPPORTED","validateBillAllowed":"N","dueAmount":"1000.00","dueDate":"2015-06-20"},"message":"Successfully added upcoming due","status":200}
     */
    try {
      var response;

      Map<String, dynamic> body = {
        "customerBillID": customerBillID,
        "dueAmount": dueAmount,
        "dueDate": dueDate,
        "billDate": billDate,
        "billPeriod": billPeriod
      };

      if (customerBillID != null && dueAmount != null && dueDate != null) {
        response = await api(
            method: "post",
            url: baseUrl + addUpdateUpcomingDueUrl,
            body: body,
            token: true,
            checkSum: false);
      } else {
        logInfo("Update Upcoming DUE");
        var response = await api(
            method: "get",
            url: baseUrl + updateUpcomingDueUrl,
            token: true,
            checkSum: false);
      }

      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "getAddUpdateUpcomingDue", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getAddUpdateUpcomingDue", response);
        return decodedResponse;
      } else {
        logConsole(
            response.statusCode.toString(), "AT getAddUpdateUpcomingDue : ");
        logConsole(response.body.toString(), "AT getAddUpdateUpcomingDue : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getAddUpdateUpcomingDue", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future fetchBill(validateBill, billerID, billerParams, quickPay,
      quickPayAmount, adHocBillValidationRefKey, billName) async {
    /**
         {"message":"Successfully retrieved the bill Details","status":200,"data":{"bankBranch":true,"data":{"Response":"Transaction Successful","BankRRN":"305510281912","BbpsTranlogId":"329008","ActCode":"0","Data":{"AdditionalInfo":{"Tag":[{"name":"a","value":"10"},{"name":"a b","value":"20"},{"name":"a b c","value":"30"},{"name":"a b c d","value":"40"}]},"BillerResponse":{"amount":"1000.00","dueDate":"2015-06-20","billDate":"2015-06-14","Tag":[{"name":"Late Payment Fee","value":"40"},{"name":"Fixed Charges","value":"50"},{"name":"Additional Charges","value":"60"}],"billNumber":"12303","customerName":"BBPS","billPeriod":"june"}},"ExtraData":"","SsTxnId":""},"success":true,"rc":"0","txnRefKey":"63b65efe-1a8c-4c85-8041-4ba8386743f5","fees":{"Response":"success","valid":"true","totalAmount":"1000.00","amount":"1000.00","ccf2":0,"ccf1":0,"ccf":0,"ActCode":"0"},"paymentMode":"Internet Banking"}}

         */
    Map<String, dynamic> body = {
      "validateBill": validateBill,
      "billerID": billerID,
      "billerParams": billerParams,
      "quickPay": quickPay,
      "quickPayAmount": quickPayAmount,
      "adHocBillValidationRefKey": adHocBillValidationRefKey,
      "billName": billName
    };
    logConsole(body.toString(), "fetchBill payload=> ");
    try {
      var response = await api(
          method: "post",
          url: baseUrl + fetchBillUrl,
          body: body,
          token: true,
          checkSum: false);
      inspect(response);

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "fetchBill", response);
      return decodedResponse;
      // if (!response.body.toString().contains("<html>")) {
      //   var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      //   debugLog(decodedResponse, "deleteUpcomingDue", response);
      //   return decodedResponse;
      // } else {
      //   logConsole(response.statusCode.toString(), name: "AT fetchBill : ");

      //   logConsole(response.body.toString(), name: "AT fetchBill : ");
      //   return {"status": 500, "message": "Request Timed Out", "data": "Error"};
      // }
    } catch (e) {
      errorResponseLog(e.toString(), "fetchBill", "fetchBill");
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future PrepaidFetchvalidateBill(payload) async {
    logConsole(payload.toString(), "PrepaidFetchvalidateBill payload=> ");
    try {
      var response = await api(
          method: "post",
          url: baseUrl + fetchBillUrl,
          body: payload,
          token: true,
          checkSum: false);
      inspect(response);

      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "PrepaidFetchvalidateBill", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(
          e.toString(), "PrepaidFetchvalidateBill", "PrepaidFetchvalidateBill");
      return {"status": 500, "message": "Request Timed Out", "data": "Error"};
    }
  }

  @override
  Future getAmountByDate() async {
    /**
    {"message":"Successfully retrieved the bill amount for 8159480","status":200,"data":"48000"}
     */
    try {
      var response = await api(
          method: "get",
          url: baseUrl + amountByDateUrl,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "getAmountByDate", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getAmountByDate", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getAmountByDate : ");
        logConsole(response.body.toString(), "AT getAmountByDate : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getAmountByDate", "get");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getSavedBillDetails(id) async {
    try {
      /**
       * 
       * 
      {"status":200,"data":{"inputSignatures":[{"CUSTOMER_BILL_ID":2395,"PARAMETER_NAME":"a","PARAMETER_VALUE":"26","PARAMETER_TYPE":null,"STATUS":1},{"CUSTOMER_BILL_ID":2395,"PARAMETER_NAME":"a b","PARAMETER_VALUE":"70","PARAMETER_TYPE":null,"STATUS":1},{"CUSTOMER_BILL_ID":2395,"PARAMETER_NAME":"a b c","PARAMETER_VALUE":"688","PARAMETER_TYPE":null,"STATUS":1},{"CUSTOMER_BILL_ID":2395,"PARAMETER_NAME":"a b c d","PARAMETER_VALUE":"572","PARAMETER_TYPE":null,"STATUS":1},{"CUSTOMER_BILL_ID":2395,"PARAMETER_NAME":"a b c d e","PARAMETER_VALUE":"582","PARAMETER_TYPE":null,"STATUS":1}],"billName":[{"BILL_NAME":"Aishu"}]}}

       */
      var response = await api(
          method: "get",
          url: baseUrl + savedbilldetails + id.toString(),
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "getSavedBillDetails", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getSavedBillDetails", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getSavedBillDetails : ");
        logConsole(response.body.toString(), "AT getSavedBillDetails : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getSavedBillDetails", "get");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getStatesData() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + statesDataUrl,
          token: true,
          checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        debugLog(decodedResponse, "getStatesData", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getStatesData : ");

        logConsole(response.body.toString(), "AT getStatesData : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getStatesData", "get");

      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getChartData() async {
    try {
      var response = await api(
          method: "get", url: baseUrl + chartUrl, token: true, checkSum: false);

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        debugLog(decodedResponse, "getChartData", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getChartData : ");

        logConsole(response.body.toString(), "AT getChartData : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getChartData", "get");

      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getInputSignature(id) async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + inputsignatures + id.toString(),
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "getInputSignature", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getInputSignature", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getInputSignature : ");
        logConsole(response.body.toString(), "AT getInputSignature : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getInputSignature", "get");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future addNewBiller(String BillerID, dynamic inputSignatures, String Billname,
      String otp) async {
    try {
      Map<String, dynamic> body = {
        "billerId": BillerID,
        "inputSignatures": inputSignatures,
        "billName": Billname,
        "otp": otp
      };

      var response = await api(
          method: "post",
          url: baseUrl + addNewBillerUrl,
          body: body,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // debugLog(decodedResponse, "addNewBiller", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        debugLog(decodedResponse, "addNewBiller", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT addNewBiller : ");

        logConsole(response.body.toString(), "AT addNewBiller : ");

        /**
         * 
         [AT addNewBiller : ] 200
          [AT addNewBiller : ] <html><head><title>Request Rejected</title></head><body>The requested URL was rejected. Please consult with your administrator.<br><br>Your support ID is: 9291384257056751048<br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>
         */
        var res = {
          "status": 500,
          "message":
              "The requested URL was rejected. Please consult with your administrator.",
          "data": "Error"
        };
        if (response.statusCode.toString() == 200) {
          res = {
            "status": 500,
            "message":
                "The requested URL was rejected. Please consult with your administrator.",
            "data": "Error"
          };
        } else {
          res = {
            "status": 500,
            "message": "Something went wrong",
            "data": "Error"
          };
        }
        return res;
      }
    } catch (e) {
      errorResponseLog(e.toString(), "addNewBiller", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future validateBill(payload) async {
    try {
      logConsole(payload.toString(), "AT VALIDATEBILL API");
      var response = await api(
          method: "post",
          url: baseUrl + validateBillUrl,
          token: true,
          body: payload,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      debugLog(decodedResponse, "validateBill", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "validateBill", "post");
    }
  }

  @override
  Future prepaidPayBillApi(
      String billerID,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp,
      String paymentMode,
      String forChannel,
      String paymentChannel) async {
    // Map<String, dynamic> apiPayload = {
    //   "billerId": ,
    //   "billerName": payload['billerName'],
    //   "billName": payload['billName'],
    //   "accountNumber": payload['acNo'],
    //   "billAmount": payload['billAmount'],
    //   "customerBillId": payload['customerBillID'],
    //   "transactionReferenceKey": payload['tnxRefKey'],
    //   "quickPay": payload['quickPay'],
    //   "inputSignatures": payload['inputSignature'],
    //   "paymentMode": payload['paymentMode'],
    //   "paymentChannel": payload['paymentChannel'],
    //   "forChannel": payload['forChannel'],
    //   "otp": payload['otp'],
    // };

    Map<String, dynamic> body = {};
    if (customerBillID == 0) {
      body = {
        "billerId": billerID,
        "accountNumber": acNo,
        "billAmount": billAmount,
        "transactionReferenceKey": tnxRefKey,
        "quickPay": quickPay,
        "inputSignatures": inputSignature,
        "otp": otp,
        "paymentMode": paymentMode,
        "forChannel": forChannel,
        "paymentChannel": paymentChannel
      };
    } else {
      body = {
        "billerId": billerID,
        "accountNumber": acNo,
        "billAmount": billAmount,
        "customerBillId": customerBillID,
        "transactionReferenceKey": tnxRefKey,
        "quickPay": quickPay,
        "inputSignatures": inputSignature,
        "otp": otp,
        "paymentMode": paymentMode,
        "forChannel": forChannel,
        "paymentChannel": paymentChannel
      };
    }
    try {
      var response = await api(
          method: "post",
          url: baseUrl + payBillUrl,
          body: body,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // // debugLog(decodedResponse, "pay_bill", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "payBill", response);
        return decodedResponse;

        // DONOT DELETE - paybill fail case response
        // return {
        //   "message": "Bill Payment failed for a transaction",
        //   "status": 500
        // };

        //{"message":"Bill Payment failed for a transaction","data":{"paymentDetails":{"created":"2023-02-15T07:09:24.880Z","failed":true},"transactionSteps":[{"description":"Transaction Initiated","flag":true,"pending":false},{"description":"Fund Transfer Initiated by Bank","flag":false,"pending":false},{"description":"Bill processed by Biller","flag":false,"pending":false},{"description":"Bill Payment Completed","flag":false,"pending":false}],"reason":"fund transfer failure","equitasTransactionId":"-"},"status":500}

      } else {
        logConsole(response.statusCode.toString(), "AT payBill : ");
        logConsole(response.body.toString(), "AT payBill : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "pay_bill", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future payBill(
      String billerID,
      String acNo,
      String billAmount,
      int customerBillID,
      String tnxRefKey,
      bool quickPay,
      dynamic inputSignature,
      bool otherAmount,
      String otp) async {
    try {
      Map<String, dynamic> body = {};
      if (customerBillID == 0) {
        body = {
          "billerId": billerID,
          "accountNumber": acNo,
          "billAmount": billAmount,
          "transactionReferenceKey": tnxRefKey,
          "quickPay": quickPay,
          "inputSignatures": inputSignature,
          "otherAmount": otherAmount,
          "otp": otp
        };
      } else {
        body = {
          "billerId": billerID,
          "accountNumber": acNo,
          "billAmount": billAmount,
          "customerBillId": customerBillID,
          "transactionReferenceKey": tnxRefKey,
          "quickPay": quickPay,
          "inputSignatures": inputSignature,
          "otherAmount": otherAmount,
          "otp": otp
        };
      }

      logInfo(jsonEncode(body));
      var response = await api(
          method: "post",
          url: baseUrl + payBillUrl,
          body: body,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // // debugLog(decodedResponse, "pay_bill", response);
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "payBill", response);
        return decodedResponse;

        // DONOT DELETE - paybill fail case response
        // return {
        //   "message": "Bill Payment failed for a transaction",
        //   "status": 500
        // };

        //{"message":"Bill Payment failed for a transaction","data":{"paymentDetails":{"created":"2023-02-15T07:09:24.880Z","failed":true},"transactionSteps":[{"description":"Transaction Initiated","flag":true,"pending":false},{"description":"Fund Transfer Initiated by Bank","flag":false,"pending":false},{"description":"Bill processed by Biller","flag":false,"pending":false},{"description":"Bill Payment Completed","flag":false,"pending":false}],"reason":"fund transfer failure","equitasTransactionId":"-"},"status":500}

      } else {
        logConsole(response.statusCode.toString(), "AT payBill : ");
        logConsole(response.body.toString(), "AT payBill : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "pay_bill", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future updateBillDetails(dynamic updateBillPayload) async {
    try {
      Map<String, dynamic> body = updateBillPayload;

      logInfo(body.toString());
      var response = await api(
          method: "put",
          url: baseUrl + updateBill,
          body: body,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // debugLog(decodedResponse, "UpdateBillDetails", response);
      // return decodedResponse;
      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "updateBillDetails", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT updateBillDetails : ");
        logConsole(response.body.toString(), "AT updateBillDetails : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "updateBillDetails", "put");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getPaymentInformation(id) async {
    try {
      /**
      {"status":200,"message":"Fetch Payment Modes and Channels","data":{"BILLER_ID":"OTO125007XXA63","PAYMENT_MODE":"Internet Banking","MODE_MIN_LIMIT":1,"MODE_MAX_LIMIT":9999999,"PAYMENT_CHANNEL":"INTB","MIN_LIMIT":"0.01","MAX_LIMIT":"99999.99"}}
       */
      var response = await api(
          method: "get",
          url: baseUrl + paymentInformationUrl + id.toString(),
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // debugLog(decodedResponse, "getPaymentInformation", response);
      // return decodedResponse;
      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getPaymentInformation", response);
        return decodedResponse;
      } else {
        logConsole(
            response.statusCode.toString(), "AT getPaymentInformation : ");
        logConsole(response.body.toString(), "AT getPaymentInformation : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getPaymentInformation", "get");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getBbpsSettings() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + bbpsSettings,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "getBbpsSettings", response);
      // return decodedResponse;
      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getBbpsSettings", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getBbpsSettings : ");
        logConsole(response.body.toString(), "AT getBbpsSettings : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "getBbpsSettings", "get");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future getComplaintConfig() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + complaintsConfigUrl,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      // debugLog(
      //   decodedResponse,
      //   "getComplaintConfig",
      //   response,
      // );
      // return decodedResponse;

      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "getComplaintConfig", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT getComplaintConfig : ");
        logConsole(response.body.toString(), "AT getComplaintConfig : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "complaintsConfig", "get");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future submitTxnsComplaint(complaint) async {
    try {
      var response = await api(
          method: "post",
          url: baseUrl + complaintUrl,
          body: complaint,
          token: true,
          checkSum: false);
      // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // debugLog(decodedResponse, "submitTxnsComplaint", response);
      // return decodedResponse;
      if (!response.body.toString().contains("<html>")) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        debugLog(decodedResponse, "submitTxnsComplaint", response);
        return decodedResponse;
      } else {
        logConsole(response.statusCode.toString(), "AT submitTxnsComplaint : ");
        logConsole(response.body.toString(), "AT submitTxnsComplaint : ");
        return {
          "status": 500,
          "message": "Something went wrong",
          "data": "Error"
        };
      }
    } catch (e) {
      errorResponseLog(e.toString(), "submitTxnsComplaint", "post");
      return {
        "status": 500,
        "message": "Something went wrong",
        "data": "Error"
      };
    }
  }

  @override
  Future updateUpcomingdue() async {
    try {
      var response = await api(
          method: "get",
          url: baseUrl + updateUpcomingDueUrl,
          token: true,
          checkSum: false);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      debugLog(decodedResponse, "UpdateUpcomingDUE", response);
      return decodedResponse;
    } catch (e) {
      errorResponseLog(e.toString(), "UpdateUpcomingDUE", "get");
    }
  }
}
