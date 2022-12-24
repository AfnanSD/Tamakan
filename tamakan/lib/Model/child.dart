import 'dart:convert';

class Child {
  final String childID;
  final String name;
  final DateTime birthDate;
  final String profilePicture;
  final String passwordPicture;
  final int points;

  Child({
    required this.childID,
    required this.name,
    required this.birthDate,
    required this.profilePicture,
    required this.passwordPicture,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate,
      'childID': childID,
      'name': name,
      'passwordPicture': passwordPicture,
      'profilePicture': profilePicture,
      'points': points,
    };
  }

  Child.fromJson(Map<String, dynamic> json)
      : childID = json['childID'],
        name = json['name'],
        birthDate = json['birthDate'].toDate(),
        profilePicture = json['profilePicture'],
        passwordPicture = json['passwordPicture'],
        points = json['points'];
  //progress here?
}
