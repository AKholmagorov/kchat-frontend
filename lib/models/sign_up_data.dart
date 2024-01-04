class SignUpData {
  String? username;
  String? password;
  String? avatarBase64;

  void setUsername(String username) => this.username = username;

  void setPassword(String password) => this.password = password;

  void setUserAvatar(String? userAvatarBase64) => this.avatarBase64 = userAvatarBase64;

  Future<Map<String, dynamic>> toJson() async {
    return {
      'username': username,
      'password': password,
      'avatar': avatarBase64,
    };
  }
}
