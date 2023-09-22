class DecodedModel {
  String? platform;
  String? customerID;
  String? gender;
  String? mobileNumber;
  String? dob;
  String? otpPreference;
  String? emailID;
  String? customerName;
  List<Accounts>? accounts;
  int? iat;
  int? exp;

  DecodedModel(
      {this.platform,
      this.customerID,
      this.gender,
      this.mobileNumber,
      this.dob,
      this.otpPreference,
      this.emailID,
      this.accounts,
      this.customerName,
      this.iat,
      this.exp});

  DecodedModel.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    customerID = json['customerID'];
    customerName = json['customerName'];
    gender = json['gender'];
    mobileNumber = json['mobileNumber'];
    dob = json['dob'];
    otpPreference = json['otp_preference'];
    emailID = json['emailID'];
    if (json['accounts'] != null) {
      accounts = <Accounts>[];
      json['accounts'].forEach((v) {
        accounts!.add(new Accounts.fromJson(v));
      });
    }
    iat = json['iat'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['platform'] = this.platform;
    data['customerID'] = this.customerID;
    data['customerName'] = this.customerName;
    data['gender'] = this.gender;
    data['mobileNumber'] = this.mobileNumber;
    data['dob'] = this.dob;
    data['otp_preference'] = this.otpPreference;
    data['emailID'] = this.emailID;
    if (this.accounts != null) {
      data['accounts'] = this.accounts!.map((v) => v.toJson()).toList();
    }
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    return data;
  }
}

class Accounts {
  String? accountType;
  String? accountID;
  String? customerRelationship;
  String? customerStatusDescription;
  String? entityType;
  String? currentStatus;
  int? id;

  Accounts(
      {this.accountType,
      this.accountID,
      this.customerRelationship,
      this.customerStatusDescription,
      this.entityType,
      this.currentStatus,
      this.id});

  Accounts.fromJson(Map<String, dynamic> json) {
    accountType = json['accountType'];
    accountID = json['accountID'];
    customerRelationship = json['customerRelationship'];
    customerStatusDescription = json['customerStatusDescription'];
    entityType = json['entityType'];
    currentStatus = json['currentStatus'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountType'] = this.accountType;
    data['accountID'] = this.accountID;
    data['customerRelationship'] = this.customerRelationship;
    data['customerStatusDescription'] = this.customerStatusDescription;
    data['entityType'] = this.entityType;
    data['currentStatus'] = this.currentStatus;
    data['id'] = this.id;
    return data;
  }
}
