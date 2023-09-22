class StatesDataModel {
  int? status;
  String? message;
  List<StatesData>? data;

  StatesDataModel({this.status, this.message, this.data});

  StatesDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StatesData>[];
      json['data'].forEach((v) {
        data!.add(new StatesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatesData {
  String? sTATECODE;
  String? sTATENAME;

  StatesData({this.sTATECODE, this.sTATENAME});

  StatesData.fromJson(Map<String, dynamic> json) {
    sTATECODE = json['STATE_CODE'];
    sTATENAME = json['STATE_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATE_CODE'] = this.sTATECODE;
    data['STATE_NAME'] = this.sTATENAME;
    return data;
  }
}
