class Menu {
  int? menuId;
  String? itemName;
  int? price;
  String? category;
  int? isAvailable;
  String? image;

  Menu(
      {this.menuId,
      this.itemName,
      this.price,
      this.category,
      this.isAvailable,
      this.image});

  Menu.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    itemName = json['item_name'];
    price = json['price'];
    category = json['category'];
    isAvailable = json['is_available'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_id'] = this.menuId;
    data['item_name'] = this.itemName;
    data['price'] = this.price;
    data['category'] = this.category;
    data['is_available'] = this.isAvailable;
    data['image'] = this.image;
    return data;
  }
}