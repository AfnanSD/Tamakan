import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tamakan/View/learning_map.dart';

class ChildHomePage extends StatelessWidget {
  const ChildHomePage({super.key});

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
        body: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        shadowColor: Colors.grey,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Container(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('points'), //need to update
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/images/star3.png',
                                  scale: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset('assets/images/lion.png'),
                SizedBox(height: 20),
                Text(
                  'مرحبا فهد \n متحمس للبدء؟\nهيا لنتعلم معا',
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
                                    builder: (context) => const LearningMap()));
                          },
                          child: Card(
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
                            color: Color.fromARGB(255, 252, 200, 200),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              print('points?'), //need update - make it badges?
                          child: Card(
                            child: Container(
                              height: 150,
                              width: 250,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/trophy.png',
                                    scale: 1,
                                  ),
                                  Text(
                                    'نقاطي',
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
      ),
    );
  }
}
