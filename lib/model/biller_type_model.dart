class BillerTypeModel {
  bool? fetchBill;
  bool? amountEditable;
  bool? validateBill;
  String? billerType;
  bool? isAdhoc;
  bool? quickPay;

  BillerTypeModel(
      {this.fetchBill,
      this.amountEditable,
      this.validateBill,
      this.billerType,
      this.isAdhoc,
      this.quickPay});
}
