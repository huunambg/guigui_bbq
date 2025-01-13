class User {
  int? userId;
  String? password;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? role;
  String? image;

  User(
      {this.userId,
      this.password,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.role,
      this.image,
   });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    password = json['password'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['role'] = this.role;
    data['image'] = this.image;
    return data;
  }
}
