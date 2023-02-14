import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:tamakan/View/child_profile.dart';
import 'package:tamakan/View/parentProfileView.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import 'add_child.dart';
import 'myChildren.dart';

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
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Image.asset(
              'assets/images/logo3.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: const Color(0xffFF6B6B),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Theme.of(context).textTheme.headline6
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'إدارة عائلتي',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: FutureBuilder(
                    future: getData(),
                    builder: (_, snapshot) {
                      final reqts = snapshot.data;
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return Center(
                      //     child: CircularProgressIndicator(),
                      //   );
                      // }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("حدث خطأ ما ...."),
                        );
                      }
                      if (snapshot.hasData) {
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
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChildProfile(
                                      childID: data["childID"],
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
                                  color:
                                      const Color.fromARGB(255, 254, 245, 206),
                                  clipBehavior: Clip.hardEdge,
                                  margin: const EdgeInsets.all(20.0),
                                  child: Container(
                                    width: 600,
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
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
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: SizedBox(
                                                    width: 90,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(data['points']
                                                            .toString()),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Icon(
                                                            Icons.star_rounded,
                                                            size: 30,
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    221,
                                                                    64,
                                                                    1)),
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
                                              color: Color.fromARGB(
                                                  255, 26, 83, 92),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text(""));
                      }
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: waiting
            ? const FloatingActionButton(onPressed: null)
            : FloatingActionButton(
                child: const Icon(Icons.add),
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'عذرا, لا يمكنك إضافة أكثر من أربعة أطفال',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 200,
                    child: const Center(child: Text('حسنا')),
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
