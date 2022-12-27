import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tamakan/View/widgets/childPoints.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import '../Model/couponType.dart';

class ExhcangePoints extends StatefulWidget {
  const ExhcangePoints({super.key, required this.childID});

  final String childID;

  @override
  State<ExhcangePoints> createState() => _ExhcangePointsState();
}

class _ExhcangePointsState extends State<ExhcangePoints> {
  var readingChildData = true;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  late List<CouponType> coupons = List<CouponType>.empty(growable: true);
  var readingCouponsData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    readChildData(widget.childID);
    getCoupons();
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
            IconButton(
              icon: Icon(Icons.logout),
              //need update
              onPressed: (() => print('log out')),
            ),
          ],
          backgroundColor: Color(0xffFF6B6B),
        ),
        body: readingChildData || readingCouponsData
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'قائمة الكوبونات',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        ChildPoints(child: child),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                        itemCount: coupons.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                title: Text(coupons[index].name),
                                subtitle: Text(coupons[index].descripton),
                                leading:
                                    Image.network(coupons[index].pictureURL),
                                trailing: TextButton(
                                    onPressed: () {
                                      print('here');
                                    },
                                    child: Text('استبدال')),
                              ),
                            ),
                          );
                        },
                      ),
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
        .doc(signedInUser.email)
        .collection('children')
        .where('childID', isEqualTo: childID)
        .get()
        .then((value) {
      for (var element in value.docs) {
        child = Child.fromJson(element.data());
        setState(() {
          readingChildData = false;
        });
      }
    });
  }

  Future<void> getCoupons() async {
    await FirebaseFirestore.instance
        .collection('couponType')
        .get()
        .then((value) {
      for (var element in value.docs) {
        CouponType c = CouponType.fromJson(element.data());
        coupons.add(c);
      }
      setState(() {
        readingCouponsData = false;
      });
    });
  }
}
