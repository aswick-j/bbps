class complaints_model {
  int? status;
  String? message;
  List<ComplaintsData>? data;

  complaints_model({this.status, this.message, this.data});

  complaints_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ComplaintsData>[];
      json['data'].forEach((v) {
        data!.add(new ComplaintsData.fromJson(v));
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

class ComplaintsData {
  int? iD;
  String? cOMPLAINTID;
  String? dESCRIPTION;
  String? cREATEDON;
  String? tRANSACTIONID;
  String? sTATUS;
  String? cOMPLAINTREASON;

  ComplaintsData(
      {this.iD,
      this.cOMPLAINTID,
      this.dESCRIPTION,
      this.cREATEDON,
      this.tRANSACTIONID,
      this.sTATUS,
      this.cOMPLAINTREASON});

  ComplaintsData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cOMPLAINTID = json['COMPLAINT_ID'];
    dESCRIPTION = json['DESCRIPTION'];
    cREATEDON = json['CREATED_ON'];
    tRANSACTIONID = json['TRANSACTION_ID'];
    sTATUS = json['STATUS'];
    cOMPLAINTREASON = json['COMPLAINT_REASON'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['COMPLAINT_ID'] = this.cOMPLAINTID;
    data['DESCRIPTION'] = this.dESCRIPTION;
    data['CREATED_ON'] = this.cREATEDON;
    data['TRANSACTION_ID'] = this.tRANSACTIONID;
    data['STATUS'] = this.sTATUS;
    data['COMPLAINT_REASON'] = this.cOMPLAINTREASON;
    return data;
  }
}
