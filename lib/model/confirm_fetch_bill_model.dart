class ConfirmFetchBillModel {
  String? message;
  int? status;
  ConfirmFetchBillData? data;

  ConfirmFetchBillModel({this.message, this.status, this.data});

  ConfirmFetchBillModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new ConfirmFetchBillData.fromJson(json['data'])
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

class ConfirmFetchBillData {
  bool? bankBranch;
  String? txnRefKey;
  bool? success;
  Bill? bill;
  Fees? fees;
  String? rc;
  String? paymentMode;
  int? customerbillId;

  ConfirmFetchBillData(
      {this.bankBranch,
      this.txnRefKey,
      this.success,
      this.bill,
      this.fees,
      this.rc,
      this.paymentMode,
      this.customerbillId});

  ConfirmFetchBillData.fromJson(Map<String, dynamic> json) {
    bankBranch = json['bankBranch'];
    txnRefKey = json['txnRefKey'];
    success = json['success'];
    bill = json['bill'] != null ? new Bill.fromJson(json['bill']) : null;
    fees = json['fees'] != null ? new Fees.fromJson(json['fees']) : null;
    rc = json['rc'];
    paymentMode = json['paymentMode'];
    customerbillId = json['customerbillId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['customerbillId'] = this.customerbillId;
    return data;
  }
}

class Bill {
  Data? data;

  Bill({this.data});

  Bill.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  ConfirmBillerResponse? billerResponse;

  Data({this.billerResponse});

  Data.fromJson(Map<String, dynamic> json) {
    billerResponse = json['BillerResponse'] != null
        ? new ConfirmBillerResponse.fromJson(json['BillerResponse'])
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

class ConfirmBillerResponse {
  String? amount;

  ConfirmBillerResponse({this.amount});

  ConfirmBillerResponse.fromJson(Map<String, dynamic> json) {
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
