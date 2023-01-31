import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
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
import 'package:tamakan/View/resetPasswordView.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/levels/levelMap.dart';
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
  String level = "";
  late String parentPassword;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readChildData(widget.childID);
    currentLevel(widget.childID);
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 253, 241, 237),
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   actions: <Widget>[
        //     Image.asset(
        //       'assets/images/logo3.png',
        //       scale: 0.5,
        //     ),
        //   ],
        //   backgroundColor: Color(0xffFF6B6B),
        // ),
        body: readingData
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/b2.png"),
                        fit: BoxFit.fill //BoxFit.cover,,
                        ,
                        opacity: 0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.all(20),
                              child: Card(
                                shadowColor: Colors.grey,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: Container(
                                    width: 40,
                                    child: IconButton(
                                      onPressed: () =>
                                          parentPasswordDialog(context),
                                      icon: Icon(Icons.logout_rounded,
                                          color: Color(0xff1A535C)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ChildPoints(child: child),
                          ]),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
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
                                  color: Color.fromARGB(255, 152, 152, 152))
                            ]),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(child.profilePicture),
                              const SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    ' أهلاً  ${child.name} ', //girl or boy!
                                    style: const TextStyle(
                                      fontFamily: 'Blabeloo',
                                      fontSize: 25,
                                      color: Color(0xff1A535C),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    "أحسنت لقد وصلت للمستوى ",
                                    style: const TextStyle(
                                      fontFamily: 'Blabeloo',
                                      fontSize: 25,
                                      color: Color(0xff1A535C),
                                    ),
                                  ),
                                  Text(' '),
                                  Row(
                                    children: [
                                      Text(
                                        " $level ",
                                        style: TextStyle(
                                            fontFamily: 'Blabeloo',
                                            fontSize: 20,
                                            color: Color(0xffFF6B6B)),
                                      ),
                                      Text(
                                        " هيا استمر !",
                                        style: TextStyle(
                                            fontFamily: 'Blabeloo',
                                            fontSize: 25,
                                            color: Color(0xff1A535C)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Lottie.network(
                              //     "https://assets6.lottiefiles.com/temp/lf20_aKAfIn.json"),
                            ]),
                      ),
                      SizedBox(height: 45),
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
                                            builder: (context) => LevelMap(
                                                  childID: widget.childID,
                                                  level: '1',
                                                )
                                            //  level1(
                                            //       CurrentLevel:
                                            //           child.CurrentLevel,
                                            //       childId: child.childID,
                                            //     )
                                            ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '2',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level2(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level3(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '3',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '4',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level4(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '5',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level5(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '6',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level6(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '7',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level7(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '8',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level8(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '9',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level9(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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
                                          builder: (context) => LevelMap(
                                            childID: widget.childID,
                                            level: '10',
                                          ),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          readChildData(widget.childID);
                                        });
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => level10(
                                      //               CurrentLevel:
                                      //                   child.CurrentLevel,
                                      //               childId: child.childID,
                                      //             )));
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

  parentPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    var errorMessage = '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                      "https://assets1.lottiefiles.com/packages/lf20_ALIsoI.json"),
                  const Text(
                    ': الرجاء إدخال كلمة مرور الوالد',
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    controller: passwordController,
                    obsecure: true,
                    myLabelText: 'كلمة المرور',
                    myHintText: '********',
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          width: 170,
                          child: const Center(
                            child: Text(
                              'إلغاء',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff4ECDC4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (passwordController.text == parentPassword) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              errorMessage = 'كلمة المرور خاطئة';
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          width: 170,
                          child: const Center(
                            child: Text(
                              'تأكيد',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => resetPasswordView(),
                          ),
                        );
                      },
                      child: const Text(
                        'هل نسيت كلمة المرور؟',
                        style: TextStyle(fontSize: 17),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection('parent')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) => parentPassword = value['password']);
  }
}
