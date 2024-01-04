class NewGroupData {
  String name = 'NULL';
  String? avatarBase64;

  void setName(String name) => this.name = name;

  void setAvatar(String? avatarBase64) => this.avatarBase64 = avatarBase64;

  Future<Map<String, dynamic>> toJson() async {
    return {
      'name': name,
      'avatar': avatarBase64,
    };
  }
}
