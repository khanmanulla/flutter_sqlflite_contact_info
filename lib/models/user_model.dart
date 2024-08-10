class UserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? mobile;

  UserModel(this.firstName, this.lastName, this.dob, this.mobile, {this.id});

  // columns in the database.
  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    firstName = map['firstname'];
    lastName = map['lastname'];
    dob = map['dob'];
    mobile = map['mobile'];
  }

// Method to convert a 'UserModel' to a map
  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'dob': dob,
      'mobile': mobile,
    };
  }
}
