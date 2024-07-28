class UserBean {
  late String uid;
  late String name;
  late String email;
  late String password;

  UserBean(
      {required this.uid,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  UserBean.fromJson(Map<String, dynamic> data) {
    uid = data['uid'] ?? '';
    name = data['name'] ?? '';
    email = data['email'] ?? '';
    password = data['password'] ?? '';
  }
}
