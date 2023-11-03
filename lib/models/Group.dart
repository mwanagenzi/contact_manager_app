class Group {
  String? name;
  int? groupId;

  Group({
    required String this.name,
    required this.groupId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['group_name'],
      groupId: json['id'],
    );
  }

  Map<String, dynamic> toJson(Group contactGroup) => {
        'name': contactGroup.name,
      };
}
