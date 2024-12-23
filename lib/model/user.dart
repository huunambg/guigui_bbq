class User {
  int? userId;
  String? password;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? role;
  String? createdAt;
  int? status;

  User(
      {this.userId,
      this.password,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.role,
      this.createdAt,
      this.status});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    password = json['password'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['password'] = this.password;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}
