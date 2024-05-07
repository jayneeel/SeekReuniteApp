class UserAuthModel {
  String? name;
  String? phone;
  String? email;
  String? profileAvatar;
  String? passwordHash;

  UserAuthModel(
      {this.name,
        this.phone,
        this.email,
        this.profileAvatar,
        this.passwordHash});

  UserAuthModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    profileAvatar = json['profileAvatar'];
    passwordHash = json['passwordHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profileAvatar'] = this.profileAvatar;
    data['passwordHash'] = this.passwordHash;
    return data;
  }
}