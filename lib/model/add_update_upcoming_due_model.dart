class AddUpdateUpcomingModel {
  AddUpdateUpcomingData? data;
  String? message;
  int? status;

  AddUpdateUpcomingModel({this.data, this.message, this.status});

  AddUpdateUpcomingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new AddUpdateUpcomingData.fromJson(json['data'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class AddUpdateUpcomingData {
  String? billName;
  String? billerAcceptsAdhoc;
  String? billerCoverage;
  String? billerID;
  String? billerIcon;
  String? billerName;
  BillerParams? billerParams;
  int? categoryID;
  int? customerBillID;
  String? fetchRequirement;
  String? paymentExactness;
  String? supportBillValidation;
  String? validateBillAllowed;
  String? dueAmount;
  String? dueDate;

  AddUpdateUpcomingData(
      {this.billName,
      this.billerAcceptsAdhoc,
      this.billerCoverage,
      this.billerID,
      this.billerIcon,
      this.billerName,
      this.billerParams,
      this.categoryID,
      this.customerBillID,
      this.fetchRequirement,
      this.paymentExactness,
      this.supportBillValidation,
      this.validateBillAllowed,
      this.dueAmount,
      this.dueDate});

  AddUpdateUpcomingData.fromJson(Map<String, dynamic> json) {
    billName = json['billName'];
    billerAcceptsAdhoc = json['billerAcceptsAdhoc'];
    billerCoverage = json['billerCoverage'];
    billerID = json['billerID'];
    billerIcon = json['billerIcon'];
    billerName = json['billerName'];
    billerParams = json['billerParams'] != null
        ? new BillerParams.fromJson(json['billerParams'])
        : null;
    categoryID = json['categoryID'];
    customerBillID = json['customerBillID'];
    fetchRequirement = json['fetchRequirement'];
    paymentExactness = json['paymentExactness'];
    supportBillValidation = json['supportBillValidation'];
    validateBillAllowed = json['validateBillAllowed'];
    dueAmount = json['dueAmount'];
    dueDate = json['dueDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billName'] = this.billName;
    data['billerAcceptsAdhoc'] = this.billerAcceptsAdhoc;
    data['billerCoverage'] = this.billerCoverage;
    data['billerID'] = this.billerID;
    data['billerIcon'] = this.billerIcon;
    data['billerName'] = this.billerName;
    if (this.billerParams != null) {
      data['billerParams'] = this.billerParams!.toJson();
    }
    data['categoryID'] = this.categoryID;
    data['customerBillID'] = this.customerBillID;
    data['fetchRequirement'] = this.fetchRequirement;
    data['paymentExactness'] = this.paymentExactness;
    data['supportBillValidation'] = this.supportBillValidation;
    data['validateBillAllowed'] = this.validateBillAllowed;
    data['dueAmount'] = this.dueAmount;
    data['dueDate'] = this.dueDate;
    return data;
  }
}

class BillerParams {
  String? a;
  String? aB;
  String? aBC;
  String? aBCD;
  String? aBCDE;

  BillerParams({this.a, this.aB, this.aBC, this.aBCD, this.aBCDE});

  BillerParams.fromJson(Map<String, dynamic> json) {
    a = json['a'];
    aB = json['a b'];
    aBC = json['a b c'];
    aBCD = json['a b c d'];
    aBCDE = json['a b c d e'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['a'] = this.a;
    data['a b'] = this.aB;
    data['a b c'] = this.aBC;
    data['a b c d'] = this.aBCD;
    data['a b c d e'] = this.aBCDE;
    return data;
  }
}
