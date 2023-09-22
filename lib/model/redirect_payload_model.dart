class RedirectPayloadModel {
  RedirectPayloadData? data;
  String? checkSum;

  RedirectPayloadModel({this.data, this.checkSum});

  RedirectPayloadModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new RedirectPayloadData.fromJson(json['data'])
        : null;
    checkSum = json['checkSum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['checkSum'] = this.checkSum;
    return data;
  }
}

class RedirectPayloadData {
  String? iPAddress;
  String? platform;
  String? service;
  RedirectPayloadData? data;

  RedirectPayloadData({this.iPAddress, this.platform, this.service, this.data});

  RedirectPayloadData.fromJson(Map<String, dynamic> json) {
    iPAddress = json['IPAddress'];
    platform = json['platform'];
    service = json['service'];
    data = json['data'] != null
        ? new RedirectPayloadData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IPAddress'] = this.iPAddress;
    data['platform'] = this.platform;
    data['service'] = this.service;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? otpPreference;
  Customer? customer;
  List<Accounts>? accounts;

  Data({this.otpPreference, this.customer, this.accounts});

  Data.fromJson(Map<String, dynamic> json) {
    otpPreference = json['otpPreference'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    if (json['accounts'] != null) {
      accounts = <Accounts>[];
      json['accounts'].forEach((v) {
        accounts!.add(new Accounts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpPreference'] = this.otpPreference;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.accounts != null) {
      data['accounts'] = this.accounts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? custId;
  String? gndr;
  String? mblNb;
  String? emailId;

  Customer({this.custId, this.gndr, this.mblNb, this.emailId});

  Customer.fromJson(Map<String, dynamic> json) {
    custId = json['custId'];
    gndr = json['gndr'];
    mblNb = json['mblNb'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custId'] = this.custId;
    data['gndr'] = this.gndr;
    data['mblNb'] = this.mblNb;
    data['emailId'] = this.emailId;
    return data;
  }
}

class Accounts {
  String? acctTp;
  String? acctId;
  String? custRltnsp;
  String? prdNm;
  String? crntSts;
  String? avlBal;
  String? crntStsDesc;
  String? entityType;

  Accounts(
      {this.acctTp,
      this.acctId,
      this.custRltnsp,
      this.prdNm,
      this.crntSts,
      this.avlBal,
      this.crntStsDesc,
      this.entityType});

  Accounts.fromJson(Map<String, dynamic> json) {
    acctTp = json['acctTp'];
    acctId = json['acctId'];
    custRltnsp = json['custRltnsp'];
    prdNm = json['prdNm'];
    crntSts = json['crntSts'];
    avlBal = json['avlBal'];
    crntStsDesc = json['crntStsDesc'];
    entityType = json['entityType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acctTp'] = this.acctTp;
    data['acctId'] = this.acctId;
    data['custRltnsp'] = this.custRltnsp;
    data['prdNm'] = this.prdNm;
    data['crntSts'] = this.crntSts;
    data['avlBal'] = this.avlBal;
    data['crntStsDesc'] = this.crntStsDesc;
    data['entityType'] = this.entityType;
    return data;
  }
}
