class transaction_failed {
  PaymentDetails? paymentDetails;
  List<TransactionSteps>? transactionSteps;
  String? reason;
  String? equitasTransactionId;

  transaction_failed(
      {this.paymentDetails,
      this.transactionSteps,
      this.reason,
      this.equitasTransactionId});

  transaction_failed.fromJson(Map<String, dynamic> json) {
    paymentDetails = json['paymentDetails'] != null
        ? new PaymentDetails.fromJson(json['paymentDetails'])
        : null;
    if (json['transactionSteps'] != null) {
      transactionSteps = <TransactionSteps>[];
      json['transactionSteps'].forEach((v) {
        transactionSteps!.add(new TransactionSteps.fromJson(v));
      });
    }
    reason = json['reason'];
    equitasTransactionId = json['equitasTransactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentDetails != null) {
      data['paymentDetails'] = this.paymentDetails!.toJson();
    }
    if (this.transactionSteps != null) {
      data['transactionSteps'] =
          this.transactionSteps!.map((v) => v.toJson()).toList();
    }
    data['reason'] = this.reason;
    data['equitasTransactionId'] = this.equitasTransactionId;
    return data;
  }
}

class PaymentDetails {
  String? created;
  bool? failed;

  PaymentDetails({this.created, this.failed});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    failed = json['failed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['failed'] = this.failed;
    return data;
  }
}

class TransactionSteps {
  String? description;
  bool? flag;
  bool? pending;

  TransactionSteps({this.description, this.flag, this.pending});

  TransactionSteps.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    flag = json['flag'];
    pending = json['pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['flag'] = this.flag;
    data['pending'] = this.pending;
    return data;
  }
}
