import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/Model/userModel.dart';
import 'package:tamakan/View/deleteAccountView.dart';
import 'package:tamakan/View/parentHome.dart';
import 'package:tamakan/View/parentProfileEdit.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/button_widget.dart';
import 'package:tamakan/View/widgets/labels.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tamakan/View/widgets/lable_grey.dart';

import 'manage_family.dart';
import 'myChildren.dart';

class parentprofileview extends StatefulWidget {
  const parentprofileview({super.key});

  @override
  State<parentprofileview> createState() => _parentprofileviewState();
}

final List<String> genders = [
  'أنثى',
  'ذكر',
];
String? gender = 'أنثى';

class _parentprofileviewState extends State<parentprofileview> {
  UserModel? userModel;

  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lodProfile();
  }

  @override
  Widget build(BuildContext context) {
    final lougout = ButtonWidget(
        fun: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          titlePadding: const EdgeInsets.all(0),
                          title: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: Color(0xffFF6B6B)),
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              child: Text(
                                '! تحذير',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 239, 235, 208),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          scrollable: true,
                          content: Container(
                            child: Form(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'هل أنت متأكد من تسجيل الخروج؟',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color(0xffFF6B6B)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 30),
                                          child: Text(
                                            'إلغاء',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ///////
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            EasyLoading.showSuccess(
                                                '!تم تسجيل الخروج بنجاح');
                                            EasyLoading.dismiss();
                                            Navigator.pushNamed(
                                                context, '/loginview');
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Color(0xffFF6B6B)),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 30),
                                          child: Text(
                                            'خروج',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                },
              )
            },
        buttonLabel: ' تسجيل الخروج',
        buttonColor: Color(0xff1A535C));
    //updata button
    final updataButton = ButtonWidget(
        fun: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => parentprofileEdit()))
            },
        buttonLabel: ' تعديل',
        buttonColor: Color(0xff4ECDC4));

    final updataButton1 = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(255, 230, 109, 1),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => parentprofileEdit()));
        },
        child: Text(
          "تعديل",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    //cancel button
    final cancelButton = Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 76, 180, 184),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => parentHome()));
        },
        child: Text(
          "العودة",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
//delete button
    final deleteButton = ButtonWidget(
      fun: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const deleteAccount()))
      },
      buttonLabel: 'حذف حسابي',
      buttonColor: Color(0xffFF6B6B),
    );
    final deleteButton1 = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffFF6B6B),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const deleteAccount()))
        },
        child: Text(
          "حذف حسابي",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              constraints: const BoxConstraints.expand(),
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage("./images/noborderwaves.png"),
              //       fit: BoxFit.cover),
              // ),
              child: Column(
                children: [
                  Text('   الملف الشخصي ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6),

                  const SizedBox(
                    height: 15,
                  ),
                  //here starts the text fields that the user will enter
                  !isloading
                      ? const Expanded(
                          child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFF6B6B),
                          ),
                        ))
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 5),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                          color: Colors.grey[300]!)
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // name
                                    Row(
                                      children: [
                                        label(inputLabel: 'الإسم'),
                                        Text(": "),
                                        labelGrey(inputLabel: userModel!.name),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    //email
                                    Row(
                                      children: [
                                        label(inputLabel: 'البريد الإلكتروني'),
                                        Text(": "),
                                        labelGrey(inputLabel: userModel!.email),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    //GENDER
                                    Row(children: [
                                      label(inputLabel: 'الجنس'),
                                      Text(": "),
                                      labelGrey(inputLabel: userModel!.gender),
                                    ]),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // birthdate
                                    Row(children: [
                                      label(inputLabel: 'تاريخ الميلاد'),
                                      Text(": "),
                                      labelGrey(
                                          inputLabel: userModel!.birthdate),
                                    ]),
                                    SizedBox(
                                      height: 45,
                                    ),
                                    updataButton,
                                    lougout,
                                    deleteButton,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> lodProfile() async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      userModel = UserModel.fromSnap(value);
      isloading = true;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
