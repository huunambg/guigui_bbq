class Account {
  String? email;
  String? password;

  Account({this.email, this.password});

  Account.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }

    Map<String, dynamic> toJsonRegister() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['user_name'] = "Chưa có";
    return data;
  }
}