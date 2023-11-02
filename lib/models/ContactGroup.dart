class ContactGroup {
  String? name;
  int groupId = 0;
  List<int> contactIds = [];

  ContactGroup({required String name, required groupId, required contactIds});

  factory ContactGroup.fromJson(Map<String, dynamic> json) {
    final groupId = json['data'];
    final groupData = json['data'][groupId];

    return ContactGroup(
        name: groupData['name'],
        groupId: groupId,
        contactIds: groupData['contact_id']);
  }

  Map<String, dynamic> toJson(ContactGroup contactGroup) => {
        'name': contactGroup.name,
        'group_id': contactGroup.groupId,
        'contact_ids': contactGroup.contactIds,
      };
}
