class BillerModel {
  int? status;
  String? message;
  List<BillersData>? billData;
  List<String>? locationsData;

  BillerModel({this.status, this.message, this.billData, this.locationsData});

  BillerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      billData = <BillersData>[];
      json['data'].forEach((v) {
        billData!.add(new BillersData.fromJson(v));
      });
    }
    if (json['locationsData'] != null) {
      locationsData = json['locationsData'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.billData != null) {
      data['data'] = this.billData!.map((v) => v.toJson()).toList();
    }
    data['locationsData'] = this.locationsData;
    return data;
  }
}

class BillersData {
  String? bILLERID;
  String? bILLERNAME;
  String? bILLERICON;
  String? bILLERCOVERAGE;
  String? bILLEREFFECTIVEFROM;
  String? bILLEREFFECTIVETO;
  String? pAYMENTEXACTNESS;
  String? bILLERACCEPTSADHOC;
  String? fETCHBILLALLOWED;
  String? vALIDATEBILLALLOWED;
  String? fETCHREQUIREMENT;
  String? sUPPORTBILLVALIDATION;
  String? qUICKPAYALLOWED;
  String? cATEGORYNAME;
  int? rOWNUMBER;
  int? tOTALPAGES;
  int? sTARTPOSITION;
  int? eNDPOSITION;
  int? pAGESIZE;

  BillersData(
      {this.bILLERID,
      this.bILLERNAME,
      this.bILLERICON,
      this.bILLERCOVERAGE,
      this.bILLEREFFECTIVEFROM,
      this.bILLEREFFECTIVETO,
      this.pAYMENTEXACTNESS,
      this.bILLERACCEPTSADHOC,
      this.fETCHBILLALLOWED,
      this.vALIDATEBILLALLOWED,
      this.fETCHREQUIREMENT,
      this.sUPPORTBILLVALIDATION,
      this.qUICKPAYALLOWED,
      this.cATEGORYNAME,
      this.rOWNUMBER,
      this.tOTALPAGES,
      this.sTARTPOSITION,
      this.eNDPOSITION,
      this.pAGESIZE});

  BillersData.fromJson(Map<String, dynamic> json) {
    bILLERID = json['BILLER_ID'];
    bILLERNAME = json['BILLER_NAME'];
    bILLERICON = json['BILLER_ICON'];
    bILLERCOVERAGE = json['BILLER_COVERAGE'];
    bILLEREFFECTIVEFROM = json['BILLER_EFFECTIVE_FROM'];
    bILLEREFFECTIVETO = json['BILLER_EFFECTIVE_TO'];
    pAYMENTEXACTNESS = json['PAYMENT_EXACTNESS'];
    bILLERACCEPTSADHOC = json['BILLER_ACCEPTS_ADHOC'];
    fETCHBILLALLOWED = json['FETCH_BILL_ALLOWED'];
    vALIDATEBILLALLOWED = json['VALIDATE_BILL_ALLOWED'];
    fETCHREQUIREMENT = json['FETCH_REQUIREMENT'];
    sUPPORTBILLVALIDATION = json['SUPPORT_BILL_VALIDATION'];
    qUICKPAYALLOWED = json['QUICK_PAY_ALLOWED'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    rOWNUMBER = json['ROW_NUMBER'];
    tOTALPAGES = json['TOTAL_PAGES'];
    sTARTPOSITION = json['START_POSITION'];
    eNDPOSITION = json['END_POSITION'];
    pAGESIZE = json['PAGE_SIZE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILLER_ID'] = this.bILLERID;
    data['BILLER_NAME'] = this.bILLERNAME;
    data['BILLER_ICON'] = this.bILLERICON;
    data['BILLER_COVERAGE'] = this.bILLERCOVERAGE;
    data['BILLER_EFFECTIVE_FROM'] = this.bILLEREFFECTIVEFROM;
    data['BILLER_EFFECTIVE_TO'] = this.bILLEREFFECTIVETO;
    data['PAYMENT_EXACTNESS'] = this.pAYMENTEXACTNESS;
    data['BILLER_ACCEPTS_ADHOC'] = this.bILLERACCEPTSADHOC;
    data['FETCH_BILL_ALLOWED'] = this.fETCHBILLALLOWED;
    data['VALIDATE_BILL_ALLOWED'] = this.vALIDATEBILLALLOWED;
    data['FETCH_REQUIREMENT'] = this.fETCHREQUIREMENT;
    data['SUPPORT_BILL_VALIDATION'] = this.sUPPORTBILLVALIDATION;
    data['QUICK_PAY_ALLOWED'] = this.qUICKPAYALLOWED;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    data['ROW_NUMBER'] = this.rOWNUMBER;
    data['TOTAL_PAGES'] = this.tOTALPAGES;
    data['START_POSITION'] = this.sTARTPOSITION;
    data['END_POSITION'] = this.eNDPOSITION;
    data['PAGE_SIZE'] = this.pAGESIZE;
    return data;
  }
}
