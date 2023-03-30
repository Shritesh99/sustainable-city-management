class User {
  String? firstName;
  String? lastName;
  int? roleId;
  String? username;
  String? password;

  User(
      {this.firstName,
      this.lastName,
      this.roleId,
      this.username,
      this.password});

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'role_id': roleId,
      'username': username,
      'password': password,
    };
  }
}
