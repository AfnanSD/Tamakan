import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tamakan/View/edit_child_profile.dart';
import 'package:tamakan/View/exchange_points.dart';
import 'package:tamakan/View/manage_family.dart';
import 'package:tamakan/View/navigationBarChild.dart';
import 'package:tamakan/View/navigationBarParent.dart';
import 'package:tamakan/View/widgets/button_widget.dart';
import 'package:tamakan/View/widgets/child_points.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';

class ChildProfile extends StatefulWidget {
  const ChildProfile({super.key, required this.childID});

  final String childID;

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  var readingData = true;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    readChildData(widget.childID);
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'ملف طفلي',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ),
                          ChildPoints(child: child),
                        ],
                      ),
                      Image.asset(
                        child.profilePicture,
                        scale: 1.2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        margin: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
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
                                  Text(
                                    child.name,
                                    style: const TextStyle(fontSize: 20),
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
                                  Text(
                                    DateFormat.yMd().format(child.birthDate),
                                    style: const TextStyle(fontSize: 20),
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
                                      child.passwordPicture1!,
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
                                      child.passwordPicture2!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(
                        children: [
                          ButtonWidget(
                            fun: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ExhcangePoints(childID: child.childID),
                                ),
                              );
                            },
                            buttonLabel: 'استبدال نقاط طفلي',
                            buttonColor: const Color(0xff4ECDC4),
                          ),
                          ButtonWidget(
                            fun: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditChildProfile(
                                        childID: widget.childID),
                                  ));
                            },
                            buttonLabel: 'تعديل الحساب',
                            buttonColor: const Color(0xff1A535C),
                          ),
                          ButtonWidget(
                            fun: () {
                              showDeleteDialog(context);
                            },
                            buttonLabel: 'حذف الحساب',
                            buttonColor: const Color(0xffFF6B6B),
                          ),
                        ],
                      )
                    ],
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
        });
      }
    });
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      child: Text(
                        'هل أنت متأكد من حذف حساب ${child.name} ؟',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff4ECDC4)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Center(child: Text('الغاء')),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xffFF6B6B)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('parent')
                                    .doc(signedInUser.email)
                                    .collection('children')
                                    .doc(child.childID)
                                    .delete();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => navigation(),
                                  ),
                                );
                              },
                              child: const Center(child: Text('تأكيد')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
