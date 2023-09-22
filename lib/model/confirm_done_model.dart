class confirmDoneModel {
  String? message;
  confirmDoneData? data;
  int? status;

  confirmDoneModel({this.message, this.data, this.status});

  confirmDoneModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null
        ? new confirmDoneData.fromJson(json['data'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class confirmDoneData {
  PaymentDetails? paymentDetails;
  List<TransactionSteps>? transactionSteps;
  String? equitasTransactionId;
  int? insertedTransaction;

  confirmDoneData(
      {this.paymentDetails,
      this.transactionSteps,
      this.equitasTransactionId,
      this.insertedTransaction});

  confirmDoneData.fromJson(Map<String, dynamic> json) {
    paymentDetails = json['paymentDetails'] != null
        ? new PaymentDetails.fromJson(json['paymentDetails'])
        : null;
    if (json['transactionSteps'] != null) {
      transactionSteps = <TransactionSteps>[];
      json['transactionSteps'].forEach((v) {
        transactionSteps!.add(new TransactionSteps.fromJson(v));
      });
    }
    equitasTransactionId = json['equitasTransactionId'];
    insertedTransaction = json['insertedTransaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentDetails != null) {
      data['paymentDetails'] = this.paymentDetails!.toJson();
    }
    if (this.transactionSteps != null) {
      data['transactionSteps'] =
          this.transactionSteps!.map((v) => v.toJson()).toList();
    }
    data['equitasTransactionId'] = this.equitasTransactionId;
    data['insertedTransaction'] = this.insertedTransaction;
    return data;
  }
}

class PaymentDetails {
  String? message;
  String? actCode;
  bool? success;
  String? rc;
  Tran? tran;
  BbpsResponse? bbpsResponse;

  //failure
  String? created;
  bool? failed;

  PaymentDetails(
      {this.message,
      this.actCode,
      this.success,
      this.rc,
      this.tran,
      this.bbpsResponse,
      this.created,
      this.failed});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    actCode = json['actCode'];
    success = json['success'];
    rc = json['rc'];
    tran = json['tran'] != null ? new Tran.fromJson(json['tran']) : null;
    bbpsResponse = json['bbpsResponse'] != null
        ? new BbpsResponse.fromJson(json['bbpsResponse'])
        : null;

    created = json['created'];
    failed = json['failed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['actCode'] = this.actCode;
    data['success'] = this.success;
    data['rc'] = this.rc;
    if (this.tran != null) {
      data['tran'] = this.tran!.toJson();
    }
    if (this.bbpsResponse != null) {
      data['bbpsResponse'] = this.bbpsResponse!.toJson();
    }
    data['created'] = this.created;
    data['failed'] = this.failed;
    return data;
  }
}

class Tran {
  int? id;
  int? instituteId;
  int? userId;
  int? mobile;
  String? biller;
  int? amount;
  String? pg;
  String? status;
  int? created;
  String? pgRef;
  String? bankRef;
  String? bill;
  String? pgResponse;
  String? email;
  String? criteria;
  String? switchResponse;
  int? fee;
  int? type;
  int? totalAmount;
  String? paymentMode;
  String? paymentChannel;
  String? switchRef;
  String? amountDetails;
  String? quickPay;
  int? ccf1;
  int? ccf2;
  int? ouId;
  int? agentId;
  int? agentGroupId;
  String? channelName;
  String? switchActCode;
  String? approvalRefNo;
  String? txnOrigin;
  String? cu;
  int? tranLogId;
  String? txnRefKey;
  String? switchRespStatus;

  Tran(
      {this.id,
      this.instituteId,
      this.userId,
      this.mobile,
      this.biller,
      this.amount,
      this.pg,
      this.status,
      this.created,
      this.pgRef,
      this.bankRef,
      this.bill,
      this.pgResponse,
      this.email,
      this.criteria,
      this.switchResponse,
      this.fee,
      this.type,
      this.totalAmount,
      this.paymentMode,
      this.paymentChannel,
      this.switchRef,
      this.amountDetails,
      this.quickPay,
      this.ccf1,
      this.ccf2,
      this.ouId,
      this.agentId,
      this.agentGroupId,
      this.channelName,
      this.switchActCode,
      this.approvalRefNo,
      this.txnOrigin,
      this.cu,
      this.tranLogId,
      this.txnRefKey,
      this.switchRespStatus});

  Tran.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    instituteId = json['instituteId'];
    userId = json['userId'];
    mobile = json['mobile'];
    biller = json['biller'];
    amount = json['amount'];
    pg = json['pg'];
    status = json['status'];
    created = json['created'];
    pgRef = json['pgRef'];
    bankRef = json['bankRef'];
    bill = json['bill'];
    pgResponse = json['pgResponse'];
    email = json['email'];
    criteria = json['criteria'];
    switchResponse = json['switchResponse'];
    fee = json['fee'];
    type = json['type'];
    totalAmount = json['totalAmount'];
    paymentMode = json['paymentMode'];
    paymentChannel = json['paymentChannel'];
    switchRef = json['switchRef'];
    amountDetails = json['amountDetails'];
    quickPay = json['quickPay'];
    ccf1 = json['ccf1'];
    ccf2 = json['ccf2'];
    ouId = json['ouId'];
    agentId = json['agentId'];
    agentGroupId = json['agentGroupId'];
    channelName = json['channelName'];
    switchActCode = json['switchActCode'];
    approvalRefNo = json['approvalRefNo'];
    txnOrigin = json['txnOrigin'];
    cu = json['cu'];
    tranLogId = json['tranLogId'];
    txnRefKey = json['txnRefKey'];
    switchRespStatus = json['switchRespStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['instituteId'] = this.instituteId;
    data['userId'] = this.userId;
    data['mobile'] = this.mobile;
    data['biller'] = this.biller;
    data['amount'] = this.amount;
    data['pg'] = this.pg;
    data['status'] = this.status;
    data['created'] = this.created;
    data['pgRef'] = this.pgRef;
    data['bankRef'] = this.bankRef;
    data['bill'] = this.bill;
    data['pgResponse'] = this.pgResponse;
    data['email'] = this.email;
    data['criteria'] = this.criteria;
    data['switchResponse'] = this.switchResponse;
    data['fee'] = this.fee;
    data['type'] = this.type;
    data['totalAmount'] = this.totalAmount;
    data['paymentMode'] = this.paymentMode;
    data['paymentChannel'] = this.paymentChannel;
    data['switchRef'] = this.switchRef;
    data['amountDetails'] = this.amountDetails;
    data['quickPay'] = this.quickPay;
    data['ccf1'] = this.ccf1;
    data['ccf2'] = this.ccf2;
    data['ouId'] = this.ouId;
    data['agentId'] = this.agentId;
    data['agentGroupId'] = this.agentGroupId;
    data['channelName'] = this.channelName;
    data['switchActCode'] = this.switchActCode;
    data['approvalRefNo'] = this.approvalRefNo;
    data['txnOrigin'] = this.txnOrigin;
    data['cu'] = this.cu;
    data['tranLogId'] = this.tranLogId;
    data['txnRefKey'] = this.txnRefKey;
    data['switchRespStatus'] = this.switchRespStatus;
    return data;
  }
}

class BbpsResponse {
  String? response;
  String? bankRRN;
  String? bbpsTranlogId;
  String? actCode;
  Data? data;
  String? extraData;
  String? ssTxnId;

  BbpsResponse(
      {this.response,
      this.bankRRN,
      this.bbpsTranlogId,
      this.actCode,
      this.data,
      this.extraData,
      this.ssTxnId});

  BbpsResponse.fromJson(Map<String, dynamic> json) {
    response = json['Response'];
    bankRRN = json['BankRRN'];
    bbpsTranlogId = json['BbpsTranlogId'];
    actCode = json['ActCode'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
    extraData = json['ExtraData'];
    ssTxnId = json['SsTxnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class Data {
  BillerResponse? billerResponse;
  String? approvalRefNum;
  String? txnReferenceId;

  Data({this.billerResponse, this.approvalRefNum, this.txnReferenceId});

  Data.fromJson(Map<String, dynamic> json) {
    billerResponse = json['BillerResponse'] != null
        ? new BillerResponse.fromJson(json['BillerResponse'])
        : null;
    approvalRefNum = json['approvalRefNum'];
    txnReferenceId = json['txnReferenceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.billerResponse != null) {
      data['BillerResponse'] = this.billerResponse!.toJson();
    }
    data['approvalRefNum'] = this.approvalRefNum;
    data['txnReferenceId'] = this.txnReferenceId;
    return data;
  }
}

class BillerResponse {
  String? amount;
  String? custConvFee;
  String? dueDate;
  String? billDate;
  String? billNumber;
  String? customerName;
  String? billPeriod;

  BillerResponse(
      {this.amount,
      this.custConvFee,
      this.dueDate,
      this.billDate,
      this.billNumber,
      this.customerName,
      this.billPeriod});

  BillerResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    custConvFee = json['custConvFee'];
    dueDate = json['dueDate'];
    billDate = json['billDate'];
    billNumber = json['billNumber'];
    customerName = json['customerName'];
    billPeriod = json['billPeriod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['custConvFee'] = this.custConvFee;
    data['dueDate'] = this.dueDate;
    data['billDate'] = this.billDate;
    data['billNumber'] = this.billNumber;
    data['customerName'] = this.customerName;
    data['billPeriod'] = this.billPeriod;
    return data;
  }
}

class TransactionSteps {
  String? description;
  bool? flag;
  bool? pending;

  TransactionSteps({this.description, this.flag, this.pending});

  TransactionSteps.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    flag = json['flag'];
    pending = json['pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['flag'] = this.flag;
    data['pending'] = this.pending;
    return data;
  }
}
