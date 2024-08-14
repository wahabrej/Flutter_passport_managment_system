class User {
  final String firstName;
  final String lastName;
  final String dob;
  final String phone;
  final String nid;
  final String email;
  final String password;
  final String role; // New field for role

  User({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.phone,
    required this.nid,
    required this.email,
    required this.password,
    required this.role, // Initialize role
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'dob': dob,
        'phone': phone,
        'nid': nid,
        'email': email,
        'password': password,
        'role': role, // Include role in JSON
      };
}
