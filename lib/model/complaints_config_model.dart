class complaints_config_model {
  int? status;
  String? message;
  configData? data;

  complaints_config_model({this.status, this.message, this.data});

  complaints_config_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new configData.fromJson(json['data']) : null;
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

class configData {
  List<ComplaintTransactionReasons>? complaintTransactionReasons;
  List<ComplaintTransactionDurations>? complaintTransactionDurations;

  configData(
      {this.complaintTransactionReasons, this.complaintTransactionDurations});

  configData.fromJson(Map<String, dynamic> json) {
    if (json['complaint_transaction_reasons'] != null) {
      complaintTransactionReasons = <ComplaintTransactionReasons>[];
      json['complaint_transaction_reasons'].forEach((v) {
        complaintTransactionReasons!
            .add(new ComplaintTransactionReasons.fromJson(v));
      });
    }
    if (json['complaint_transaction_durations'] != null) {
      complaintTransactionDurations = <ComplaintTransactionDurations>[];
      json['complaint_transaction_durations'].forEach((v) {
        complaintTransactionDurations!
            .add(new ComplaintTransactionDurations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.complaintTransactionReasons != null) {
      data['complaint_transaction_reasons'] =
          this.complaintTransactionReasons!.map((v) => v.toJson()).toList();
    }
    if (this.complaintTransactionDurations != null) {
      data['complaint_transaction_durations'] =
          this.complaintTransactionDurations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComplaintTransactionReasons {
  int? cOMPLAINTREASONSID;
  String? cOMPLAINTREASON;

  ComplaintTransactionReasons({this.cOMPLAINTREASONSID, this.cOMPLAINTREASON});

  ComplaintTransactionReasons.fromJson(Map<String, dynamic> json) {
    cOMPLAINTREASONSID = json['COMPLAINT_REASONS_ID'];
    cOMPLAINTREASON = json['COMPLAINT_REASON'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COMPLAINT_REASONS_ID'] = this.cOMPLAINTREASONSID;
    data['COMPLAINT_REASON'] = this.cOMPLAINTREASON;
    return data;
  }
}

class ComplaintTransactionDurations {
  String? dURATION;

  ComplaintTransactionDurations({this.dURATION});

  ComplaintTransactionDurations.fromJson(Map<String, dynamic> json) {
    dURATION = json['DURATION'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DURATION'] = this.dURATION;
    return data;
  }
}
