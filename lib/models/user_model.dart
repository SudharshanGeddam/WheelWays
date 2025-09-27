class UserModel {
  final String uid;
  final String employeeName;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.employeeName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      employeeName: data['employeeName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'employeeName': employeeName,
      'email': email,
      'role': role,
    };
  }
}
