class CategoriesModel {
  String? message;
  int? status;
  List<CategorieData>? data;
  CategoriesModel({this.status, this.message, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategorieData>[];
      json['data'].forEach((v) {
        data!.add(new CategorieData.fromJson(v));
      });
    }
  }
}

class CategorieData {
  int? iD;
  String? cATEGORYID;
  String? cATEGORYICON;
  String? cATEGORYNAME;

  CategorieData(
      {this.iD, this.cATEGORYID, this.cATEGORYICON, this.cATEGORYNAME});

  CategorieData.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cATEGORYID = json['CATEGORY_ID'];
    cATEGORYICON = json['CATEGORY_ICON'];
    cATEGORYNAME = json['CATEGORY_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['CATEGORY_ID'] = this.cATEGORYID;
    data['CATEGORY_ICON'] = this.cATEGORYICON;
    data['CATEGORY_NAME'] = this.cATEGORYNAME;
    return data;
  }
}
