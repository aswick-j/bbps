class SavedBillerModel {
  int? status;
  String? message;
  List<SavedBillerData>? data;

  SavedBillerModel({this.status, this.message, this.data});

  SavedBillerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SavedBillerData>[];
      json['data'].forEach((v) {
        data!.add(new SavedBillerData.fromJson(v));
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

class SavedBillerData {
  String? bILLERID;
  int? cUSTOMERBILLID;
  String? bILLERNAME;
  String? bILLERCOVERAGE;
  String? bILLERICON;
  String? bILLEREFFECTIVEFROM;
  String? bILLEREFFECTIVETO;
  String? pAYMENTEXACTNESS;
  String? bILLERACCEPTSADHOC;
  String? fETCHBILLALLOWED;
  String? vALIDATEBILLALLOWED;
  String? fETCHREQUIREMENT;
  String? sUPPORTBILLVALIDATION;
  String? qUICKPAYALLOWED;
  String? pAYMENTDATE;
  int? aUTOPAYID;
  String? pARAMETERNAME;
  String? pARAMETERVALUE;
  String? tRANSACTIONSTATUS;
  String? cOMPLETIONDATE;
  double? bILLAMOUNT;
  String? cATEGORYNAME;
  String? bILLNAME;
  List<PARAMETERS>? pARAMETERS;

  SavedBillerData(
      {this.bILLERID,
      this.cUSTOMERBILLID,
      this.bILLERNAME,
      this.bILLERCOVERAGE,
      this.bILLERICON,
      this.bILLEREFFECTIVEFROM,
      this.bILLEREFFECTIVETO,
      this.pAYMENTEXACTNESS,
      this.bILLERACCEPTSADHOC,
      this.fETCHBILLALLOWED,
      this.vALIDATEBILLALLOWED,
      this.fETCHREQUIREMENT,
      this.sUPPORTBILLVALIDATION,
      this.qUICKPAYALLOWED,
      this.pAYMENTDATE,
      this.aUTOPAYID,
      this.pARAMETERNAME,
      this.pARAMETERVALUE,
      this.tRANSACTIONSTATUS,
      this.cOMPLETIONDATE,
      this.bILLAMOUNT,
      this.cATEGORYNAME,
      this.bILLNAME,
      this.pARAMETERS});

  SavedBillerData.fromJson(Map<String, dynamic> json) {
    bILLERID = json['BILLER_ID'];
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    bILLERNAME = json['BILLER_NAME'];
    bILLERCOVERAGE = json['BILLER_COVERAGE'];
    bILLERICON = json['BILLER_ICON'];
    bILLEREFFECTIVEFROM = json['BILLER_EFFECTIVE_FROM'];
    bILLEREFFECTIVETO = json['BILLER_EFFECTIVE_TO'];
    pAYMENTEXACTNESS = json['PAYMENT_EXACTNESS'];
    bILLERACCEPTSADHOC = json['BILLER_ACCEPTS_ADHOC'];
    fETCHBILLALLOWED = json['FETCH_BILL_ALLOWED'];
    vALIDATEBILLALLOWED = json['VALIDATE_BILL_ALLOWED'];
    fETCHREQUIREMENT = json['FETCH_REQUIREMENT'];
    sUPPORTBILLVALIDATION = json['SUPPORT_BILL_VALIDATION'];
    qUICKPAYALLOWED = json['QUICK_PAY_ALLOWED'];
    pAYMENTDATE = json['PAYMENT_DATE'];
    aUTOPAYID = json['AUTOPAY_ID'];
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERVALUE = json['PARAMETER_VALUE'];
    tRANSACTIONSTATUS = json['TRANSACTION_STATUS'];
    cOMPLETIONDATE = json['COMPLETION_DATE'];
    bILLAMOUNT = json['BILL_AMOUNT'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    bILLNAME = json['BILL_NAME'];
    if (json['PARAMETERS'] != null) {
      pARAMETERS = <PARAMETERS>[];
      json['PARAMETERS'].forEach((v) {
        pARAMETERS!.add(new PARAMETERS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILLER_ID'] = this.bILLERID;
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['BILLER_NAME'] = this.bILLERNAME;
    data['BILLER_COVERAGE'] = this.bILLERCOVERAGE;
    data['BILLER_ICON'] = this.bILLERICON;
    data['BILLER_EFFECTIVE_FROM'] = this.bILLEREFFECTIVEFROM;
    data['BILLER_EFFECTIVE_TO'] = this.bILLEREFFECTIVETO;
    data['PAYMENT_EXACTNESS'] = this.pAYMENTEXACTNESS;
    data['BILLER_ACCEPTS_ADHOC'] = this.bILLERACCEPTSADHOC;
    data['FETCH_BILL_ALLOWED'] = this.fETCHBILLALLOWED;
    data['VALIDATE_BILL_ALLOWED'] = this.vALIDATEBILLALLOWED;
    data['FETCH_REQUIREMENT'] = this.fETCHREQUIREMENT;
    data['SUPPORT_BILL_VALIDATION'] = this.sUPPORTBILLVALIDATION;
    data['QUICK_PAY_ALLOWED'] = this.qUICKPAYALLOWED;
    data['PAYMENT_DATE'] = this.pAYMENTDATE;
    data['AUTOPAY_ID'] = this.aUTOPAYID;
    data['PARAMETER_NAME'] = this.pARAMETERNAME;
    data['PARAMETER_VALUE'] = this.pARAMETERVALUE;
    data['TRANSACTION_STATUS'] = this.tRANSACTIONSTATUS;
    data['COMPLETION_DATE'] = this.cOMPLETIONDATE;
    data['BILL_AMOUNT'] = this.bILLAMOUNT;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    data['BILL_NAME'] = this.bILLNAME;
    if (this.pARAMETERS != null) {
      data['PARAMETERS'] = this.pARAMETERS!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PARAMETERS {
  String? pARAMETERNAME;
  String? pARAMETERVALUE;

  PARAMETERS({this.pARAMETERNAME, this.pARAMETERVALUE});

  PARAMETERS.fromJson(Map<String, dynamic> json) {
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERVALUE = json['PARAMETER_VALUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PARAMETER_NAME'] = this.pARAMETERNAME;
    data['PARAMETER_VALUE'] = this.pARAMETERVALUE;
    return data;
  }
}
