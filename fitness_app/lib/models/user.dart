class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  String username;
  String? phoneNum;
  String? profileImagePath;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.phoneNum, // Make optional
    this.profileImagePath, // Make optional
  });

  // Convert User object to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
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
      phoneNum: json['phoneNum'], // ✅ Keep null if it's null
      username: json['username'] ?? '',
      profileImagePath: json['profilePhotoPath'], // ✅ Keep null if it's null
    );
  }
}