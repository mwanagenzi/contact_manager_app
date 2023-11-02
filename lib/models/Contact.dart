class Contact {
  int? id;
  String? firstName;
  String? surname;
  String? phone;
  String? secondaryPhone;
  String? email;
  String? imageUrl;

  Contact({
    required this.id,
    required this.firstName,
    this.surname,
    required this.phone,
    this.secondaryPhone,
    required this.email,
    this.imageUrl,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        firstName: json['first_name'] as String,
        surname: json['surname'] as String,
        phone: json['phone'] as String,
        secondaryPhone: json['secondary_phone'] as String,
        email: json['email'] as String,
        imageUrl: json['image'] as String,
        id: json['id'] as int);
  }

  Map<String, dynamic> toJson(Contact contact) => {
        'id': contact.id,
        'first_name': contact.firstName,
        'surname': contact.surname ?? 'N/A',
        'phone': contact.phone,
        'secondary_phone': contact.secondaryPhone ?? 'N/A',
        'email': contact.email,
        'imageUrl': contact.imageUrl ?? 'no image',
      };
}
