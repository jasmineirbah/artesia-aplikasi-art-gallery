class UserModel {
  const UserModel({
    this.id,
    required this.fullName,
    required this.passwordHash,
    required this.createdAt,
    this.lastLoginAt,
  });

  final int? id;
  final String fullName;
  final String passwordHash;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel copyWith({
    int? id,
    String? fullName,
    String? passwordHash,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'password_hash': passwordHash,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, Object?> map) {
    final lastLoginValue = map['last_login_at'] as String?;

    return UserModel(
      id: map['id'] as int?,
      fullName: map['full_name'] as String,
      passwordHash: map['password_hash'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastLoginAt: lastLoginValue == null
          ? null
          : DateTime.parse(lastLoginValue),
    );
  }
}
