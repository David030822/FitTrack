class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  int? age;
  String? gender;
  double? height;
  double? weight;
  double? bodyFat;
  String? goal;
  String username;
  String? phoneNum;
  String? profileImagePath;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.bodyFat,
    this.goal,
    this.phoneNum,
    this.profileImagePath,
  });

  // Convert User object to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bodyFat': bodyFat,
      'goal': goal,
      'phoneNum': phoneNum,
      'profileImagePath': profileImagePath,
    };
  }

  // Create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // ✅ Default to 0 if null (change based on backend)
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email']?.trim() ?? '', // ✅ Trim email in case of trailing spaces
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      height: (json['height'] != null) ? (json['height'] as num).toDouble() : 0.0,
      weight: (json['weight'] != null) ? (json['weight'] as num).toDouble() : 0.0,
      bodyFat: (json['bodyFat'] != null) ? (json['bodyFat'] as num).toDouble() : 0.0,
      goal: json['goal'] ?? '',
      phoneNum: json['phoneNum'], // ✅ Keep null if it's null
      username: json['username'] ?? '',
      profileImagePath: json['profilePhotoPath'], // ✅ Keep null if it's null
    );
  }

  User copyWith({
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? bodyFat,
    String? goal,
    String? phoneNum,
    String? profileImagePath,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
  }) {
    return User(
      id: id, // Keep original ID (don't allow overriding)
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      goal: goal ?? this.goal,
      phoneNum: phoneNum ?? this.phoneNum,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}