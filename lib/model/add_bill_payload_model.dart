class AddbillerpayloadModel {
  String? bILLERID;
  int? pARAMETERID;
  String? pARAMETERNAME;
  String? pARAMETERTYPE;
  int? mINLENGTH;
  int? mAXLENGTH;
  String? rEGEX;
  String? oPTIONAL;
  String? eRROR;
  String? pARAMETERVALUE;

  AddbillerpayloadModel(
      {this.bILLERID,
      this.pARAMETERID,
      this.pARAMETERNAME,
      this.pARAMETERTYPE,
      this.mINLENGTH,
      this.mAXLENGTH,
      this.rEGEX,
      this.oPTIONAL,
      this.eRROR,
      this.pARAMETERVALUE});

  AddbillerpayloadModel.fromJson(Map<String, dynamic> json) {
    bILLERID = json['BILLER_ID'];
    pARAMETERID = json['PARAMETER_ID'];
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERTYPE = json['PARAMETER_TYPE'];
    mINLENGTH = json['MIN_LENGTH'];
    mAXLENGTH = json['MAX_LENGTH'];
    rEGEX = json['REGEX'];
    oPTIONAL = json['OPTIONAL'];
    eRROR = json['ERROR'];
    pARAMETERVALUE = json['PARAMETER_VALUE'];
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
    data['ERROR'] = this.eRROR;
    data['PARAMETER_VALUE'] = this.pARAMETERVALUE;
    return data;
  }
}
