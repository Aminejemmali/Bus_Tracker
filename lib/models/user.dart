class User {
  final int id;
  final String name;
  final String email;
  final int role; // New field for role

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as int, // Assign the role from the JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role, // Include the role in the JSON
    };
  }
}
