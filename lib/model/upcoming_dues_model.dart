class UpcomingDuesModel {
  List<UpcomingDuesData>? data;
  String? message;
  int? status;

  UpcomingDuesModel({this.data, this.message, this.status});

  UpcomingDuesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UpcomingDuesData>[];
      json['data'].forEach((v) {
        data!.add(new UpcomingDuesData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class UpcomingDuesData {
  String? billName;
  String? billerAcceptsAdhoc;
  String? billerCoverage;
  String? billerID;
  String? billerIcon;
  String? billerName;
  BillerParams? billerParams;
  int? categoryID;
  String? categoryName;
  int? customerBillID;
  String? fetchRequirement;
  String? paymentExactness;
  String? supportBillValidation;
  String? validateBillAllowed;
  String? dueAmount;
  String? dueDate;

  UpcomingDuesData(
      {this.billName,
      this.billerAcceptsAdhoc,
      this.billerCoverage,
      this.billerID,
      this.billerIcon,
      this.billerName,
      this.billerParams,
      this.categoryID,
      this.categoryName,
      this.customerBillID,
      this.fetchRequirement,
      this.paymentExactness,
      this.supportBillValidation,
      this.validateBillAllowed,
      this.dueAmount,
      this.dueDate});

  UpcomingDuesData.fromJson(Map<String, dynamic> json) {
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
    categoryName = json['categoryName'];
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
    data['categoryName'] = this.categoryName;
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
  String? customerReferenceField1;
  String? customerReferenceField2;

  BillerParams({this.customerReferenceField1, this.customerReferenceField2});

  BillerParams.fromJson(Map<String, dynamic> json) {
    customerReferenceField1 = json['Customer Reference Field 1'];
    customerReferenceField2 = json['Customer Reference Field 2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customer Reference Field 1'] = this.customerReferenceField1;
    data['Customer Reference Field 2'] = this.customerReferenceField2;
    return data;
  }
}
