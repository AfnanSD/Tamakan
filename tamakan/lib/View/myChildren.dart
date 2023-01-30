import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tamakan/View/navigationBarChild.dart';
import 'package:tamakan/View/parentProfileView.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/child_points.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import 'child_homepage.dart';
import 'manage_family.dart';
import 'resetPasswordView.dart';

class myChildren extends StatefulWidget {
  const myChildren({super.key});

  @override
  State<myChildren> createState() => _myChildren();
}

class _myChildren extends State<myChildren> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  late String parentPassword;

  late List<String> passwordPictureSequence = ['', ''];
  int passwordPictureSequenceIndex = 0;

  String errorMessage = '';

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
    getCurrentUserData();
  }

  Widget PassowordIconButton(String asset, Function setModalState,
      String picOne, String picTwo, String childID) {
    return InkWell(
      onTap: () {
        setModalState(() {
          passwordPictureSequence[passwordPictureSequenceIndex] = asset;
          passwordPictureSequenceIndex++;
          if (passwordPictureSequenceIndex == 2) {
            passwordPictureSequenceIndex = 0;
            if (passwordPictureSequence[0] == picOne &&
                passwordPictureSequence[1] == picTwo) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigationChild(childID: childID),
                  ));
            } else {
              setModalState(() {
                errorMessage = 'كلمة السر خاطئة';
              });
            }
          }
        });
      },
      splashColor: Colors.white,
      child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 191, 189, 189)),
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 235, 235, 235),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 225, 223, 223),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 15))
              ]),
          child: Image.asset(asset)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Image.asset(
              'assets/images/logo3.png',
              //scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("قائمة أطفالك",
                  style: Theme.of(context).textTheme.headline6),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getData(),
                  builder: (_, snapshot) {
                    final reqts = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("حدث خطأ ما ...."),
                      );
                    }
                    if (reqts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'لم تقم بإضافة أطفالك بعد',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
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
                                    errorMessage = '';
                                    return StatefulBuilder(
                                      builder: (context, setState) => Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 5,
                                              width: 300,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
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
                                                ...passwordPictureSequence
                                                    .reversed
                                                    .map((e) => Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                                shape: BoxShape
                                                                    .circle),
                                                        height: 55,
                                                        width: 55,
                                                        margin: const EdgeInsets
                                                            .all(2),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: (e != '')
                                                            ? Image.asset(
                                                                e,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Text('')))
                                                    .toList(),
                                              ],
                                            ),
                                            Text(
                                              errorMessage,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .errorColor),
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
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child:
                                                          PassowordIconButton(
                                                        'assets/images/trees-2.png',
                                                        setState,
                                                        data[
                                                            'passwordPicture1'],
                                                        data[
                                                            'passwordPicture2'],
                                                        data['childID'],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child:
                                                          PassowordIconButton(
                                                        'assets/images/sun.png',
                                                        setState,
                                                        data[
                                                            'passwordPicture1'],
                                                        data[
                                                            'passwordPicture2'],
                                                        data['childID'],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child:
                                                          PassowordIconButton(
                                                        'assets/images/hazelnut.png',
                                                        setState,
                                                        data[
                                                            'passwordPicture1'],
                                                        data[
                                                            'passwordPicture2'],
                                                        data['childID'],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child:
                                                          PassowordIconButton(
                                                        'assets/images/snowflake.png',
                                                        setState,
                                                        data[
                                                            'passwordPicture1'],
                                                        data[
                                                            'passwordPicture2'],
                                                        data['childID'],
                                                      ),
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
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child:
                                                            PassowordIconButton(
                                                          'assets/images/yellow-flower.png',
                                                          setState,
                                                          data[
                                                              'passwordPicture1'],
                                                          data[
                                                              'passwordPicture2'],
                                                          data['childID'],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child:
                                                          PassowordIconButton(
                                                        'assets/images/mushroom.png',
                                                        setState,
                                                        data[
                                                            'passwordPicture1'],
                                                        data[
                                                            'passwordPicture2'],
                                                        data['childID'],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  context: context);
                            }
                            // data['passwordPicture'] == image url // need update
                            ,
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              color: const Color.fromARGB(255, 254, 245, 206),
                              clipBehavior: Clip.hardEdge,
                              margin: const EdgeInsets.all(20.0),
                              child: Container(
                                width: 600,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        SizedBox(
                                          height: 170,
                                          child: Image.asset(
                                              data["profilePicture"]),
                                        ),
                                        Card(
                                          shadowColor: Colors.grey,
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: SizedBox(
                                              width: 90,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(data['points']
                                                      .toString()),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 30,
                                                    color: Color.fromRGBO(
                                                        255, 221, 64, 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data["name"],
                                      style: const TextStyle(
                                        fontSize: 25,
                                        color: Color.fromARGB(255, 26, 83, 92),
                                      ),
                                    ),
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
          ],
        ),
      ),
    );
  }

//not used yet - maybe later or delete
  parentPasswordDialog(BuildContext context, Function navigate) {
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
                            // Navigator.pop(context);
                            // Navigator.pop(context);
                            navigate;
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
        .doc(signedInUser.email)
        .get()
        .then((value) => parentPassword = value['password']);
  }
}
