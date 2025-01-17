class User {
  int? userId;
  String? password;
  String? fullName;
  String? email;
  String? role;
  String? image;

  User({
    this.userId,
    this.password,
    this.fullName,
    this.email,
    this.role,
    this.image,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    password = json['password'];
    fullName = json['user_name'];
    email = json['email'];
    role = json['role'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId.toString();
    data['password'] = this.password;
    data['user_name'] = this.fullName;
    data['email'] = this.email;
    data['role'] = this.role;
    data['image'] = this.image;
    return data;
  }

  User copyWith({
    int? userId,
    String? email,
    String? password,
    String? userName,
    String? role,
    String? image,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: userName ?? this.fullName,
      role: role ?? this.role,
      image: image ?? this.image,
    );
  }
}
