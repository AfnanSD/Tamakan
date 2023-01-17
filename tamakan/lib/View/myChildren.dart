import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import 'child_homepage.dart';

class myChildren extends StatefulWidget {
  const myChildren({super.key});

  @override
  State<myChildren> createState() => _myChildren();
}

class _myChildren extends State<myChildren> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  late List<String> passwordPictureSequence = ['', ''];
  int passwordPictureSequenceIndex = 0;

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email) //update this
        .collection('children')
        .get();
    return qn.docs;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  Widget PassowordIconButton(String asset, Function setstate) {
    return InkWell(
      child: Container(
          height: 120,
          width: 120,
          child: Image.asset(asset),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 191, 189, 189)),
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 235, 235, 235),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 225, 223, 223),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 15))
              ])),
      onTap: () {
        setstate(() {
          passwordPictureSequence[passwordPictureSequenceIndex] = asset;
          passwordPictureSequenceIndex++;
          if (passwordPictureSequenceIndex == 2)
            passwordPictureSequenceIndex = 0;
        });
      },
      splashColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("      قائمة أطفالك",
                style: TextStyle(
                    fontSize: 40, color: Color.fromARGB(255, 26, 83, 92))),
          ),
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (_, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, int index) {
                  DocumentSnapshot data = snapshot.data[index];

                  return Center(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            builder: (_) {
                              passwordPictureSequence[0] = '';
                              passwordPictureSequence[1] = '';
                              return StatefulBuilder(
                                builder: (context, setState) => Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'أدخل كلمة السر الخاصة بك',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Color.fromARGB(
                                                  255, 26, 83, 92)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                print('validate');
                                                print(
                                                    passwordPictureSequence[0]);
                                                print(
                                                    passwordPictureSequence[1]);
                                                print(data['passwordPicture1']);
                                                if (passwordPictureSequence[
                                                            0] ==
                                                        data[
                                                            'passwordPicture1'] &&
                                                    passwordPictureSequence[
                                                            1] ==
                                                        data[
                                                            'passwordPicture2']) {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChildHomePage(
                                                                childID: data[
                                                                    'childID']),
                                                      ));
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.navigate_before,
                                                color: Colors.green,
                                              ),
                                            ),
                                            ...passwordPictureSequence.reversed
                                                .map((e) => Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape: BoxShape.circle),
                                                    height: 55,
                                                    width: 55,
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: (e != '')
                                                        ? Image.asset(
                                                            e,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Text('')))
                                                .toList(),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: [
                                            //     SizedBox(
                                            //       height: 200,
                                            //     ),
                                            //     Text(
                                            //       'أدخل كلمة السر الخاصة بك',
                                            //       style: TextStyle(
                                            //           fontSize: 25,
                                            //           color: Color.fromARGB(
                                            //               255, 26, 83, 92)),
                                            //     ),
                                            //   ],
                                            // ),
                                            // SizedBox(
                                            //   width: 40,
                                            // ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: PassowordIconButton(
                                                      'assets/images/snowy-pine-trees.png',
                                                      setState),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: PassowordIconButton(
                                                      'assets/images/sun.png',
                                                      setState),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: PassowordIconButton(
                                                      'assets/images/red-maple-leaf.png',
                                                      setState),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: PassowordIconButton(
                                                      'assets/images/snowflake.png',
                                                      setState),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: PassowordIconButton(
                                                        'assets/images/yellow-flower.png',
                                                        setState),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: PassowordIconButton(
                                                      'assets/images/mushroom.png',
                                                      setState),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            context: context);
                      }
                      // data['passwordPicture'] == image url // need update
                      ,
                      child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        color: const Color.fromARGB(255, 244, 242, 201),
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.all(20.0),
                        child: Container(
                          height: 150,
                          width: 600,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(data["profilePicture"]),
                              SizedBox(
                                width: 10,
                              ),
                              Text("الاسم: " + data["name"] + "\n",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 26, 83, 92))),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                  "  \n عدد النقاط: " +
                                      data["points"].toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color.fromARGB(255, 26, 83, 92))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
