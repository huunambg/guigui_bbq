class Transaction {
  int? transactionId;
  int? orderId;
  int? accountId;
  int? tableId;
  String? paymentMethod;
  String? paymentDate;
  int? amount;
  String? listMenu;

  Transaction(
      {this.transactionId,
      this.orderId,
      this.accountId,
      this.tableId,
      this.paymentMethod,
      this.paymentDate,
      this.amount,
      this.listMenu});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    accountId = json['account_id'];
    tableId = json['table_id'];
    paymentMethod = json['payment_method'];
    paymentDate = json['payment_date'];
    amount = json['amount'];
    listMenu = json['list_menu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    data['account_id'] = this.accountId;
    data['table_id'] = this.tableId;
    data['payment_method'] = this.paymentMethod;
    data['payment_date'] = this.paymentDate;
    data['amount'] = this.amount;
    data['list_menu'] = this.listMenu;
    return data;
  }
}