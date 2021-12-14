///Contains the information of one Registered User Profile
class GraduaUser {
  ///Generated Id for this user
  String id;
  String name;
  String email;
  String gender;

  GraduaUser(this.id, this.name, this.email, this.gender);

  ///Creates a [GraduaUser] instance from some json data.
  GraduaUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        gender = data['gender'];

  ///Converts this [GraduaUser] to a json map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
    };
  }
}
