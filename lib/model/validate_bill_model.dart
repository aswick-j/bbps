class ValidateBillModel {
  String? message;
  int? status;
  ValidateBillResponseData? data;

  ValidateBillModel({this.message, this.status, this.data});

  ValidateBillModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? ValidateBillResponseData.fromJson(
            Map<String, dynamic>.from(json['data']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ValidateBillResponseData {
  ValidateBillTransactionData? data;
  bool? bankBranch;
  String? txnRefKey;
  bool? success;
  Bill? bill;
  Fees? fees;
  String? rc;
  String? paymentMode;

  ValidateBillResponseData(
      {this.data,
      this.bankBranch,
      this.txnRefKey,
      this.success,
      this.bill,
      this.fees,
      this.rc,
      this.paymentMode});

  ValidateBillResponseData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new ValidateBillTransactionData.fromJson(json['data'])
        : null;
    bankBranch = json['bankBranch'];
    txnRefKey = json['txnRefKey'];
    success = json['success'];
    bill = json['bill'] != null ? new Bill.fromJson(json['bill']) : null;
    fees = json['fees'] != null ? new Fees.fromJson(json['fees']) : null;
    rc = json['rc'];
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['bankBranch'] = this.bankBranch;
    data['txnRefKey'] = this.txnRefKey;
    data['success'] = this.success;
    if (this.bill != null) {
      data['bill'] = this.bill!.toJson();
    }
    if (this.fees != null) {
      data['fees'] = this.fees!.toJson();
    }
    data['rc'] = this.rc;
    data['paymentMode'] = this.paymentMode;
    return data;
  }
}

class ValidateBillTransactionData {
  String? response;
  String? bankRRN;
  String? bbpsTranlogId;
  String? actCode;
  dynamic data;
  String? extraData;
  String? ssTxnId;

  ValidateBillTransactionData(
      {this.response,
      this.bankRRN,
      this.bbpsTranlogId,
      this.actCode,
      this.data,
      this.extraData,
      this.ssTxnId});

  ValidateBillTransactionData.fromJson(Map<String, dynamic> json) {
    response = json['Response'];
    bankRRN = json['BankRRN'];
    bbpsTranlogId = json['BbpsTranlogId'];
    actCode = json['ActCode'];
    data = json['Data'] != null
        ? ValidateBillTransactionData.fromJson(json['Data'])
        : null;

    extraData = json['ExtraData'];
    ssTxnId = json['SsTxnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Response'] = this.response;
    data['BankRRN'] = this.bankRRN;
    data['BbpsTranlogId'] = this.bbpsTranlogId;
    data['ActCode'] = this.actCode;
    data['Data'] = this.data;
    data['ExtraData'] = this.extraData;
    data['SsTxnId'] = this.ssTxnId;
    return data;
  }
}

class Bill {
  BillData? data;
  String? switchFetchRef;

  Bill({this.data, this.switchFetchRef});

  Bill.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BillData.fromJson(json['data']) : null;
    switchFetchRef = json['switchFetchRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['switchFetchRef'] = this.switchFetchRef;
    return data;
  }
}

class BillData {
  ValidateBillerResponse? billerResponse;

  BillData({this.billerResponse});

  BillData.fromJson(Map<String, dynamic> json) {
    billerResponse = json['BillerResponse'] != null
        ? new ValidateBillerResponse.fromJson(json['BillerResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billerResponse != null) {
      data['BillerResponse'] = this.billerResponse!.toJson();
    }
    return data;
  }
}

class ValidateBillerResponse {
  String? amount;

  ValidateBillerResponse({this.amount});

  ValidateBillerResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    return data;
  }
}

class Fees {
  String? response;
  String? valid;
  String? totalAmount;
  String? amount;
  int? ccf2;
  int? ccf1;
  int? ccf;
  String? actCode;

  Fees(
      {this.response,
      this.valid,
      this.totalAmount,
      this.amount,
      this.ccf2,
      this.ccf1,
      this.ccf,
      this.actCode});

  Fees.fromJson(Map<String, dynamic> json) {
    response = json['Response'];
    valid = json['valid'];
    totalAmount = json['totalAmount'];
    amount = json['amount'];
    ccf2 = json['ccf2'];
    ccf1 = json['ccf1'];
    ccf = json['ccf'];
    actCode = json['ActCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Response'] = this.response;
    data['valid'] = this.valid;
    data['totalAmount'] = this.totalAmount;
    data['amount'] = this.amount;
    data['ccf2'] = this.ccf2;
    data['ccf1'] = this.ccf1;
    data['ccf'] = this.ccf;
    data['ActCode'] = this.actCode;
    return data;
  }
}
