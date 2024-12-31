class OrderDetail {
  int? orderDetailId;
  int? orderId;
  int? menuItemId;
  int? quantity;
  int? price;
  int? totalPrice;

  OrderDetail(
      {this.orderDetailId,
      this.orderId,
      this.menuItemId,
      this.quantity,
      this.price,
      this.totalPrice});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['order_detail_id'];
    orderId = json['order_id'];
    menuItemId = json['menu_item_id'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_detail_id'] = this.orderDetailId;
    data['order_id'] = this.orderId;
    data['menu_item_id'] = this.menuItemId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['total_price'] = this.totalPrice;
    return data;
  }

  // CopyWith method
  OrderDetail copyWith({
    int? orderDetailId,
    int? orderId,
    int? menuItemId,
    int? quantity,
    int? price,
    int? totalPrice,
  }) {
    return OrderDetail(
      orderDetailId: orderDetailId ?? this.orderDetailId,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
