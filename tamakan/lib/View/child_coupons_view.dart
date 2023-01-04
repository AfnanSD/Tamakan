import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import '../Model/coupon.dart';

class ChildCouponsVIew extends StatefulWidget {
  const ChildCouponsVIew({super.key, required this.childID});
  final String childID;

  @override
  State<ChildCouponsVIew> createState() => _ChildCouponsVIewState();
}

class _ChildCouponsVIewState extends State<ChildCouponsVIew> {
  var readingChildData = true;
  var readingCouponsData = true;
  late Child child;

  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  late List<Coupon> coupons = List<Coupon>.empty(growable: true);

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
        body: SingleChildScrollView(
          child: readingChildData || readingCouponsData
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'قسائم ${child.name}',
                          style: TextStyle(fontSize: 30),
                        ),
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
                                  subtitle: Text(
                                      'تاريخ الانتهاء: ${DateFormat.yMd().format(coupons[index].endDate)}\n رقم الكوبون: ${coupons[index].couponID}'),
                                  leading:
                                      Image.network(coupons[index].pictureURL),
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
      ),
    );
  }

  Future<void> getCoupons() async {
    await FirebaseFirestore.instance.collection('coupon').get().then((value) {
      for (var element in value.docs) {
        Coupon c = Coupon.fromJson(element.data());
        if (c.childID == widget.childID) coupons.add(c);
      }
      setState(() {
        readingCouponsData = false;
      });
    });
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
          readingChildData = false;
        });
      }
    });
  }
}