import 'saved_billers_model.dart';

class ChartModel {
  int? status;
  String? message;
  List<ChartData>? data;
  List<SavedBillersData>? billerData;

  ChartModel({this.status, this.message, this.data, this.billerData});

  ChartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChartData>[];
      json['data'].forEach((v) {
        data!.add(new ChartData.fromJson(v));
      });
    }
    if (json['billerData'] != null) {
      billerData = <SavedBillersData>[];
      json['billerData'].forEach((v) {
        billerData!.add(new SavedBillersData.fromJson(v));
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
    if (this.billerData != null) {
      data['billerData'] = this.billerData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChartData {
  int? tRANSACTIONID;
  int? cUSTOMERBILLID;
  String? tRANSACTIONREFERENCEID;
  var bILLAMOUNT;
  String? cOMPLETIONDATE;
  String? tRANSACTIONSTATUS;
  String? bILLERNAME;
  String? bILLERID;
  String? bILLERICON;
  String? bILLERCOVERAGE;
  String? cATEGORYNAME;

  ChartData(
      {this.tRANSACTIONID,
      this.cUSTOMERBILLID,
      this.tRANSACTIONREFERENCEID,
      this.bILLAMOUNT,
      this.cOMPLETIONDATE,
      this.tRANSACTIONSTATUS,
      this.bILLERNAME,
      this.bILLERID,
      this.bILLERICON,
      this.bILLERCOVERAGE,
      this.cATEGORYNAME});

  ChartData.fromJson(Map<String, dynamic> json) {
    tRANSACTIONID = json['TRANSACTION_ID'];
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    tRANSACTIONREFERENCEID = json['TRANSACTION_REFERENCE_ID'];
    bILLAMOUNT = json['BILL_AMOUNT'];
    cOMPLETIONDATE = json['COMPLETION_DATE'];
    tRANSACTIONSTATUS = json['TRANSACTION_STATUS'];
    bILLERNAME = json['BILLER_NAME'];
    bILLERID = json['BILLER_ID'];
    bILLERICON = json['BILLER_ICON'];
    bILLERCOVERAGE = json['BILLER_COVERAGE'];
    cATEGORYNAME = json['CATEGORY_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TRANSACTION_ID'] = this.tRANSACTIONID;
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['TRANSACTION_REFERENCE_ID'] = this.tRANSACTIONREFERENCEID;
    data['BILL_AMOUNT'] = this.bILLAMOUNT;
    data['COMPLETION_DATE'] = this.cOMPLETIONDATE;
    data['TRANSACTION_STATUS'] = this.tRANSACTIONSTATUS;
    data['BILLER_NAME'] = this.bILLERNAME;
    data['BILLER_ID'] = this.bILLERID;
    data['BILLER_ICON'] = this.bILLERICON;
    data['BILLER_COVERAGE'] = this.bILLERCOVERAGE;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    return data;
  }
}

class ChartBillerData {
  int? cUSTOMERBILLID;
  String? bILLNAME;
  String? pARAMETERNAME;
  String? pARAMETERVALUE;
  String? bILLERID;
  String? bILLERNAME;
  String? bILLERACCEPTSADHOC;
  String? bILLERCOVERAGE;
  String? bILLERICON;
  int? cATEGORYID;
  String? fETCHREQUIREMENT;
  String? pAYMENTEXACTNESS;
  String? sUPPORTBILLVALIDATION;
  String? vALIDATEBILLALLOWED;
  String? cATEGORYNAME;
  int? aUTOPAYID;
  List<PARAMETERS>? pARAMETERS;
  String? lASTPAIDDATE;
  int? uNSAVEDBILL;
  var lASTBILLAMOUNT;

  ChartBillerData(
      {this.cUSTOMERBILLID,
      this.bILLNAME,
      this.pARAMETERNAME,
      this.pARAMETERVALUE,
      this.bILLERID,
      this.bILLERNAME,
      this.bILLERACCEPTSADHOC,
      this.bILLERCOVERAGE,
      this.bILLERICON,
      this.cATEGORYID,
      this.fETCHREQUIREMENT,
      this.pAYMENTEXACTNESS,
      this.sUPPORTBILLVALIDATION,
      this.vALIDATEBILLALLOWED,
      this.cATEGORYNAME,
      this.aUTOPAYID,
      this.pARAMETERS,
      this.lASTPAIDDATE,
      this.lASTBILLAMOUNT,
      this.uNSAVEDBILL});

  ChartBillerData.fromJson(Map<String, dynamic> json) {
    cUSTOMERBILLID = json['CUSTOMER_BILL_ID'];
    bILLNAME = json['BILL_NAME'];
    pARAMETERNAME = json['PARAMETER_NAME'];
    pARAMETERVALUE = json['PARAMETER_VALUE'];
    bILLERID = json['BILLER_ID'];
    bILLERNAME = json['BILLER_NAME'];
    bILLERACCEPTSADHOC = json['BILLER_ACCEPTS_ADHOC'];
    bILLERCOVERAGE = json['BILLER_COVERAGE'];
    bILLERICON = json['BILLER_ICON'];
    cATEGORYID = json['CATEGORY_ID'];
    fETCHREQUIREMENT = json['FETCH_REQUIREMENT'];
    pAYMENTEXACTNESS = json['PAYMENT_EXACTNESS'];
    sUPPORTBILLVALIDATION = json['SUPPORT_BILL_VALIDATION'];
    vALIDATEBILLALLOWED = json['VALIDATE_BILL_ALLOWED'];
    cATEGORYNAME = json['CATEGORY_NAME'];
    aUTOPAYID = json['AUTOPAY_ID'];
    uNSAVEDBILL = json['UNSAVED_BILL'];
    if (json['PARAMETERS'] != null) {
      pARAMETERS = <PARAMETERS>[];
      json['PARAMETERS'].forEach((v) {
        pARAMETERS!.add(new PARAMETERS.fromJson(v));
      });
    }
    lASTPAIDDATE = json['LAST_PAID_DATE'];
    lASTBILLAMOUNT = json['LAST_BILL_AMOUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CUSTOMER_BILL_ID'] = this.cUSTOMERBILLID;
    data['BILL_NAME'] = this.bILLNAME;
    data['PARAMETER_NAME'] = this.pARAMETERNAME;
    data['PARAMETER_VALUE'] = this.pARAMETERVALUE;
    data['BILLER_ID'] = this.bILLERID;
    data['BILLER_NAME'] = this.bILLERNAME;
    data['BILLER_ACCEPTS_ADHOC'] = this.bILLERACCEPTSADHOC;
    data['BILLER_COVERAGE'] = this.bILLERCOVERAGE;
    data['BILLER_ICON'] = this.bILLERICON;
    data['CATEGORY_ID'] = this.cATEGORYID;
    data['FETCH_REQUIREMENT'] = this.fETCHREQUIREMENT;
    data['PAYMENT_EXACTNESS'] = this.pAYMENTEXACTNESS;
    data['SUPPORT_BILL_VALIDATION'] = this.sUPPORTBILLVALIDATION;
    data['VALIDATE_BILL_ALLOWED'] = this.vALIDATEBILLALLOWED;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    data['AUTOPAY_ID'] = this.aUTOPAYID;
    data['UNSAVED_BILL'] = this.uNSAVEDBILL;
    if (this.pARAMETERS != null) {
      data['PARAMETERS'] = this.pARAMETERS!.map((v) => v.toJson()).toList();
    }
    data['LAST_PAID_DATE'] = this.lASTPAIDDATE;
    data['LAST_BILL_AMOUNT'] = this.lASTBILLAMOUNT;
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
