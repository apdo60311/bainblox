class UserModel {
  String name;
  String email;
  String? phone;
  String? image;
  String type;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.type,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? 'Unknown',
        email = json['email'] ?? 'email@email.com',
        phone = json['phone'] ?? '00000000000',
        image = json['image'],
        type = json['type'] ?? "student";
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['type'] = type;
    return data;
  }
}
