import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:tamakan/Model/child.dart';
import 'package:tamakan/View/navigationBarParent.dart';
import 'package:tamakan/View/widgets/button_widget.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final availableProfilePics = [
    'assets/images/crocodile.png',
    'assets/images/lion.png',
    'assets/images/owl.png',
    'assets/images/pigeon.png'
  ];
  DateTime? birthDate;
  var selected = [false, false, false, false, false, false]; //for passwrod
  var oneSelected = false; //for passwrod
  String passwordPicture = '';
  var profilePictureChoosen = false;
  String profilePicture = '';
  var submit = false;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  late List<String> childrenNames = List<String>.empty(growable: true);

  late List<String> passwordPictureSequence = ['', ''];
  int passwordPictureSequenceIndex = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getChildrenNames();
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
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'إضافة طفل',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 235, 235, 235),
                        ),
                        child: profilePictureChoosen
                            ? Image.asset(
                                profilePicture,
                                scale: 1.2,
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                  size: 200,
                                  color: Colors.grey,
                                ),
                              ),
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
                      Text(
                        !profilePictureChoosen && submit
                            ? 'الرجاء اختيار صورة لطفلك'
                            : '',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'اسم طفلك',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 90, 122, 149),
                        ),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم الطفل';
                        } else if (childrenNames
                            .any((element) => element == value)) {
                          return 'اسم الطفل موجود سابقا';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'تاريخ ميلاده',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 90, 122, 149),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال تاريخ ميلاد الطفل';
                        }
                        return null;
                      },
                      onTap: presentDatePicker,
                      controller: _birthDateController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('كلمة السر لطفلك'),
                            Text(
                              !oneSelected && submit
                                  ? 'الرجاء اختيار كلمة سر'
                                  : '',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ...passwordPictureSequence
                                    .map((e) => Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            shape: BoxShape.circle),
                                        height: 55,
                                        width: 55,
                                        margin: const EdgeInsets.all(2),
                                        padding: const EdgeInsets.all(3),
                                        child: (e != '')
                                            ? Image.asset(
                                                e,
                                                fit: BoxFit.cover,
                                              )
                                            : const Text('')))
                                    .toList()
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            PassowordIconButton(
                                'assets/images/yellow-flower.png', 0),
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
                                'assets/images/red-maple-leaf.png', 2),
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
                                'assets/images/snowy-pine-trees.png', 4),
                            PassowordIconButton('assets/images/sun.png', 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ButtonWidget(
                    fun: submitData,
                    buttonLabel: 'إضافة',
                    buttonColor: const Color(0xffFF6B6B),
                  )
                ],
              ),
            ),
          ),
        ),
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

  submitData() async {
    setState(() {
      submit = true;
    });

    final isValid = _formKey.currentState!.validate();
    if (isValid && profilePictureChoosen && oneSelected) {
      final docRef = FirebaseFirestore.instance
          .collection('parent')
          .doc(signedInUser.email)
          .collection('children')
          .doc();
      Child child = Child(
        childID: docRef.id,
        name: nameController.text,
        birthDate: birthDate!,
        profilePicture: profilePicture,
        passwordPicture1: passwordPictureSequence[0],
        passwordPicture2: passwordPictureSequence[1],
        points: 0,
        CurrentLevel: 1,
      );

      await docRef.set(child.toJson());

      //dont update
      //Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => navigation(),
        ),
      );
      //make back button navigate wrong
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const ManageFamily()));
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

  Widget PassowordIconButton(String asset, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selected.fillRange(0, 6, false);
          selected[index] = !selected[index];
          passwordPicture = asset;
          passwordPictureSequence[passwordPictureSequenceIndex] = asset;
          oneSelected = passwordPictureSequence[1].isNotEmpty;
          passwordPictureSequenceIndex++;
          if (passwordPictureSequenceIndex == 2) {
            passwordPictureSequenceIndex = 0;
          }
        });
      },
      splashColor: Colors.white,
      child: Container(
        height: 120,
        width: 120,
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
                        offset: Offset(0, 15))
                  ])
            : const BoxDecoration(),
        child: Image.asset(asset),
      ),
    );
  }

  void selectProfilePic(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GridView.builder(
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                maxCrossAxisExtent: 350),
            itemBuilder: (context, index) {
              return slectProfilePicture(availableProfilePics[index]);
            },
          );
        });
  }

  Widget slectProfilePicture(String asset) {
    return InkWell(
      onTap: () {
        setState(() {
          profilePictureChoosen = true;
          profilePicture = asset;
        });
        Navigator.pop(context);
      },
      splashColor: Colors.white,
      child: Image.asset(
        asset,
        scale: 1.3,
      ),
    );
  }

  Future<void> getChildrenNames() async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email)
        .collection('children')
        .get()
        .then((value) {
      for (var element in value.docs) {
        childrenNames.add(element['name']);
      }
    });
  }
}
