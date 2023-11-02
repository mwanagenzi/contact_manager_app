class Contact {
  int? id;
  String? firstName;
  String? surname;
  String? phone;
  String? secondaryPhone;
  String? email;
  String? label;
  String? imagUrl;

  Contact({
    required int id,
    required String? firstName,
    String? surname,
    required String? phone,
    String? secondaryPhone,
    required String? email,
    String? imageUrl,
    required String? label,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    final contactData = json['datum'];
    return Contact(
        firstName: contactData['first_name'] as String,
        surname: contactData['surname'] as String,
        phone: contactData['phone'] as String,
        secondaryPhone: contactData['secondary_phone'] as String,
        email: contactData['email'] as String,
        imageUrl: contactData['imageUrl'] as String,
        label: contactData['label'] as String,
        id: contactData['id'] as int);
  }

  Map<String, dynamic> toJson(Contact contact) => {
        'id': contact.id,
        'first_name': contact.firstName,
        'surname': contact.surname ?? 'N/A',
        'phone': contact.phone,
        'secondary_phone': contact.secondaryPhone ?? 'N/A',
        'email': contact.email,
        'imageUrl': contact.imagUrl ?? 'no image',
        'label': contact.label,
      };
}
