class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.phone,
      this.website});

  factory User.fromJson(dynamic data) {
    return User(
        id: data['id'],
        name: data['name'],
        username: data['username'],
        email: data['email'],
        phone: data['phone'],
        website: data['website']);
  }
}
