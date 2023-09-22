class LoginModel {
  int? status;
  String? message;
  LoginData? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? token;
  String? encryptionKey;

  LoginData({this.token, this.encryptionKey});

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    encryptionKey = json['encryptionKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['encryptionKey'] = this.encryptionKey;
    return data;
  }
}