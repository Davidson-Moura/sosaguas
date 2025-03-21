class User{
  String id;
  String email;
  String name;
  String password;

  User({this.id = '', this.email = '', this.name = '', this.password = ''});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}