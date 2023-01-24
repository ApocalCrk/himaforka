import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:himaforka/screens/auth/login_screen.dart';
import 'package:himaforka/screens/user/akun/aktifitas/aktifitas_screen.dart';
import 'package:himaforka/components/theme.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:himaforka/screens/user/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himaforka/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';


class Akun extends StatefulWidget {
  const Akun({
    Key? key,
  }) : super(key: key);

  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
    CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: 
    Scaffold(
          backgroundColor: const Color.fromRGBO(248, 250, 254, 1),
          appBar: appBar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      margin: const EdgeInsets.only(
                          top: 50.0, left: 20.0, right: 20.0, bottom: 30.0
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(117, 9, 50, 112),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          data['nama'][0].toString().toUpperCase(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    Flexible(child:
                    Container(
                      margin: const EdgeInsets.only(
                          top: 30.0
                      ),
                      child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['nama'],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            getProdi(data['npm']),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    ),
                  ]
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text(
                        'Pengaturan & Aktifitas',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(175, 119, 119, 119),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(26, 0, 0, 0),
                            offset: Offset(0, 4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: const AktifitasScreen()));
                        },
                        child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0, top: 20.0, bottom: 20.0
                            ),
                            width: 45.0,
                            height: 45.0,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 73, 123, 199),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(26, 0, 0, 0),
                                  offset: Offset(0, 4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.library_books_outlined,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 25,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0
                            ),
                            child: const Text(
                              'Aktifitas Terbaru',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0, top: 20.0, bottom: 20.0
                            ),
                            width: 45.0,
                            height: 45.0,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 73, 153, 199),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(26, 0, 0, 0),
                                  offset: Offset(0, 4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 25,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0
                            ),
                            child: const Text(
                              'Pengaturan',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.remove("npm");
                          pref.remove("nama");
                          pref.remove("email");
                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0, top: 20.0, bottom: 20.0
                            ),
                            width: 45.0,
                            height: 45.0,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 199, 73, 73),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(26, 0, 0, 0),
                                  offset: Offset(0, 4),
                                  blurRadius: 16,
                                ),
                              ], 
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 25,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0
                            ),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      )
                    ],
                  ),
                ),
                ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text(
                        'Fitur Lainnya',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromARGB(175, 119, 119, 119),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ),
                
              ],
            ),
          ),
        ),
    );    
  }
}