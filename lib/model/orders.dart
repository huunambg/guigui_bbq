class Orders {
  int? orderId;
  String? orderDate;
  int? totalAmount;
  String? status;

  Orders({this.orderId, this.orderDate, this.totalAmount, this.status});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDate = json['order_date'];
    totalAmount = json['total_amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_date'] = this.orderDate;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    return data;
  }
}