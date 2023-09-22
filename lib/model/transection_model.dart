class transection_model {
  int? status;
  String? message;
  List<TransectionsData>? data;

  transection_model({this.status, this.message, this.data});

  transection_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TransectionsData>[];
      json['data'].forEach((v) {
        data!.add(TransectionsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransectionsData {
  int? tRANSACTIONID;
  String? cUSTOMERID;
  String? tRANSACTIONREFERENCEID;
  double? bILLAMOUNT;
  String? cOMPLETIONDATE;
  String? tRANSACTIONSTATUS;
  String? bILLERID;
  String? pAYMENTCHANNEL;
  String? pAYMENTMODE;
  String? aCCOUNTNUMBER;
  String? mOBILENUMBER;
  String? cUSTOMERNAME;
  String? aPPROVALREFNO;
  String? fEE;
  String? bILLNUMBER;
  String? eQUITASTRANSACTIONID;
  String? bILLERNAME;
  String? cATEGORYNAME;
  String? cATEGORYID;
  int? cUSTOMERBILLID;
  String? bILLNAME;
  String? bILLERACCEPTSADHOC;
  String? pARAMETERNAME;
  String? pARAMETERVALUE;
  int? aUTOPAYID;
  int? rOWNUMBER;
  int? tOTALPAGES;
  int? sTARTPOSITION;
  int? eNDPOSITION;
  int? pAGESIZE;
  List<PARAMETERS>? pARAMETERS;

  TransectionsData(
      {this.tRANSACTIONID,
      this.cUSTOMERID,
      this.tRANSACTIONREFERENCEID,
      this.bILLAMOUNT,
      this.cOMPLETIONDATE,
      this.tRANSACTIONSTATUS,
      this.bILLERID,
      this.pAYMENTCHANNEL,
      this.pAYMENTMODE,
      this.aCCOUNTNUMBER,
      this.mOBILENUMBER,
      this.cUSTOMERNAME,
      this.aPPROVALREFNO,
      this.fEE,
      this.bILLNUMBER,
      this.eQUITASTRANSACTIONID,
      this.bILLERNAME,
      this.cATEGORYNAME,
      this.cATEGORYID,
      this.cUSTOMERBILLID,
      this.bILLNAME,
      this.bILLERACCEPTSADHOC,
      this.pARAMETERNAME,
      this.pARAMETERVALUE,
      this.aUTOPAYID,
      this.rOWNUMBER,
      this.tOTALPAGES,
      this.sTARTPOSITION,
      this.eNDPOSITION,
      this.pAGESIZE,
      this.pARAMETERS});

  TransectionsData.fromJson(Map<String, dynamic> json) {
    tRANSACTIONID = json['TRANSACTION_ID'];
    cUSTOMERID = json['CUSTOMER_ID'];
    tRANSACTIONREFERENCEID = json['TRANSACTION_REFERENCE_ID'];
    bILLAMOUNT = json['BILL_AMOUNT'];
    cOMPLETIONDATE = json['COMPLETION_DATE'];
    tRANSACTIONSTATUS = json['TRANSACTION_STATUS'];
    bILLERID = json['BILLER_ID'];
    pAYMENTCHANNEL = json['PAYMENT_CHANNEL'];
    pAYMENTMODE = json['PAYMENT_MODE'];
    aCCOUNTNUMBER = json['ACCOUNT_NUMBER'];
    mOBILENUMBER = json['MOBILE_NUMBER'];
    cUSTOMERNAME = json['CUSTOMER_NAME'];
    aPPROVALREFNO = json['APPROVAL_REF_NO'];
    fEE = json['FEE'];
    bILLNUMBER = json['BILL_NUMBER'];
    eQUITASTRANSACTIONID = json['EQUITAS_TRANSACTION_ID'];
    bILLERNAME = json['BILLER_NAME'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    cATEGORYID = json['CATEGORY_ID'];
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    bILLNAME = json['BILL_NAME'];
    bILLERACCEPTSADHOC = json['BILLER_ACCEPTS_ADHOC'];
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERVALUE = json['PARAMETER_VALUE'];
    aUTOPAYID = json['AUTOPAY_ID'];
    rOWNUMBER = json['ROW_NUMBER'];
    tOTALPAGES = json['TOTAL_PAGES'];
    sTARTPOSITION = json['START_POSITION'];
    eNDPOSITION = json['END_POSITION'];
    pAGESIZE = json['PAGE_SIZE'];
    if (json['PARAMETERS'] != null) {
      pARAMETERS = <PARAMETERS>[];
      json['PARAMETERS'].forEach((v) {
        pARAMETERS!.add(new PARAMETERS.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TRANSACTION_ID'] = this.tRANSACTIONID;
    data['CUSTOMER_ID'] = this.cUSTOMERID;
    data['TRANSACTION_REFERENCE_ID'] = this.tRANSACTIONREFERENCEID;
    data['BILL_AMOUNT'] = this.bILLAMOUNT;
    data['COMPLETION_DATE'] = this.cOMPLETIONDATE;
    data['TRANSACTION_STATUS'] = this.tRANSACTIONSTATUS;
    data['BILLER_ID'] = this.bILLERID;
    data['PAYMENT_CHANNEL'] = this.pAYMENTCHANNEL;
    data['PAYMENT_MODE'] = this.pAYMENTMODE;
    data['ACCOUNT_NUMBER'] = this.aCCOUNTNUMBER;
    data['MOBILE_NUMBER'] = this.mOBILENUMBER;
    data['CUSTOMER_NAME'] = this.cUSTOMERNAME;
    data['APPROVAL_REF_NO'] = this.aPPROVALREFNO;
    data['FEE'] = this.fEE;
    data['BILL_NUMBER'] = this.bILLNUMBER;
    data['EQUITAS_TRANSACTION_ID'] = this.eQUITASTRANSACTIONID;
    data['BILLER_NAME'] = this.bILLERNAME;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    data['CATEGORY_ID'] = this.cATEGORYID;
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['BILL_NAME'] = this.bILLNAME;
    data['BILLER_ACCEPTS_ADHOC'] = this.bILLERACCEPTSADHOC;
    data['PARAMETER_NAME'] = this.pARAMETERNAME;
    data['PARAMETER_VALUE'] = this.pARAMETERVALUE;
    data['AUTOPAY_ID'] = this.aUTOPAYID;
    data['ROW_NUMBER'] = this.rOWNUMBER;
    data['TOTAL_PAGES'] = this.tOTALPAGES;
    data['START_POSITION'] = this.sTARTPOSITION;
    data['END_POSITION'] = this.eNDPOSITION;
    data['PAGE_SIZE'] = this.pAGESIZE;
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
