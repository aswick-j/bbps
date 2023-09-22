class AccountInfoModel {
  String? message;
  int? status;
  List<AccountsData>? data;

  AccountInfoModel({this.message, this.status, this.data});

  AccountInfoModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <AccountsData>[];
      json['data'].forEach((v) {
        data!.add(new AccountsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccountsData {
  String? accountNumber;
  dynamic balance;

  AccountsData({this.accountNumber, this.balance});

  AccountsData.fromJson(Map<String, dynamic> json) {
    accountNumber = json['accountNumber'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountNumber'] = this.accountNumber;
    data['balance'] = this.balance;
    return data;
  }
}
