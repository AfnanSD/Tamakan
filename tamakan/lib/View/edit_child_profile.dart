import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late String passwordOne;
  late String passwordTwo;
  var selected = [false, false, false, false, false, false]; //for passwrod
  var oneTurn = true;
  var editPassword = false;

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
              'assets/images/logo3.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: const Color(0xffFF6B6B),
        ),
        body: readingData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
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
                                width: 150,
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'اسم الطفل :',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
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
                                width: 150,
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'تاريح الميلاد :',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  // initialValue:
                                  //     DateFormat.yMd().format(child.birthDate),
                                  controller: _birthDateController,
                                  decoration: const InputDecoration(
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'كلمة المرور :',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle),
                                width: 55,
                                height: 55,
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(2),
                                child: Image.asset(
                                  passwordOne,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle),
                                width: 55,
                                height: 55,
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(2),
                                child: Image.asset(
                                  passwordTwo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    editPassword = !editPassword;
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        editPassword
                            ? Card(
                                margin:
                                    const EdgeInsets.only(left: 20, right: 150),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Column(
                                        children: [
                                          PassowordIconButton(
                                              'assets/images/yellow-flower.png',
                                              0),
                                          PassowordIconButton(
                                              'assets/images/mushroom.png', 1),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        children: [
                                          PassowordIconButton(
                                              'assets/images/hazelnut.png', 2),
                                          PassowordIconButton(
                                              'assets/images/snowflake.png', 3),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        children: [
                                          PassowordIconButton(
                                              'assets/images/trees-2.png', 4),
                                          PassowordIconButton(
                                              'assets/images/sun.png', 5),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Text(''),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonWidget(
                            fun: submitData,
                            buttonLabel: 'حفظ التعديلات',
                            buttonColor: const Color(0xffFF6B6B)),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget PassowordIconButton(String asset, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selected.fillRange(0, 6, false);
          selected[index] = !selected[index];
          if (oneTurn) {
            passwordOne = asset;
          } else {
            passwordTwo = asset;
          }
          oneTurn = !oneTurn;
        });
      },
      splashColor: Colors.white,
      child: Container(
        height: 80,
        width: 80,
        decoration: selected[index]
            ? BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 191, 189, 189)),
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 235, 235, 235),
                boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 225, 223, 223),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 4))
                  ])
            : const BoxDecoration(),
        child: Image.asset(asset),
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
        'birthDate': birthDate,
        'passwordPicture1': passwordOne,
        'passwordPicture2': passwordTwo,
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
    FocusScope.of(context).requestFocus(FocusNode());
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
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 5,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 4 - childrenPics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 50,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 250),
                itemBuilder: (context, index) {
                  return slectProfilePicture(availableProfilePics[index]);
                },
              ),
            ),
          ]);
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
      onTap: () {
        setState(() {
          profilePicture = asset;
        });
        Navigator.pop(context);
      },
      splashColor: Colors.white,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
      ),
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
          passwordOne = child.passwordPicture1!;
          passwordTwo = child.passwordPicture2!;
        });
      }
    });
    //getChildrenProfilePics();
  }
}
