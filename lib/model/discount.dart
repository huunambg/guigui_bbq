class Discount {
  int? discountId;
  String? title;
  String? code;
  int? price;

  Discount({this.discountId, this.title, this.code, this.price});

  Discount.fromJson(Map<String, dynamic> json) {
    discountId = json['discount_id'];
    title = json['title'];
    code = json['code'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount_id'] = this.discountId.toString();
    data['title'] = this.title;
    data['code'] = this.code;
    data['price'] = this.price.toString();
    return data;
  }
    Map<String, dynamic> toJsonAdd() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['code'] = this.code;
    data['price'] = this.price.toString();
    return data;
  }
}