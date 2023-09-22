class bbpsSettingsModel {
  int? status;
  String? message;
  bbpsSettingsData? data;

  bbpsSettingsModel({this.status, this.message, this.data});

  bbpsSettingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new bbpsSettingsData.fromJson(json['data'])
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

class bbpsSettingsData {
  int? dAILYLIMIT;
  int? mAXAUTOPAYAMOUNT;
  String? tERMSANDCONDITIONS;

  bbpsSettingsData(
      {this.dAILYLIMIT, this.mAXAUTOPAYAMOUNT, this.tERMSANDCONDITIONS});

  bbpsSettingsData.fromJson(Map<String, dynamic> json) {
    dAILYLIMIT = json['DAILY_LIMIT'];
    mAXAUTOPAYAMOUNT = json['MAX_AUTO_PAY_AMOUNT'];
    tERMSANDCONDITIONS = json['TERMS_AND_CONDITIONS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DAILY_LIMIT'] = this.dAILYLIMIT;
    data['MAX_AUTO_PAY_AMOUNT'] = this.mAXAUTOPAYAMOUNT;
    data['TERMS_AND_CONDITIONS'] = this.tERMSANDCONDITIONS;
    return data;
  }
}
