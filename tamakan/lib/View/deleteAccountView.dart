import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamakan/Controller/authController.dart';
import 'package:tamakan/View/registerationView.dart';
import 'package:lottie/lottie.dart';
import 'package:tamakan/View/widgets/button_widget.dart';

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
                //constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        ' حذف حسابي',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          //height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    color: Colors.grey[300]!)
                              ]),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              // Lottie.network(
                              //     "https://assets3.lottiefiles.com/packages/lf20_WdbegN.json",
                              //     animate: true),
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
                                height: 20,
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
                                height: 10,
                              ),

                              ///cancel button
                              ButtonWidget(
                                fun: () => Navigator.pop(context),
                                // {
                                //   Navigator.pushNamed(
                                //       context, '/parentprofileview')
                                // },
                                buttonLabel: 'إلغاء',
                                buttonColor: Color(0xff4ECDC4),
                              ),

                              ///delete button
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xffFF6B6B)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: _value == true
                                        ? () {
                                            AuthController().deleteUser(
                                                FirebaseAuth
                                                    .instance.currentUser!.email
                                                    .toString());
                                            print("user id: ");
                                            print(FirebaseAuth
                                                .instance.currentUser!.uid);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        registerationview()));
                                          }
                                        : null,
                                    child: Container(
                                      padding: EdgeInsets.all(7),
                                      child: Center(
                                          child: Text(
                                        "حذف الحساب",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        //style: TextStyle(color: Color.fromARGB(255, 71, 81, 80)),
                                      )),
                                      width: double.infinity,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
