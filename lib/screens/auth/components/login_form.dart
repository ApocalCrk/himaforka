import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:himaforka/screens/dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himaforka/constants.dart';
import 'package:himaforka/screens/auth/login_controller.dart';

import 'package:himaforka/screens/user/home/home_screen.dart';

import 'package:himaforka/components/auth/already_have_an_account_acheck.dart';
import 'package:himaforka/screens/auth/signup_screen.dart';

import 'package:himaforka/encryption/en_de.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formkey = GlobalKey<FormState>();
  final TextEditingController npm = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _secureText = true;
  // ignore: prefer_typing_uninitialized_variables
  var value;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  savePref(String npm, String name, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("npm", npm);
      preferences.setString("nama", name);
      preferences.setString("email", email);
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("npm");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  void dispose() {
    npm.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: npm,
            onSaved: (e) => npm.text = e!,
            decoration: const InputDecoration(
              hintText: "NPM",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) => value!.isEmpty ? "NPM tidak boleh kosong" : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: _secureText,
              cursorColor: kPrimaryColor,
              controller: password,
              onSaved: (e) => password.text = e!,
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
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  Map<String, dynamic> resultLogin = await LoginController().login(npm.text, password.text);
                  if(resultLogin['status'] == true){
                    savePref(resultLogin['npm'], resultLogin['nama'], resultLogin['email']);
                    Fluttertoast.showToast(
                      msg: "Login Berhasil",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: const Dashboard()));
                  }else{
                    Fluttertoast.showToast(
                      msg: "Login Gagal",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  }
                }
              },
              child: Text(
                "Masuk".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // AlreadyHaveAnAccountCheck(
          //   press: () {
          //     Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: const SignUpScreen()));
          //   },
          // ),
        ],
      ),
    );
  }
}
