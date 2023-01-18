import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tamakan/View/child_profile.dart';
import 'package:tamakan/View/widgets/button_widget.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';

class EditChildProfile extends StatefulWidget {
  const EditChildProfile({super.key, required this.childID});

  final String childID;

  @override
  State<EditChildProfile> createState() => _EditChildProfileState();
}

class _EditChildProfileState extends State<EditChildProfile> {
  var readingData = true;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  final availableProfilePics = [
    'assets/images/crocodile.png',
    'assets/images/lion.png',
    'assets/images/owl.png',
    'assets/images/pigeon.png'
  ];
  late List<String> childrenPics = List<String>.empty(growable: true);
  String profilePicture = '';

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? birthDate;
  var submit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    readChildData(widget.childID);
    //getChildrenProfilePics();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: readingData
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'تعديل حساب طفلي',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Image.asset(
                          profilePicture,
                          scale: 1.2,
                        ),
                        TextButton(
                          child: Text(
                            '+ اختر صورة لطفلك',
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            selectProfilePic(context);
                          },
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'اسم الطفل :',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال اسم الطفل';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'تاريح الميلاد :',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  // initialValue:
                                  //     DateFormat.yMd().format(child.birthDate),
                                  controller: _birthDateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: presentDatePicker,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال تاريخ ميلاد الطفل';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        ButtonWidget(
                            fun: submitData,
                            buttonLabel: 'تعديل',
                            buttonColor: Color(0xffFF6B6B)),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  submitData() async {
    setState(() {
      submit = true;
    });

    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final docRef = FirebaseFirestore.instance
          .collection('parent')
          .doc(signedInUser.email)
          .collection('children')
          .doc(child.childID);
      docRef.update({
        'name': nameController.text,
        'profilePicture': profilePicture,
        'birthDate': birthDate
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChildProfile(childID: widget.childID),
        ),
      );
    }
  }

  void presentDatePicker() {
    FocusScope.of(context).requestFocus(new FocusNode());
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (value == null) return;
        birthDate = value;
      });
      _birthDateController.text = DateFormat('yyyy/MM/dd').format(birthDate!);
    });
  }

  void selectProfilePic(BuildContext context) {
    // print(availableProfilePics
    //         .toSet()
    //         .difference(childrenPics.toSet())
    //         .toList()
    //         .toString() +
    //     "888");
    // List<String> diff =
    //     availableProfilePics.toSet().difference(childrenPics.toSet()).toList();
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: GridView.builder(
              itemCount: 4 - childrenPics.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  maxCrossAxisExtent: 350),
              itemBuilder: (context, index) {
                return slectProfilePicture(availableProfilePics[index]);
              },
            ),
          );
        });
  }

  // Future<void> getChildrenProfilePics() async {
  //   await FirebaseFirestore.instance
  //       .collection('parent')
  //       .doc(signedInUser.email)
  //       .collection('children')
  //       .get()
  //       .then((value) {
  //     for (var element in value.docs) {
  //       childrenPics.add(element['profilePicture']);
  //     }
  //     childrenPics.remove(child.profilePicture);
  //     print(childrenPics);
  //   });
  // }

  Widget slectProfilePicture(String asset) {
    return InkWell(
      child: Container(
        //padding: EdgeInsets.all(10),
        // height: 100,
        // width: 100,
        child: Image.asset(
          asset,
          scale: 1.3,
        ),
      ),
      onTap: () {
        setState(() {
          profilePicture = asset;
        });
        Navigator.pop(context);
      },
      splashColor: Colors.white,
    );
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      EasyLoading.showError("حدث خطأ ما ....");
    }
  }

  Future<void> readChildData(String childID) async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email)
        .collection('children')
        .where('childID', isEqualTo: childID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        child = Child.fromJson(element.data());
        setState(() {
          readingData = false;
          profilePicture = child.profilePicture;
          nameController.text = child.name;
          _birthDateController.text =
              DateFormat('yyyy/MM/dd').format(child.birthDate);
          birthDate = child.birthDate;
        });
      }
    });
    //getChildrenProfilePics();
  }
}
