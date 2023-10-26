class PrepaidFetchPlansModel {
  String? message;
  int? status;
  ResponseData? data;

  PrepaidFetchPlansModel({this.message, this.status, this.data});

  PrepaidFetchPlansModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data =
        json['data'] != null ? new ResponseData.fromJson(json['data']) : null;
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

class ResponseData {
  bool? success;
  String? rc;
  List<PrepaidPlansData>? data;

  ResponseData({this.success, this.rc, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    rc = json['rc'];
    if (json['data'] != null) {
      data = <PrepaidPlansData>[];
      json['data'].forEach((v) {
        data!.add(new PrepaidPlansData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['rc'] = this.rc;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrepaidPlansData {
  String? categoryType;
  String? billerPlanId;
  String? billerId;
  int? amount;
  String? planDesc;
  String? createdDate;
  PlanAdditionalInfo? planAdditionalInfo;
  int? id;
  String? updatedDate;
  String? version;
  String? effectiveFrom;
  String? status;

  PrepaidPlansData(
      {this.categoryType,
      this.billerPlanId,
      this.billerId,
      this.amount,
      this.planDesc,
      this.createdDate,
      this.planAdditionalInfo,
      this.id,
      this.updatedDate,
      this.version,
      this.effectiveFrom,
      this.status});

  PrepaidPlansData.fromJson(Map<String, dynamic> json) {
    categoryType = json['categoryType'];
    billerPlanId = json['billerPlanId'];
    billerId = json['billerId'];
    amount = json['amount'];
    planDesc = json['planDesc'];
    createdDate = json['createdDate'];
    planAdditionalInfo = json['planAdditionalInfo'] != null
        ? new PlanAdditionalInfo.fromJson(json['planAdditionalInfo'])
        : null;
    id = json['id'];
    updatedDate = json['updatedDate'];
    version = json['version'];
    effectiveFrom = json['effectiveFrom'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryType'] = this.categoryType;
    data['billerPlanId'] = this.billerPlanId;
    data['billerId'] = this.billerId;
    data['amount'] = this.amount;
    data['planDesc'] = this.planDesc;
    data['createdDate'] = this.createdDate;
    if (this.planAdditionalInfo != null) {
      data['planAdditionalInfo'] = this.planAdditionalInfo!.toJson();
    }
    data['id'] = this.id;
    data['updatedDate'] = this.updatedDate;
    data['version'] = this.version;
    data['effectiveFrom'] = this.effectiveFrom;
    data['status'] = this.status;
    return data;
  }
}

class PlanAdditionalInfo {
  String? validity;
  String? circle;
  String? type;
  String? Type;
  String? data;
  String? talktime;
  String? additionalBenefits;

  PlanAdditionalInfo(
      {this.validity,
      this.circle,
      this.type,
      this.data,
      this.talktime,
      this.Type,
      this.additionalBenefits});

  PlanAdditionalInfo.fromJson(Map<String, dynamic> json) {
    validity = json['Validity'];
    circle = json['Circle'];
    type = json['Type'];
    data = json['Data'];
    talktime = json['Talktime'];
    type = json['Type'];
    additionalBenefits = json['Additional Benefits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Validity'] = this.validity;
    data['Circle'] = this.circle;
    data['Type'] = this.type;
    data['Data'] = this.data;
    data['Talktime'] = this.talktime;
    data['Type'] = this.type;
    data['Additional Benefits'] = this.additionalBenefits;
    return data;
  }
}
