import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:tamakan/View/child_coupons_view.dart';

import 'package:tamakan/View/levels/level1.dart';
import 'package:tamakan/View/levels/level10.dart';
import 'package:tamakan/View/levels/level2.dart';
import 'package:tamakan/View/levels/level3.dart';
import 'package:tamakan/View/levels/level4.dart';
import 'package:tamakan/View/levels/level5.dart';
import 'package:tamakan/View/levels/level6.dart';
import 'package:tamakan/View/levels/level7.dart';
import 'package:tamakan/View/levels/level8.dart';
import 'package:tamakan/View/levels/level9.dart';
import 'package:tamakan/View/widgets/child_points.dart';

import '../../Model/child.dart';

class levels extends StatefulWidget {
  const levels({super.key, required this.childID});

  final String childID;

  @override
  State<levels> createState() => _levelsState();
}

class _levelsState extends State<levels> {
  var readingData = true;
  late Child child;
  String level = ''; //for red error -> late initilize

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readChildData(widget.childID);
    currentLevel(widget.childID);
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "احسنت لقد وصلت للمستوى ",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 67, 65, 65)),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              " $level ",
                              style: TextStyle(
                                  fontSize: 30, color: Color(0xffFF6B6B)),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              " هيا استمر !",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 67, 65, 65)),
                              textAlign: TextAlign.center,
                            ),
                          ]),

                      SizedBox(
                        height: 45,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 1.8,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
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
                                      child: Image.asset(
                                          'assets/images/first.png',
                                          height: 600,
                                          width: 600,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 1 &&
                                                child.CurrentLevel <= 7
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                        color: child.CurrentLevel >= 8 &&
                                                child.CurrentLevel <= 13
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                        color: child.CurrentLevel >= 14 &&
                                                child.CurrentLevel <= 21
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/four.png',
                                          height: 800,
                                          width: 800,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 22 &&
                                                child.CurrentLevel <= 28
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/five.png',
                                          height: 600,
                                          width: 600,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 29 &&
                                                child.CurrentLevel <= 36
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/six.png',
                                          height: 800,
                                          width: 800,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 37 &&
                                                child.CurrentLevel <= 44
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/seven.png',
                                          height: 600,
                                          width: 600,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 45 &&
                                                child.CurrentLevel <= 51
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/eight.png',
                                          height: 800,
                                          width: 800,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 52 &&
                                                child.CurrentLevel <= 57
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/nine.png',
                                          height: 600,
                                          width: 600,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 58 &&
                                                child.CurrentLevel <= 63
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                                      child: Image.asset(
                                          'assets/images/ten.png',
                                          height: 800,
                                          width: 800,
                                          fit: BoxFit.cover),
                                      decoration: BoxDecoration(
                                        color: child.CurrentLevel >= 64 &&
                                                child.CurrentLevel <= 70
                                            ? Color.fromARGB(255, 253, 233, 210)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius:
                                                15.0, // soften the shadow
                                            spreadRadius:
                                                5.0, //extend the shadow
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
                          )),
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
        .doc(FirebaseAuth.instance.currentUser!.email) //update this
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

  Future<void> currentLevel(String childID) async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(FirebaseAuth.instance.currentUser!.email) //update this
        .collection('children')
        .where('childID', isEqualTo: childID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        child = Child.fromJson(element.data());
      }
    });

    if (child.CurrentLevel >= 1 && child.CurrentLevel <= 7)
      level = "الاول";
    else if (child.CurrentLevel >= 8 && child.CurrentLevel <= 13)
      level = "الثاني";
    else if (child.CurrentLevel >= 14 && child.CurrentLevel <= 21)
      level = "الثالث";
    else if (child.CurrentLevel >= 22 && child.CurrentLevel <= 28)
      level = "الرابع";
    else if (child.CurrentLevel >= 29 && child.CurrentLevel <= 36)
      level = "الخامس";
    else if (child.CurrentLevel >= 37 && child.CurrentLevel <= 44)
      level = "السادس";
    else if (child.CurrentLevel >= 45 && child.CurrentLevel <= 51)
      level = "السابع";
    else if (child.CurrentLevel >= 52 && child.CurrentLevel <= 57)
      level = "الثامن";
    else if (child.CurrentLevel >= 58 && child.CurrentLevel <= 63)
      level = "التاسع";
    else
      level = "العاشر";
  }
}
