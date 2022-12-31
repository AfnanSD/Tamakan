import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tamakan/Model/coupon.dart';
import 'package:tamakan/View/widgets/child_points.dart';
import 'dart:ui' as ui;

import '../Model/child.dart';
import '../Model/couponType.dart';
import 'manage_family.dart';

class ExhcangePoints extends StatefulWidget {
  const ExhcangePoints({super.key, required this.childID});

  final String childID;

  @override
  State<ExhcangePoints> createState() => _ExhcangePointsState();
}

//check dates? start and end
//check available?

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
                              'قائمة القسائم',
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
                                subtitle: Text(
                                    'استبدل ${coupons[index].points} نقطة \n${coupons[index].description}'),
                                leading:
                                    Image.network(coupons[index].pictureURL),
                                trailing: TextButton(
                                    onPressed: () {
                                      if (child.points >=
                                          coupons[index].points) {
                                        showConfirmationDialog(
                                          coupons[index].name,
                                          coupons[index].amount,
                                          coupons[index].points,
                                        );
                                      } else {
                                        showNotEnoughPointsDialof(
                                            coupons[index].points);
                                      }
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
        .where('childID', isEqualTo: childID) //why not doc(child.childID)?
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
        //check for amount
        if (c.startDate.isBefore(DateTime.now()) &&
            c.endDate.isAfter(DateTime.now()) &&
            c.amount > 0) coupons.add(c);
      }
      setState(() {
        readingCouponsData = false;
      });
    });
  }

  void exchangeCoupon(String couponName, int amount, int points) {
    FirebaseFirestore.instance
        .collection('couponType')
        .doc(couponName)
        .update({'amount': (--amount)});
    FirebaseFirestore.instance
        .collection('parent')
        .doc(signedInUser.email)
        .collection('children')
        .doc(child.childID)
        .update({'points': child.points - points});
    FirebaseFirestore.instance
        .collection('coupon')
        .where('name', isEqualTo: couponName)
        .get()
        .then(
      (value) {
        print(value.docs.length);
        var found = false;
        for (var element in value.docs) {
          Coupon coupon =
              Coupon.fromJson(element.data()); //here is the copounID
          if (coupon.childID.isEmpty) {
            FirebaseFirestore.instance
                .collection('coupon')
                .doc(coupon.couponID)
                .update({'childID': child.childID});
            found = true;
          }
          if (found) break;
        }
      },
    );
  }

  void showConfirmationDialog(String name, int amount, int couponPoints) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: Text(
                      'هل أنت متأكد من استبدال كوبون ${name} بـ ${couponPoints} ؟',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xffFF6B6B)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        exchangeCoupon(name, amount, couponPoints);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageFamily(),
                          ),
                        );
                      },
                      child: Container(
                        child: Center(child: Text('تأكيد')),
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void showNotEnoughPointsDialof(int points) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: Text(
                      'عدد نقاط طفلك أقل من ${points}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xffFF6B6B)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Center(child: Text('حسنا')),
                        width: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
