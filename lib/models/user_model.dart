class UserModel {
  final String uid;
  final String email;
  final String role;
  final String displayName;
  final String photoURL;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName = '',
    this.photoURL = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'keluarga', // default ke keluarga
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
    );
  }
}