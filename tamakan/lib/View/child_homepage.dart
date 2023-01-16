import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:tamakan/View/child_coupons_view.dart';
import 'package:tamakan/View/learning_map.dart';
import 'package:tamakan/View/learning_map2.dart';
import 'package:tamakan/View/levels.dart';
import 'package:tamakan/View/widgets/child_points.dart';

import '../Model/child.dart';

class ChildHomePage extends StatefulWidget {
  const ChildHomePage({super.key, required this.childID});

  final String childID;

  @override
  State<ChildHomePage> createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  var readingData = true;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    readChildData(widget.childID);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
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
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChildPoints(child: child),
                    Image.asset(child.profilePicture),
                    SizedBox(height: 20),
                    Text(
                      'مرحبا ${child.name} \n متحمس للبدء؟\nهيا لنتعلم معا', //girl or boy!
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => print('quran'), // need update
                              child: Card(
                                  child: Container(
                                    height: 150,
                                    width: 250,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/book.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'القرآن',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Color.fromARGB(255, 213, 247, 245)),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          levels(childID: widget.childID)
                                      // levels(
                                      //   childID: child.childID,
                                      // ),
                                      ),
                                );
                              },
                              child: Card(
                                color: Color.fromARGB(255, 252, 200, 200),
                                child: Container(
                                  height: 150,
                                  width: 250,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/location.png',
                                        scale: 1.8,
                                      ),
                                      Text(
                                        'الدروس',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChildCouponsVIew(
                                  childID: widget.childID,
                                ),
                              )),
                              child: Card(
                                child: Container(
                                  height: 150,
                                  width: 250,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/coupon.png',
                                        scale: 4.5,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'قسائمي',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                                color: Color.fromARGB(255, 244, 235, 192),
                              ),
                            ),
                            InkWell(
                              onTap: () => print('parent'), //need update
                              child: Card(
                                  child: Container(
                                    height: 150,
                                    width: 250,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/hand.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'والدي',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Color.fromARGB(255, 213, 247, 245)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
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
        .doc(signedInUser.email) //update this
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
}
