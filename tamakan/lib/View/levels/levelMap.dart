import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tamakan/View/game_view.dart';
import 'package:tamakan/View/lesson_view.dart';

import '../../Model/child.dart';

class LevelMap extends StatefulWidget {
  const LevelMap({super.key, required this.childID, required this.level});

  final String childID;
  final String level;

  @override
  State<LevelMap> createState() => _LevelMapState();
}

class _LevelMapState extends State<LevelMap> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  bool readingChihldData = true;
  bool gettingLessonIDs = true;
  late Child child;
  late List<String> lessonIDs = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    readChildData(widget.childID);
    getLessonsIDs();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: readingChihldData || gettingLessonIDs
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/levelbackground.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //home icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.home,
                                        color: Color(0xff1A535C),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                //points
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Card(
                                    margin: const EdgeInsets.all(7),
                                    shadowColor: Colors.grey,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      child: SizedBox(
                                        width: 90,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('${child.points}'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 30,
                                              color: Color.fromRGBO(
                                                  255, 230, 109, 1),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          //,
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        child: Text(
                                          'اختبر',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: 'Blabeloo',
                                              color: Color(0xff1A535C)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'معلوماتك',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: 'Blabeloo',
                                              color: Color(0xff1A535C)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: InkWell(
                                  onTap: () {
                                    var practiceId =
                                        int.parse(widget.level) * 7 + 0.5;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameView(
                                          childID: widget.childID,
                                          practiceID: practiceId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[
                                            100], //blue? - Colors.grey[100]
                                        shape: BoxShape.circle,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(-2, 2),
                                              blurRadius: 0.5,
                                              spreadRadius: 0.7)
                                        ]),
                                    child: Image.asset(
                                      'assets/images/trophy.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 100.0,
                              right: 100,
                            ),
                            child: Column(
                              verticalDirection: VerticalDirection.up,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                ...getSteps(),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
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
          readingChihldData = false;
        });
      }
    });
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

  List<Widget> getSteps() {
    List<Widget> returnedList = List<Widget>.empty(growable: true);
    int placeIndex = 1;
    for (var element in lessonIDs) {
      if (placeIndex == 1) {
        returnedList.add(
          Row(
            children: [
              const Spacer(),
              step(element.toString(), false),
            ],
          ),
        );
        placeIndex++;
      } else {
        returnedList.add(
          Row(
            children: [
              step(element.toString(), false),
              const Spacer(),
            ],
          ),
        );
        placeIndex--;
      }
    }
    return returnedList;
  }

  Widget step(String number, bool activated) {
    return InkWell(
      onTap: (child.CurrentLevel < int.parse(number))
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonView(
                    childID: widget.childID,
                    lessonID: number.toString(),
                  ),
                ),
              );
            },
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              elevation: 6,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                        color: (child.CurrentLevel < int.parse(number))
                            ? Colors.grey[300]
                            : (child.CurrentLevel == int.parse(number))
                                ? const Color(0xffFF6B6B)
                                : const Color(0xff4ECDC4),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(-2, 2),
                              blurRadius: 0.5,
                              spreadRadius: 0.7)
                        ]),
                  ),
                  Center(
                      child: Text(
                    number,
                    style: const TextStyle(
                        fontFamily: 'Blabeloo',
                        fontSize: 20,
                        color: Colors.white),
                  )),
                ],
              ),
            ),
          ),
          (child.CurrentLevel == int.parse(number))
              ? SizedBox(
                  height: 40,
                  child: Image.asset(
                    child.profilePicture,
                    fit: BoxFit.contain,
                  ),
                )
              : const Text(''),
        ],
      ),
    );
  }

  void getLessonsIDs() {
    int max = int.parse(widget.level) * 7;
    int min = 0;
    if (max != 7) min = max - 7;
    for (var i = ++min; i <= max; i++) {
      lessonIDs.add(i.toString());
    }
    setState(() {
      gettingLessonIDs = false;
    });
  }
}
