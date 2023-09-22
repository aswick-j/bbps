class EditAutoPayModel {
  int? status;
  EditAutoPayData? data;

  EditAutoPayModel({this.status, this.data});

  EditAutoPayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new EditAutoPayData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class EditAutoPayData {
  List<InputSignatures>? inputSignatures;
  List<BillName>? billName;

  EditAutoPayData({this.inputSignatures, this.billName});

  EditAutoPayData.fromJson(Map<String, dynamic> json) {
    if (json['inputSignatures'] != null) {
      inputSignatures = <InputSignatures>[];
      json['inputSignatures'].forEach((v) {
        inputSignatures!.add(new InputSignatures.fromJson(v));
      });
    }
    if (json['billName'] != null) {
      billName = <BillName>[];
      json['billName'].forEach((v) {
        billName!.add(new BillName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inputSignatures != null) {
      data['inputSignatures'] =
          this.inputSignatures!.map((v) => v.toJson()).toList();
    }
    if (this.billName != null) {
      data['billName'] = this.billName!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InputSignatures {
  int? cUSTOMERBILLID;
  String? pARAMETERNAME;
  String? pARAMETERVALUE;
  var pARAMETERTYPE;

  InputSignatures(
      {this.cUSTOMERBILLID,
      this.pARAMETERNAME,
      this.pARAMETERVALUE,
      this.pARAMETERTYPE});

  InputSignatures.fromJson(Map<String, dynamic> json) {
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERVALUE = json['PARAMETER_VALUE'];
    pARAMETERTYPE = json['PARAMETER_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['PARAMETER_NAME'] = this.pARAMETERNAME;
    data['PARAMETER_VALUE'] = this.pARAMETERVALUE;
    data['PARAMETER_TYPE'] = this.pARAMETERTYPE;
    return data;
  }
}

class BillName {
  String? bILLNAME;

  BillName({this.bILLNAME});

  BillName.fromJson(Map<String, dynamic> json) {
    bILLNAME = json['BILL_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILL_NAME'] = this.bILLNAME;
    return data;
  }
}