import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/View/welcomeView.dart';

bool _value = false;

class deleteAccount extends StatefulWidget {
  const deleteAccount({super.key});

  @override
  State<deleteAccount> createState() => _deleteAccountState();
}

class _deleteAccountState extends State<deleteAccount> {
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
              ],
              backgroundColor: Color(0xffFF6B6B),
            ),
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                constraints: BoxConstraints.expand(),
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //       image: AssetImage("./images/^^.png"),
                //       fit: BoxFit.cover),
                // ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      ' حذف حسابي',
                      style: TextStyle(
                          fontSize: 35,
                          color: Color.fromARGB(255, 71, 81, 80),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image(
                              height: 100,
                              image: AssetImage('assets/images/sadFace.png'),
                            ),

                            SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'تحرننا مغادرتك!',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 59, 62, 62),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            const Text(
                              'أذا قمت بحذف حسابك , سوف تحذف من قاعدة البيانات الأساسية لدينا جميع معلوماتك الشخصية بما فيها',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 59, 62, 62),
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.person_outlined,
                                  size: 23,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'تفقد معلوماتك الشخصية',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 59, 62, 62),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 23,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'تفقد معلومات أطفالك ايضا ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 59, 62, 62),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.card_giftcard,
                                  size: 23,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'تفقد قسائم أطفالك المتاحة هنا',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 59, 62, 62),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                            ////////////////check the result
                            CheckboxListTile(
                              activeColor: Color(0xffFF6B6B),
                              title: Text(
                                'أنا أوافق على عملية الحذف',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 59, 62, 62),
                                ),
                              ),
                              value: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            ///cancel button
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 190, left: 190),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(30),
                                color: Color.fromRGBO(255, 230, 109, 1),
                                child: MaterialButton(
                                  padding:
                                      EdgeInsets.fromLTRB(110, 10, 110, 10),
                                  minWidth: MediaQuery.of(context).size.width,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/ParentProfile');
                                  },
                                  child: Text(
                                    "إلغاء",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 71, 81, 80),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            ///delete button
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.fromLTRB(110, 10, 110, 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  primary: Color(0xffFF6B6B),
                                ),
                                onPressed: _value == true
                                    ? () {
                                        AuthController().deleteUser(FirebaseAuth
                                            .instance.currentUser!.email
                                            .toString());
                                        print("user id: ");
                                        print(FirebaseAuth
                                            .instance.currentUser!.uid);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    welcomeView()));
                                      }
                                    : null,
                                child: Text(" حذف الحساب",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 71, 81, 80),
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
