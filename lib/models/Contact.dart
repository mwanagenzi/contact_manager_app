class Contact {
  int? id;
  int? groupId;
  String? firstName;
  String? surname;
  String? phone;
  String? secondaryPhone;
  String? email;
  String? imageUrl;
  String? groupName;

  Contact({
    required this.id,
    this.groupId,
    required this.firstName,
    this.surname,
    required this.phone,
    this.secondaryPhone,
    required this.email,
    required this.groupName,
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
        groupName: json['group_name'] as String,
        id: json['id'] as int,
        groupId: json['group_id'] as int);
  }

  Map<String, dynamic> toJson(Contact contact) => {
        'id': contact.id,
        'first_name': contact.firstName,
        'surname': contact.surname ?? 'N/A',
        'phone': contact.phone,
        'secondary_phone': contact.secondaryPhone ?? 'N/A',
        'email': contact.email,
        'group_name': contact.groupName,
        'image': contact.imageUrl ?? 'no image',
      };
}
