class AutoSchedulePayModel {
  int? status;
  String? message;
  AutoSchedulePayData? data;

  AutoSchedulePayModel({this.status, this.message, this.data});

  AutoSchedulePayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new AutoSchedulePayData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AutoSchedulePayData {
  String? customerID;
  List<AllConfigurations>? allConfigurations;
  List<UpcomingPayments>? upcomingPayments;
  var maxAllowedAmount;

  AutoSchedulePayData(
      {this.customerID,
      this.allConfigurations,
      this.upcomingPayments,
      this.maxAllowedAmount});

  AutoSchedulePayData.fromJson(Map<String, dynamic> json) {
    customerID = json['customerID'];
    if (json['allConfigurations'] != null) {
      allConfigurations = <AllConfigurations>[];
      json['allConfigurations'].forEach((v) {
        allConfigurations!.add(new AllConfigurations.fromJson(v));
      });
    }
    if (json['upcomingPayments'] != null) {
      upcomingPayments = <UpcomingPayments>[];
      json['upcomingPayments'].forEach((v) {
        upcomingPayments!.add(new UpcomingPayments.fromJson(v));
      });
    }
    maxAllowedAmount = json['maxAllowedAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerID'] = this.customerID;
    if (this.allConfigurations != null) {
      data['allConfigurations'] =
          this.allConfigurations!.map((v) => v.toJson()).toList();
    }
    if (this.upcomingPayments != null) {
      data['upcomingPayments'] =
          this.upcomingPayments!.map((v) => v.toJson()).toList();
    }
    data['maxAllowedAmount'] = this.maxAllowedAmount;
    return data;
  }
}

class AllConfigurations {
  String? paymentDate;
  List<AllConfigurationsData>? data;
  String? activatesFrom;

  AllConfigurations({this.paymentDate, this.data, this.activatesFrom});

  AllConfigurations.fromJson(Map<String, dynamic> json) {
    paymentDate = json['paymentDate'];
    if (json['data'] != null) {
      data = <AllConfigurationsData>[];
      json['data'].forEach((v) {
        data!.add(new AllConfigurationsData.fromJson(v));
      });
    }
    activatesFrom = json['activates_from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentDate'] = this.paymentDate;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['activates_from'] = this.activatesFrom;
    return data;
  }
}

class AllConfigurationsData {
  int? iD;
  String? aCCOUNTNUMBER;
  String? cUSTOMERID;
  var mAXIMUMAMOUNT;
  String? pAYMENTDATE;
  int? iSACTIVE;
  int? iSBIMONTHLY;
  String? aCTIVATESFROM;
  int? cUSTOMERBILLID;
  String? bILLNAME;
  String? bILLERID;
  String? bILLERICON;
  String? bILLERNAME;
  int? pAID;
  int? aMOUNTLIMIT;

  AllConfigurationsData(
      {this.iD,
      this.aCCOUNTNUMBER,
      this.cUSTOMERID,
      this.mAXIMUMAMOUNT,
      this.pAYMENTDATE,
      this.iSACTIVE,
      this.iSBIMONTHLY,
      this.aCTIVATESFROM,
      this.cUSTOMERBILLID,
      this.bILLNAME,
      this.bILLERID,
      this.bILLERICON,
      this.bILLERNAME,
      this.pAID,
      this.aMOUNTLIMIT});

  AllConfigurationsData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    aCCOUNTNUMBER = json['ACCOUNT_NUMBER'];
    cUSTOMERID = json['CUSTOMER_ID'];
    mAXIMUMAMOUNT = json['MAXIMUM_AMOUNT'];
    pAYMENTDATE = json['PAYMENT_DATE'];
    iSACTIVE = json['IS_ACTIVE'];
    iSBIMONTHLY = json['IS_BIMONTHLY'];
    aCTIVATESFROM = json['ACTIVATES_FROM'];
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    bILLNAME = json['BILL_NAME'];
    bILLERID = json['BILLER_ID'];
    bILLERICON = json['BILLER_ICON'];
    bILLERNAME = json['BILLER_NAME'];
    pAID = json['PAID'];
    aMOUNTLIMIT = json['AMOUNT_LIMIT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ACCOUNT_NUMBER'] = this.aCCOUNTNUMBER;
    data['CUSTOMER_ID'] = this.cUSTOMERID;
    data['MAXIMUM_AMOUNT'] = this.mAXIMUMAMOUNT;
    data['PAYMENT_DATE'] = this.pAYMENTDATE;
    data['IS_ACTIVE'] = this.iSACTIVE;
    data['IS_BIMONTHLY'] = this.iSBIMONTHLY;
    data['ACTIVATES_FROM'] = this.aCTIVATESFROM;
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['BILL_NAME'] = this.bILLNAME;
    data['BILLER_ID'] = this.bILLERID;
    data['BILLER_ICON'] = this.bILLERICON;
    data['BILLER_NAME'] = this.bILLERNAME;
    data['PAID'] = this.pAID;
    data['AMOUNT_LIMIT'] = this.aMOUNTLIMIT;
    return data;
  }
}

