import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';

class ViewChildProfile extends StatefulWidget {
  const ViewChildProfile({super.key, required this.childID});

  final String childID;

  @override
  State<ViewChildProfile> createState() => _ViewChildProfileState();
}

class _ViewChildProfileState extends State<ViewChildProfile> {
  var readingData = true;
  late Child child;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        body: readingData
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'ملف طفلي',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Image.asset(
                        child.profilePicture,
                        scale: 1.2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    initialValue: child.name,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                    enabled: false,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                    initialValue: DateFormat.yMd()
                                        .format(child.birthDate),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                    enabled: false,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xff4ECDC4)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {}, //need update
                                  child: Container(
                                    child: Center(child: Text('تعديل الحساب')),
                                    width: double.infinity,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffFF6B6B)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () => showCustomDialog(context),
                                  child: Container(
                                    child: Center(child: Text('حذف الحساب')),
                                    width: double.infinity,
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> readChildData(String childID) async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc('a@gmail.com') //update this
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

  void showCustomDialog(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
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
                                .doc('a@gmail.com') //update this
                                .collection('children')
                                .doc(child.childID)
                                .delete();
                          },
                          child: Container(
                            child: Center(child: Text('تأكيد')),
                            width: 200,
                          )),
                    )
                  ],
                ),
              ));
        });
  }
}
