class User {
  int? id;
  String username;
  String email;
  String password;
  String mobileNo;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.mobileNo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      mobileNo: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'mobile': mobileNo,
  };
}
