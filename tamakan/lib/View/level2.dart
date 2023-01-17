import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/Model/child.dart';
import 'package:tamakan/View/game_view.dart';
import 'package:tamakan/View/lesson_view.dart';

Color lightBlue = Color.fromARGB(255, 213, 247, 245);
Color red = Color(0xffFF6B6B);
Color black = Colors.black;

class level2 extends StatefulWidget {
  const level2({super.key, required this.CurrentLevel, required this.childId});

  final int CurrentLevel;
  final String childId;

  @override
  State<level2> createState() => _level2State();
}

class _level2State extends State<level2> {
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
                  child: Image.asset(
                    'assets/images/trophy.png',
                    scale: 0.5,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            practiceID: '13.5',
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
              SizedBox(height: 60),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 200),
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: Text(
                          '13',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 13
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LessonView(
                                              lessonID: '13',
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
                      )
                    ],
                  )),
              widget.CurrentLevel >= 14
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 160),
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
                      padding: EdgeInsets.symmetric(horizontal: 160),
                      child: Row(children: [
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
                      ])),
              SizedBox(height: 40),
              Row(children: [
                SizedBox(width: 280),
                Column(children: [
                  ElevatedButton(
                    child: Text(
                      '12',
                      style: TextStyle(
                          fontSize: 25,
                          color: red,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: widget.CurrentLevel >= 12
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LessonView(
                                          lessonID: '12',
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
                  widget.CurrentLevel >= 13
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
                SizedBox(width: 120),
                Column(children: [
                  ElevatedButton(
                    child: Text(
                      '11',
                      style: TextStyle(
                          fontSize: 25,
                          color: red,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: widget.CurrentLevel >= 11
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LessonView(
                                          lessonID: '11',
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
                  widget.CurrentLevel >= 12
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
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Text(
                          '10',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 10
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LessonView(
                                              lessonID: '10',
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
              widget.CurrentLevel >= 11
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
                  SizedBox(width: 180),
                  Column(children: [
                    ElevatedButton(
                      child: Text(
                        '8',
                        style: TextStyle(
                            fontSize: 25,
                            color: red,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: widget.CurrentLevel >= 8
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LessonView(
                                            lessonID: '8',
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
                    widget.CurrentLevel >= 9
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
                  SizedBox(width: 100),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(
                          '9',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 9
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LessonView(
                                              lessonID: '9',
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
                      widget.CurrentLevel >= 10
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
