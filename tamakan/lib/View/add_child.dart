import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:tamakan/Model/child.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final availableProfilePics = ['lion', 'crocodile', 'owl', 'pigeon']; //?
  DateTime? birthDate;
  var selected = [false, false, false, false, false, false]; //for passwrod
  var oneSelected = false; //for passwrod
  String passwordPicture = '';
  var profilePictureChoosen = false;
  String profilePicture = '';
  var submit = false;

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
            IconButton(
              icon: Icon(Icons.logout),
              //need update
              onPressed: (() => print('log out')),
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'إضافة طفل',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: profilePictureChoosen
                            ? Image.asset(
                                profilePicture,
                                scale: 1.2,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                  size: 200,
                                  color: Colors.grey,
                                ),
                              ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 235, 235, 235),
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
                      decoration: InputDecoration(
                        labelText: 'اسم طفلك',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 90, 122, 149),
                        ),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال اسم الطفل';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
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
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('كلمة السر لطفلك'),
                              Text(
                                !oneSelected && submit
                                    ? 'الرجاء اختيار كلمة سر'
                                    : '',
                                style: TextStyle(
                                  color: Theme.of(context).errorColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
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
                          SizedBox(
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
                          SizedBox(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xffFF6B6B)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: submitData,
                        child: Container(
                          child: Center(child: Text('إضافة')),
                          width: double.infinity,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }

  submitData() async {
    setState(() {
      submit = true;
    });

    final isValid = _formKey.currentState!.validate();
    if (isValid && profilePictureChoosen && oneSelected) {
      final docRef = FirebaseFirestore.instance
          .collection('parent')
          .doc('a@gmail.com')
          .collection('children')
          .doc();
      Child child = new Child(
          childID: docRef.id,
          name: nameController.text,
          birthDate: birthDate!,
          profilePicture: profilePicture,
          passwordPicture: passwordPicture);

      await docRef.set(child.toJson());

      Navigator.pop(context);
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

  Widget PassowordIconButton(String asset, int index) {
    return InkWell(
      child: Container(
        height: 120,
        width: 120,
        child: Image.asset(asset),
        decoration: selected[index]
            ? BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 191, 189, 189)),
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 235, 235, 235),
                boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 225, 223, 223),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 15))
                  ])
            : BoxDecoration(),
      ),
      onTap: () {
        setState(() {
          selected.fillRange(0, 6, false);
          selected[index] = !selected[index];
          oneSelected = true;
          passwordPicture = asset;
        });
      },
      splashColor: Colors.white,
    );
  }

  void selectProfilePic(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  slectProfilePicture('assets/images/lion.png', 'lion'),
                  slectProfilePicture('assets/images/owl.png', 'owl'),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  slectProfilePicture('assets/images/pigeon.png', 'pigeon'),
                  slectProfilePicture(
                      'assets/images/crocodile.png', 'crocodile'),
                ]),
              ],
            ),
          );
        });
  }

  Widget slectProfilePicture(String asset, String picked) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(20),
        // height: 160,
        // width: 160,
        child: Image.asset(
          asset,
          scale: 1.5,
        ),
      ),
      onTap: () {
        setState(() {
          profilePictureChoosen = true;
          profilePicture = asset;
        });
      },
      splashColor: Colors.white,
    );
  }
}
