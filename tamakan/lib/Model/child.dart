import 'dart:convert';

class Child {
  final String childID;
  final String name;
  final DateTime birthDate;
  final String profilePicture;
  final String? passwordPicture1;
  final String? passwordPicture2;
  final int points;
  final int? CurrentLevel;

  Child({
    required this.childID,
    required this.name,
    required this.birthDate,
    required this.profilePicture,
    required this.passwordPicture1,
    required this.passwordPicture2,
    required this.points,
    required this.CurrentLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate,
      'childID': childID,
      'name': name,
      'passwordPicture1': passwordPicture1,
      'passwordPicture2': passwordPicture2,
      'profilePicture': profilePicture,
      'points': points,
      'CurrentLevel': CurrentLevel
    };
  }

  Child.fromJson(Map<String, dynamic> json)
      : childID = json['childID'],
        name = json['name'],
        birthDate = json['birthDate'].toDate(),
        profilePicture = json['profilePicture'],
        passwordPicture1 = json['passwordPicture1'],
        passwordPicture2 = json['passwordPicture2'],
        points = json['points'],
        CurrentLevel = json['CurrentLevel'];
  //progress here?
}
