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
import 'package:tamakan/View/level1.dart';
import 'package:tamakan/View/level10.dart';
import 'package:tamakan/View/level2.dart';
import 'package:tamakan/View/level3.dart';
import 'package:tamakan/View/level4.dart';
import 'package:tamakan/View/level5.dart';
import 'package:tamakan/View/level6.dart';
import 'package:tamakan/View/level7.dart';
import 'package:tamakan/View/level8.dart';
import 'package:tamakan/View/level9.dart';
import 'package:tamakan/View/widgets/child_points.dart';

import '../Model/child.dart';

class levels extends StatefulWidget {
  const levels({super.key, required this.childID});

  final String childID;

  @override
  State<levels> createState() => _levelsState();
}

class _levelsState extends State<levels> {
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
        backgroundColor: Color.fromARGB(255, 186, 208, 225),
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
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/b2.png"),
                        fit: BoxFit.fill //BoxFit.cover,
                        ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ChildPoints(child: child),
                      // Image.asset(child.profilePicture),
                      // SizedBox(height: 20),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "اي مرحلة وصلت يابطل!",
                      //       style: TextStyle(
                      //           fontSize: 30,
                      //           color: Color.fromARGB(255, 67, 65, 65)),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //     Image.asset(
                      //       child.profilePicture,
                      //       width: 45,
                      //       height: 45,
                      //     )
                      //   ],
                      // ),
                      Text(
                        "اي مرحلة وصلت يابطل!",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 67, 65, 65)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level1(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/first.png',
                                      height: 600,
                                      width: 600,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 45,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level2(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/s .png',
                                      height: 600,
                                      width: 600,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 45,
                            width: 45,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level3(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/t .png',
                                      height: 600,
                                      width: 600,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 45,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level4(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/four.png',
                                      height: 800,
                                      width: 800,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 45,
                            width: 45,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level5(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/five.png',
                                      height: 600,
                                      width: 600,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 45,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level6(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/six.png',
                                      height: 800,
                                      width: 800,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 45,
                            width: 45,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level7(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/seven.png',
                                      height: 600,
                                      width: 600,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 45,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level8(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/eight.png',
                                      height: 800,
                                      width: 800,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 45,
                            width: 45,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level9(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/nine.png',
                                      height: 600,
                                      width: 600,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 45,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => level10(
                                                CurrentLevel:
                                                    child.CurrentLevel,
                                                childId: child.childID,
                                              )));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  width: 220,
                                  child: Image.asset('assets/images/ten.png',
                                      height: 800,
                                      width: 800,
                                      fit: BoxFit.cover),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 5.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 45,
                          )
                        ],
                      ),
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
