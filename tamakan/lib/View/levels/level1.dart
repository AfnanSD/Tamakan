import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tamakan/Model/child.dart';
import 'package:tamakan/View/game_view.dart';

import 'package:tamakan/View/lesson_view.dart';

Color lightBlue = Color.fromARGB(255, 213, 247, 245);
Color red = Color(0xffFF6B6B);
Color black = Colors.black;

class level1 extends StatefulWidget {
  const level1({super.key, required this.CurrentLevel, required this.childId});

  final int CurrentLevel;
  final String childId;

  @override
  State<level1> createState() => _level1State();
}

class _level1State extends State<level1> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 232, 234, 177),
        appBar: AppBar(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/road.jpg"),
                fit: BoxFit.fill //fitWidth //BoxFit.cover,
                ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: <Widget>[
              Column(children: [
                SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  child: Lottie.network(
                      "https://assets2.lottiefiles.com/packages/lf20_qidusS.json"),
                  //Image.asset(
                  //   'assets/images/trophy.png',
                  //   scale: 0.5,
                  // ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            practiceID: '7.5',
                            childID: widget.childId,
                          ),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 243, 208),
                      fixedSize: const Size(100, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      shadowColor: black),
                ),
              ]),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 40,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    '7',
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: widget.CurrentLevel >= 7
                                      ? () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LessonView(
                                                        lessonID: '7',
                                                        childID: widget.childId,
                                                      )));
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: lightBlue,
                                      fixedSize: const Size(50, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      shadowColor: black),
                                ),
                              ],
                            )),
                        widget.CurrentLevel >= 8
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 70),
                                child: Row(children: [
                                  Image.asset(
                                    'assets/images/star1.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/star3.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Image.asset(
                                    'assets/images/star2.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ]))
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 70),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/star1gray.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Image.asset(
                                      'assets/images/star2gray.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                    Image.asset(
                                      'assets/images/star1gray.png',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    // SizedBox(
                    //   width: 60,
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(children: [
                SizedBox(width: 240),
                Column(children: [
                  ElevatedButton(
                    child: Text(
                      '6',
                      style: TextStyle(
                          fontSize: 25,
                          color: red,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: widget.CurrentLevel >= 6
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LessonView(
                                          lessonID: '6',
                                          childID: widget.childId,
                                        )));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: lightBlue,
                        fixedSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        shadowColor: black),
                  ),
                  widget.CurrentLevel >= 7
                      ? Row(children: [
                          Image.asset(
                            'assets/images/star1.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star3.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star2.png',
                            width: 40,
                            height: 40,
                          ),
                        ])
                      : Row(children: [
                          Image.asset(
                            'assets/images/star1gray.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star2gray.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star1gray.png',
                            width: 40,
                            height: 40,
                          ),
                        ]),
                ]),
                SizedBox(width: 20),
                Column(children: [
                  ElevatedButton(
                    child: Text(
                      '5',
                      style: TextStyle(
                          fontSize: 25,
                          color: red,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: widget.CurrentLevel >= 5
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LessonView(
                                          lessonID: '5',
                                          childID: widget.childId,
                                        )));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: lightBlue,
                        fixedSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        shadowColor: black),
                  ),
                  widget.CurrentLevel >= 6
                      ? Row(children: [
                          Image.asset(
                            'assets/images/star1.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star3.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star2.png',
                            width: 40,
                            height: 40,
                          ),
                        ])
                      : Row(children: [
                          Image.asset(
                            'assets/images/star1gray.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star2gray.png',
                            width: 40,
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/star1gray.png',
                            width: 40,
                            height: 40,
                          ),
                        ]),
                ])
              ]),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Text(
                          '4',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 4
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LessonView(
                                              lessonID: '4',
                                              childID: widget.childId,
                                            )));
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: lightBlue,
                            fixedSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            shadowColor: black),
                      ),
                    ]),
              ),
              widget.CurrentLevel >= 5
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/star1.png',
                              width: 40,
                              height: 40,
                            ),
                            Image.asset(
                              'assets/images/star3.png',
                              width: 40,
                              height: 40,
                            ),
                            Image.asset(
                              'assets/images/star2.png',
                              width: 40,
                              height: 40,
                            ),
                          ]),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'assets/images/star1gray.png',
                              width: 40,
                              height: 40,
                            ),
                            Image.asset(
                              'assets/images/star2gray.png',
                              width: 40,
                              height: 40,
                            ),
                            Image.asset(
                              'assets/images/star1gray.png',
                              width: 40,
                              height: 40,
                            ),
                          ]),
                    ),
              Row(
                children: [
                  SizedBox(width: 105),
                  Column(children: [
                    ElevatedButton(
                      child: Text(
                        '1',
                        style: TextStyle(
                            fontSize: 25,
                            color: red,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: widget.CurrentLevel >= 1
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LessonView(
                                            lessonID: '1',
                                            childID: widget.childId,
                                          )));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: lightBlue,
                          fixedSize: const Size(50, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          shadowColor: black),
                    ),
                    widget.CurrentLevel >= 2
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Image.asset(
                                  'assets/images/star1.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star3.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star2.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ])
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Image.asset(
                                  'assets/images/star1gray.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star2gray.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star1gray.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ]),
                  ]),
                  SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            '2',
                            style: TextStyle(
                                fontSize: 25,
                                color: red,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: widget.CurrentLevel >= 2
                              ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LessonView(
                                                lessonID: '2',
                                                childID: widget.childId,
                                              )));
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: lightBlue,
                              fixedSize: const Size(50, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              shadowColor: black),
                        ),
                        widget.CurrentLevel >= 3
                            ? Row(children: [
                                Image.asset(
                                  'assets/images/star1.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star3.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star2.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ])
                            : Row(children: [
                                Image.asset(
                                  'assets/images/star1gray.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star2gray.png',
                                  width: 40,
                                  height: 40,
                                ),
                                Image.asset(
                                  'assets/images/star1gray.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ]),
                      ]),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(
                          '3',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 3
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LessonView(
                                              lessonID: '3',
                                              childID: widget.childId,
                                            )));
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: lightBlue,
                            fixedSize: const Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            shadowColor: black),
                      ),
                      widget.CurrentLevel >= 4
                          ? Row(children: [
                              Image.asset(
                                'assets/images/star1.png',
                                width: 40,
                                height: 40,
                              ),
                              Image.asset(
                                'assets/images/star3.png',
                                width: 40,
                                height: 40,
                              ),
                              Image.asset(
                                'assets/images/star2.png',
                                width: 40,
                                height: 40,
                              ),
                            ])
                          : Row(children: [
                              Image.asset(
                                'assets/images/star1gray.png',
                                width: 40,
                                height: 40,
                              ),
                              Image.asset(
                                'assets/images/star2gray.png',
                                width: 40,
                                height: 40,
                              ),
                              Image.asset(
                                'assets/images/star1gray.png',
                                width: 40,
                                height: 40,
                              ),
                            ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
