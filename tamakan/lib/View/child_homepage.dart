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
import 'package:tamakan/View/levels.dart';
import 'package:tamakan/View/widgets/TextInputField.dart';
import 'package:tamakan/View/widgets/button_widget.dart';
import 'package:tamakan/View/widgets/child_points.dart';
import 'package:tamakan/View/quranMap.dart';


import '../Model/child.dart';

class ChildHomePage extends StatefulWidget {
  const ChildHomePage({super.key, required this.childID});

  final String childID;

  @override
  State<ChildHomePage> createState() => _ChildHomePageState();
}

class _ChildHomePageState extends State<ChildHomePage> {
  var readingData = true;
  late Child child;
  late String parentPassword;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getCurrentUserData();
    readChildData(widget.childID);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: const Color(0xffFF6B6B),
        ),
        body: readingData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChildPoints(child: child),
                    Image.asset(child.profilePicture),
                    const SizedBox(height: 20),
                    Text(
                      'مرحبا ${child.name} \n متحمس للبدء؟\nهيا لنتعلم معا', //girl or boy!
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Quran_map(),)), // need update
                              child: Card(
                                  child: Container(
                                    height: 150,
                                    width: 250,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/book.png'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'القرآن',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color:
                                      const Color.fromARGB(255, 213, 247, 245)),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        // LearningMap(childId: widget.childID)
                                        levels(
                                      childID: child.childID,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: const Color.fromARGB(255, 252, 200, 200),
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
                                      const Text(
                                        'الدروس\nو التحديات',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChildCouponsVIew(
                                  childID: widget.childID,
                                ),
                              )),
                              child: Card(
                                child: Container(
                                  height: 150,
                                  width: 250,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/coupon.png',
                                        scale: 4.5,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'قسائمي',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                                color: const Color.fromARGB(255, 244, 235, 192),
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  parentPasswordDialog(context), //need update
                              child: Card(
                                  color:
                                      const Color.fromARGB(255, 213, 247, 245),
                                  child: Container(
                                    height: 150,
                                    width: 250,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/hand.png'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'والدي',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
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

  parentPasswordDialog(BuildContext context) {
    final _passwordController = TextEditingController();
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
                    controller: _passwordController,
                    obsecure: true,
                    myLabelText: 'كلمة المرور',
                    myHintText: '********',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_passwordController.text == parentPassword) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          errorMessage = 'كلمة المرور خاطئة';
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(7),
                      child: Center(
                          child: Text(
                        'تأكيد',
                        style: TextStyle(fontSize: 15),
                        //style: TextStyle(color: Color.fromARGB(255, 71, 81, 80)),
                      )),
                      width: 200,
                    ),
                  ),
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
