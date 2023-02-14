import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String password;
  String? gender;
  String birthdate;

  UserModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.gender,
      required this.birthdate,
      required this.uid});

//To the database
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'birthdate': birthdate,
        'gender': gender,
      };
//From the database
  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      email: snapshot['email'],
      password: snapshot['password'],
      birthdate: snapshot['birthdate'],
      gender: snapshot['gender'],
    );
  }

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    Map<String, dynamic> map = snapshot.data()! as Map<String, dynamic>;
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      birthdate: map['birthdate'],
      gender: map['gender'],
    );
  }
}
