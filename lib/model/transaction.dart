class Transaction {
  int? transactionId;
  int? orderId;
  int? accountId;
  int? tableId;
  String? paymentMethod;
  String? paymentDate;
  int? amount;
  int? countPeople; // Thuộc tính countPeople
  int? bufferId;    // Thuộc tính bufferId

  Transaction({
    this.transactionId,
    this.orderId,
    this.accountId,
    this.tableId,
    this.paymentMethod,
    this.paymentDate,
    this.amount,
    this.countPeople,
    this.bufferId, // Khởi tạo bufferId
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    accountId = json['account_id'];
    tableId = json['table_id'];
    paymentMethod = json['payment_method'];
    paymentDate = json['payment_date'];
    amount = json['amount'];
    countPeople = json['count_people'];
    bufferId = json['buffer_id']; // Gán giá trị từ JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
  //  data['transaction_id'] = transactionId;
    data['order_id'] = orderId;
    data['account_id'] = accountId;
    data['table_id'] = tableId;
    data['payment_method'] = paymentMethod;
    data['payment_date'] = paymentDate;
    data['amount'] = amount;
    data['count_people'] = countPeople;
    data['buffer_id'] = bufferId; // Thêm vào JSON
    return data;
  }
  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['order_id'] = orderId;
    data['account_id'] = accountId;
    data['table_id'] = tableId;
    data['payment_method'] = paymentMethod;
    data['payment_date'] = paymentDate;
    data['amount'] = amount;
    data['count_people'] = countPeople;
    data['buffer_id'] = bufferId; // Thêm vào JSON
    return data;
  }
  Transaction copyWith({
    int? transactionId,
    int? orderId,
    int? accountId,
    int? tableId,
    String? paymentMethod,
    String? paymentDate,
    int? amount,
    int? countPeople,
    int? bufferId, // Bổ sung vào copyWith
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      orderId: orderId ?? this.orderId,
      accountId: accountId ?? this.accountId,
      tableId: tableId ?? this.tableId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      amount: amount ?? this.amount,
      countPeople: countPeople ?? this.countPeople,
      bufferId: bufferId ?? this.bufferId, // Sử dụng giá trị hiện tại nếu không thay đổi
    );
  }
}
