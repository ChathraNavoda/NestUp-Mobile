class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Handle both 'id' and '_id' from different endpoints
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'avatar': avatar};
  }
}
