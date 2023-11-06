class User {
  String name;
  String email;
  String token;
  static const String deviceName = 'contact_phone';

  User({
    required this.name,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json['datum']['name'] as String,
      email: json['datum']['email'] as String,
      token: json['token'] as String);

  Map<String, String> toJson(User user) => {
        'name': user.name,
        'email': user.email,
        'device_name': deviceName,
      };
}
