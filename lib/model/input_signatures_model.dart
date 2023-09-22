class InputSignaturesModel {
  int? status;
  String? message;
  List<InputSignaturesData>? data;

  InputSignaturesModel({this.status, this.message, this.data});

  InputSignaturesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InputSignaturesData>[];
      json['data'].forEach((v) {
        data!.add(new InputSignaturesData.fromJson(v));
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

class InputSignaturesData {
  String? bILLERID;
  int? pARAMETERID;
  String? pARAMETERNAME;
  String? pARAMETERTYPE;
  int? mINLENGTH;
  int? mAXLENGTH;
  String? rEGEX;
  String? oPTIONAL;
  String? pARAMETER_VALUE;
  String? eRROR;
  InputSignaturesData(
      {this.bILLERID,
      this.pARAMETERID,
      this.pARAMETERNAME,
      this.pARAMETERTYPE,
      this.mINLENGTH,
      this.mAXLENGTH,
      this.rEGEX,
      this.oPTIONAL,
      this.pARAMETER_VALUE,
      this.eRROR});

  InputSignaturesData.fromJson(Map<String, dynamic> json) {
    bILLERID = json['BILLER_ID'];
    pARAMETERID = json['PARAMETER_ID'];
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERTYPE = json['PARAMETER_TYPE'];
    mINLENGTH = json['MIN_LENGTH'];
    mAXLENGTH = json['MAX_LENGTH'];
    rEGEX = json['REGEX'];
    oPTIONAL = json['OPTIONAL'];
    pARAMETER_VALUE = json['PARAMETER_VALUE'];
    eRROR = json['ERROR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILLER_ID'] = this.bILLERID;
    data['PARAMETER_ID'] = this.pARAMETERID;
    data['PARAMETER_NAME'] = this.pARAMETERNAME;
    data['PARAMETER_TYPE'] = this.pARAMETERTYPE;
    data['MIN_LENGTH'] = this.mINLENGTH;
    data['MAX_LENGTH'] = this.mAXLENGTH;
    data['REGEX'] = this.rEGEX;
    data['OPTIONAL'] = this.oPTIONAL;
    data['PARAMETER_VALUE'] = this.pARAMETER_VALUE;
    data['ERROR'] = this.eRROR;
    return data;
  }
}
