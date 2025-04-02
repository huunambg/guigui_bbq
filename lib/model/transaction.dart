import 'package:get/get.dart';

class Transaction {
  int? transactionId;
  int? orderId;
  int? accountId;
  int? tableId;
  String? paymentMethod;
  String? paymentDate;
  String? discountCode;
  int? amount;
  int? countPeople; // Thuộc tính countPeople
  int? countPeople2;
  int? bufferId; // Thuộc tính bufferId

  Transaction({
    this.transactionId,
    this.orderId,
    this.accountId,
    this.tableId,
    this.paymentMethod,
    this.paymentDate,
    this.discountCode,
    this.amount,
    this.countPeople,
    this.countPeople2,
    this.bufferId, // Khởi tạo bufferId
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    accountId = json['account_id'];
    tableId = json['table_id'];
    paymentMethod = json['payment_method'];
    discountCode = json['discount_code'];
    paymentDate = json['payment_date'];
    amount = json['amount'];
    countPeople = json['count_people'];
    countPeople2 = json['count_people2'];
    bufferId = json['buffer_id']; // Gán giá trị từ JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //  data['transaction_id'] = transactionId;
    data['order_id'] = orderId;
    data['account_id'] = accountId;
    data['table_id'] = tableId;
    data['payment_method'] = paymentMethod;
    data['discount_code'] = discountCode;
    data['payment_date'] = paymentDate;
    data['amount'] = amount;
    data['count_people'] = countPeople;
    data['count_people2'] = countPeople2;
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
    data['discount_code'] = discountCode;
    data['payment_date'] = paymentDate;
    data['amount'] = amount;
    data['count_people'] = countPeople;
    data['count_people2'] = countPeople2;
    data['buffer_id'] = bufferId; // Thêm vào JSON
    return data;
  }

  Transaction copyWith({
    int? transactionId,
    int? orderId,
    int? accountId,
    int? tableId,
    String? paymentMethod,
    String? discountCode,
    String? paymentDate,
    int? amount,
    int? countPeople,
    int? countPeople2,
    int? bufferId, // Bổ sung vào copyWith
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      orderId: orderId ?? this.orderId,
      accountId: accountId ?? this.accountId,
      tableId: tableId ?? this.tableId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountCode: discountCode ?? this.discountCode,
      paymentDate: paymentDate ?? this.paymentDate,
      amount: amount ?? this.amount,
      countPeople: countPeople ?? this.countPeople,
      countPeople2: countPeople ?? this.countPeople2,
      bufferId: bufferId ??
          this.bufferId, // Sử dụng giá trị hiện tại nếu không thay đổi
    );
  }

  DateTime? get paymentDateAsDateTime {
    if (paymentDate == null) return null;
    try {
      return DateTime.parse(paymentDate!).add(7.hours);
    } catch (e) {
      return null;
    }
  }
}
