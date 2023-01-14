import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/Model/child.dart';
import 'package:tamakan/View/game.dart';
import 'package:tamakan/View/lesson.dart';

Color lightBlue = Color.fromARGB(255, 213, 247, 245);
Color red = Color(0xffFF6B6B);
Color black = Colors.black;

class level7 extends StatefulWidget {
  const level7({super.key, required this.CurrentLevel, required this.childId});

  final int CurrentLevel;
  final String childId;

  @override
  State<level7> createState() => _level7State();
}

class _level7State extends State<level7> {
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
                          builder: (context) => Game(
                            practiceID: '51.5',
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
                          '51',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 51
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Lesson(
                                              lessonID: '51',
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
              widget.CurrentLevel >= 52
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
                      '50',
                      style: TextStyle(
                          fontSize: 25,
                          color: red,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: widget.CurrentLevel >= 50
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lesson(
                                          lessonID: '50',
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
                  widget.CurrentLevel >= 51
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
                      '49',
                      style: TextStyle(
                          fontSize: 25,
                          color: red,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: widget.CurrentLevel >= 49
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Lesson(
                                          lessonID: '49',
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
                  widget.CurrentLevel >= 50
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
                          '48',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 48
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Lesson(
                                              lessonID: '48',
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
              widget.CurrentLevel >= 49
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
                        '45',
                        style: TextStyle(
                            fontSize: 25,
                            color: red,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: widget.CurrentLevel >= 45
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Lesson(
                                            lessonID: '45',
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
                    widget.CurrentLevel >= 46
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
                  SizedBox(width: 75),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            '46',
                            style: TextStyle(
                                fontSize: 25,
                                color: red,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: widget.CurrentLevel >= 46
                              ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Lesson(
                                                lessonID: '46',
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
                        widget.CurrentLevel >= 47
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
                  SizedBox(width: 75),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(
                          '47',
                          style: TextStyle(
                              fontSize: 25,
                              color: red,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: widget.CurrentLevel >= 47
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Lesson(
                                              lessonID: '47',
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
                      widget.CurrentLevel >= 48
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
