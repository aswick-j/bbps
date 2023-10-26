class FetchBillModel {
  String? message;
  int? status;
  billerResponseData? data;

  FetchBillModel({this.message, this.status, this.data});

  FetchBillModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data =
        json['data'] != null ? billerResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class billerResponseData {
  bool? bankBranch;
  TransactionData? data;
  bool? success;
  String? rc;
  String? txnRefKey;
  Fees? fees;
  String? paymentMode;
  int? customerbillId;

  billerResponseData(
      {this.bankBranch,
      this.data,
      this.success,
      this.rc,
      this.txnRefKey,
      this.fees,
      this.paymentMode,
      this.customerbillId});

  billerResponseData.fromJson(Map<String, dynamic> json) {
    bankBranch = json['bankBranch'];
    data = json['data'] != null ? TransactionData.fromJson(json['data']) : null;
    success = json['success'];
    rc = json['rc'];
    txnRefKey = json['txnRefKey'];
    fees = json['fees'] != null ? Fees.fromJson(json['fees']) : null;
    paymentMode = json['paymentMode'];
    customerbillId = json['customerbillId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bankBranch'] = this.bankBranch;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = this.success;
    data['rc'] = this.rc;
    data['txnRefKey'] = this.txnRefKey;
    if (this.fees != null) {
      data['fees'] = this.fees!.toJson();
    }
    data['paymentMode'] = this.paymentMode;
    data['customerbillId'] = this.customerbillId;
    return data;
  }
}

class TransactionData {
  String? response;
  String? bankRRN;
  String? bbpsTranlogId;
  String? actCode;
  BillerData? data;
  String? extraData;
  String? ssTxnId;

  TransactionData(
      {this.response,
      this.bankRRN,
      this.bbpsTranlogId,
      this.actCode,
      this.data,
      this.extraData,
      this.ssTxnId});

  TransactionData.fromJson(Map<String, dynamic> json) {
    response = json['Response'];
    bankRRN = json['BankRRN'];
    bbpsTranlogId = json['BbpsTranlogId'];
    actCode = json['ActCode'];
    data = json['Data'] != null ? BillerData.fromJson(json['Data']) : null;
    extraData = json['ExtraData'];
    ssTxnId = json['SsTxnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Response'] = this.response;
    data['BankRRN'] = this.bankRRN;
    data['BbpsTranlogId'] = this.bbpsTranlogId;
    data['ActCode'] = this.actCode;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    data['ExtraData'] = this.extraData;
    data['SsTxnId'] = this.ssTxnId;
    return data;
  }
}

class BillerData {
  AdditionalInfo? additionalInfo;
  BillerResponse? billerResponse;

  BillerData.fromJson(Map<String, dynamic> json) {
    if (json['AdditionalInfo'] != null) {
      if (json['AdditionalInfo'] != "") {
        additionalInfo = AdditionalInfo.fromJson(json['AdditionalInfo']);
      } else {
        additionalInfo = AdditionalInfo(tag: []);
      }
    } else {
      additionalInfo = AdditionalInfo(tag: []);
    }

    if (json['BillerResponse'] != null) {
      if (json['BillerResponse'] != "") {
        billerResponse = BillerResponse.fromJson(json['BillerResponse']);
      } else {
        billerResponse = BillerResponse(tag: []);
      }
    } else {
      billerResponse = BillerResponse(tag: []);
    }
    // billerResponse = json['BillerResponse'] != null
    //     ? BillerResponse.fromJson(json['BillerResponse'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    if (this.additionalInfo != null) {
      data['AdditionalInfo'] = this.additionalInfo!.toJson();
    } else {
      data['AdditionalInfo'] = [];
    }
    if (this.billerResponse != null) {
      data['BillerResponse'] = this.billerResponse!.toJson();
    } else {
      data["BillerResponse"] = [];
    }
    return data;
  }
}

class AdditionalInfo {
  List<Tag>? tag;

  AdditionalInfo({this.tag});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    if (json['Tag'] != null) {
      tag = <Tag>[];
      json['Tag'].forEach((v) {
        tag!.add(Tag.fromJson(v));
      });
    } else {
      tag = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.tag != null) {
      data['Tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tag {
  String? name;
  String? value;

  Tag({this.name, this.value});

  Tag.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class BillerResponse {
  String? amount;
  String? dueDate;
  String? billDate;
  List<Tag>? tag;
  String? billNumber;
  String? customerName;
  String? billPeriod;

  BillerResponse(
      {this.amount,
      this.dueDate,
      this.billDate,
      this.tag,
      this.billNumber,
      this.customerName,
      this.billPeriod});

  BillerResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    dueDate = json['dueDate'];
    billDate = json['billDate'];
    if (json['Tag'] != null) {
      tag = <Tag>[];
      json['Tag'].forEach((v) {
        tag!.add(Tag.fromJson(v));
      });
    } else {
      tag = [];
    }
    billNumber = json['billNumber'];
    customerName = json['customerName'];
    billPeriod = json['billPeriod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amount'] = this.amount;
    data['dueDate'] = this.dueDate;
    data['billDate'] = this.billDate;
    if (this.tag != null) {
      data['Tag'] = this.tag!.map((v) => v.toJson()).toList();
    }
    data['billNumber'] = this.billNumber;
    data['customerName'] = this.customerName;
    data['billPeriod'] = this.billPeriod;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
