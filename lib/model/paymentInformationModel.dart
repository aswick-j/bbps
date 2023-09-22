class PaymentInformationModel {
  int? status;
  String? message;
  PaymentInformationData? data;

  PaymentInformationModel({this.status, this.message, this.data});

  PaymentInformationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? PaymentInformationData.fromJson(json['data'])
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

class PaymentInformationData {
  String? bILLERID;
  String? pAYMENTMODE;
  int? mODEMINLIMIT;
  int? mODEMAXLIMIT;
  String? pAYMENTCHANNEL;
  String? mINLIMIT;
  String? mAXLIMIT;

  PaymentInformationData(
      {this.bILLERID,
      this.pAYMENTMODE,
      this.mODEMINLIMIT,
      this.mODEMAXLIMIT,
      this.pAYMENTCHANNEL,
      this.mINLIMIT,
      this.mAXLIMIT});

  PaymentInformationData.fromJson(Map<String, dynamic> json) {
    bILLERID = json['BILLER_ID'];
    pAYMENTMODE = json['PAYMENT_MODE'];
    mODEMINLIMIT = json['MODE_MIN_LIMIT'];
    mODEMAXLIMIT = json['MODE_MAX_LIMIT'];
    pAYMENTCHANNEL = json['PAYMENT_CHANNEL'];
    mINLIMIT = json['MIN_LIMIT'];
    mAXLIMIT = json['MAX_LIMIT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILLER_ID'] = this.bILLERID;
    data['PAYMENT_MODE'] = this.pAYMENTMODE;
    data['MODE_MIN_LIMIT'] = this.mODEMINLIMIT;
    data['MODE_MAX_LIMIT'] = this.mODEMAXLIMIT;
    data['PAYMENT_CHANNEL'] = this.pAYMENTCHANNEL;
    data['MIN_LIMIT'] = this.mINLIMIT;
    data['MAX_LIMIT'] = this.mAXLIMIT;
    return data;
  }
}
