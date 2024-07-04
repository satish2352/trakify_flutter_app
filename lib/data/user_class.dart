class User {
  final String id;
  final String name;
  final String contact;
  final String role;
  final String email;

  User({required this.contact, required this.role, required this.email, required this.id, required this.name,});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['wingName'],
      email: json['email'],
      role: json['role'],
      contact: json['contact'].toString()
    );
  }
}