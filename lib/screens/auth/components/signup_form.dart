import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:himaforka/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:himaforka/components/auth/already_have_an_account_acheck.dart';
import 'package:himaforka/screens/auth/login_screen.dart';

import 'package:himaforka/encryption/en_de.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formkey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final TextEditingController npm = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  void dispose() {
    npm.dispose();
    password.dispose();
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: 
      Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (nama) {},
            controller: name,
            decoration: const InputDecoration(
              hintText: "Nama Lengkap",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) => value!.isEmpty ? "Nama tidak boleh kosong" : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (npm) {},
              controller: npm,
              decoration: const InputDecoration(
                hintText: "NPM",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.timelapse),
                ),
              ),
              validator: (value) => value!.isEmpty ? "NPM tidak boleh kosong" : null,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            controller: email,
            decoration: const InputDecoration(
              hintText: "Email UAJY",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
            validator: (value) => value!.isValidEmail() ? null : "Email tidak valid",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: _secureText,
              onSaved: (password) {},
              controller: password,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              validator: (value) => value!.isEmpty ? "Password tidak boleh kosong" : null,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              if(_formkey.currentState!.validate()) {
                users.where('npm', isEqualTo: npm.text).get().then((value) {
                  if(value.docs.isEmpty) {
                    users.add({
                      'name': name.text,
                      'npm': npm.text,
                      'email': email.text,
                      'password': EncrypDecryp.encrypt(password.text),
                      'status': 'active',
                      'created_at': DateTime.now().toString(),
                      'updated_at': DateTime.now().toString(),
                    }).then((value) {
                      Fluttertoast.showToast(
                        msg: "Berhasil mendaftar",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
                    }).catchError((error) {
                      Fluttertoast.showToast(
                        msg: "Gagal mendaftar",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: "NPM sudah terdaftar",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  }
                }).catchError((error) {
                  Fluttertoast.showToast(
                    msg: "Gagal mendaftar",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                  );
                });
              }else{
                Fluttertoast.showToast(
                  msg: "Gagal mendaftar",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
                );
              }
            },
            child: Text("Daftar".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}