class UpcomingPayments {
  String? activatesFrom;
  List<UpcomingPaymentsData>? data;

  UpcomingPayments({this.activatesFrom, this.data});

  UpcomingPayments.fromJson(Map<String, dynamic> json) {
    activatesFrom = json['activates_from'];
    if (json['data'] != null) {
      data = <UpcomingPaymentsData>[];
      json['data'].forEach((v) {
        data!.add(new UpcomingPaymentsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activates_from'] = this.activatesFrom;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingPaymentsData {
  int? iD;
  String? aCCOUNTNUMBER;
  String? cUSTOMERID;
  var mAXIMUMAMOUNT;
  String? pAYMENTDATE;
  int? iSACTIVE;
  String? cREATEDAT;
  int? iSBIMONTHLY;
  var aCTIVATESFROM;
  String? dUEAMOUNT;
  String? dUEDATE;
  int? cUSTOMERBILLID;
  String? cATEGORYNAME;
  String? bILLNAME;
  String? bILLERID;
  String? bILLERICON;
  String? bILLERNAME;

  UpcomingPaymentsData(
      {this.iD,
      this.aCCOUNTNUMBER,
      this.cUSTOMERID,
      this.mAXIMUMAMOUNT,
      this.pAYMENTDATE,
      this.iSACTIVE,
      this.cREATEDAT,
      this.iSBIMONTHLY,
      this.aCTIVATESFROM,
      this.dUEAMOUNT,
      this.dUEDATE,
      this.cUSTOMERBILLID,
      this.cATEGORYNAME,
      this.bILLNAME,
      this.bILLERID,
      this.bILLERICON,
      this.bILLERNAME});

  UpcomingPaymentsData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    aCCOUNTNUMBER = json['ACCOUNT_NUMBER'];
    cUSTOMERID = json['CUSTOMER_ID'];
    mAXIMUMAMOUNT = json['MAXIMUM_AMOUNT'];
    pAYMENTDATE = json['PAYMENT_DATE'];
    iSACTIVE = json['IS_ACTIVE'];
    cREATEDAT = json['CREATED_AT'];
    iSBIMONTHLY = json['IS_BIMONTHLY'];
    aCTIVATESFROM = json['ACTIVATES_FROM'];
    dUEAMOUNT = json['DUE_AMOUNT'];
    dUEDATE = json['DUE_DATE'];
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    bILLNAME = json['BILL_NAME'];
    bILLERID = json['BILLER_ID'];
    bILLERICON = json['BILLER_ICON'];
    bILLERNAME = json['BILLER_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['ACCOUNT_NUMBER'] = this.aCCOUNTNUMBER;
    data['CUSTOMER_ID'] = this.cUSTOMERID;
    data['MAXIMUM_AMOUNT'] = this.mAXIMUMAMOUNT;
    data['PAYMENT_DATE'] = this.pAYMENTDATE;
    data['IS_ACTIVE'] = this.iSACTIVE;
    data['CREATED_AT'] = this.cREATEDAT;
    data['IS_BIMONTHLY'] = this.iSBIMONTHLY;
    data['ACTIVATES_FROM'] = this.aCTIVATESFROM;
    data['DUE_AMOUNT'] = this.dUEAMOUNT;
    data['DUE_DATE'] = this.dUEDATE;
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    data['BILL_NAME'] = this.bILLNAME;
    data['BILLER_ID'] = this.bILLERID;
    data['BILLER_ICON'] = this.bILLERICON;
    data['BILLER_NAME'] = this.bILLERNAME;
    return data;
  }
}
