import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tamakan/View/child_profile.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import 'add_child.dart';

class ManageFamily extends StatefulWidget {
  const ManageFamily({super.key});

  @override
  State<ManageFamily> createState() => _ManageFamily();
}

class _ManageFamily extends State<ManageFamily> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  var waiting = true;
  late int childrenCount;

  Future getData() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email)
        .collection('children')
        .get();
    setState(() {
      childrenCount = qn.docs.length;
      waiting = false;
    });
    return qn.docs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Image.asset(
              'assets/images/droppedlogo.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Theme.of(context).textTheme.headline6
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'قائمة أطفالك',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.80,
                child: FutureBuilder(
                    future: getData(),
                    builder: (_, snapshot) {
                      // final reqts = snapshot.data!;
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(
                          
                      //     child: const CircularProgressIndicator(),
                      //   );
                      // }
                      // if (snapshot.hasError) {
                      //   return Center(
                      //     child: const Text("حدث خطأ ما ...."),
                      //   );
                      // }
                      // if (reqts.isEmpty) {
                      //   return Center(
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: const [
                      //         Text(
                      //           'لم تقم بإضافة أطفالك بعد',
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, int index) {
                          DocumentSnapshot data = snapshot.data[index];

                          return Center(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChildProfile(
                                    childID: data["childID"], //update this
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
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
                                              color: Color.fromARGB(
                                                  255, 26, 83, 92))),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                          "  \n عدد النقاط: " +
                                              data["points"].toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Color.fromARGB(
                                                  255, 26, 83, 92))),
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
        floatingActionButton: waiting
            ? FloatingActionButton(onPressed: null)
            : FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  // if (childrenCount < 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddChild(),
                    ),
                  );
                  // } else {
                  //   showCusomDialog();
                  // }
                }),
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

  void showCusomDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'عذرا, لا يمكنك إضافة أكثر من أربعة أطفال',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 200,
                    child: Center(child: Text('حسنا')),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
