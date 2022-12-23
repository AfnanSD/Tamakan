import 'dart:convert';

class Child {
  final String childID;
  final String name;
  final DateTime birthDate;
  final String profilePicture;
  final String passwordPicture;

  Child({
    required this.childID,
    required this.name,
    required this.birthDate,
    required this.profilePicture,
    required this.passwordPicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate,
      'childID': childID,
      'name': name,
      'passwordPicture': passwordPicture,
      'profilePicture': profilePicture,
    };
  }

//not tested
  Child.fromJson(Map<String, dynamic> json)
      : childID = json['childID'],
        name = json['name'],
        birthDate = json['birthDate'].toDate(),
        profilePicture = json['profilePicture'],
        passwordPicture = json['passwordPicture'];
  //progress here?
}
