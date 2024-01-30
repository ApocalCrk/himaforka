import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:himaforka/screens/user/leaderboard/leaderboard_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/theme.dart';
import 'package:himaforka/screens/auth/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:himaforka/constants.dart';

getStatus() async {
  var response = await http.post(Uri.http(host, "/api_himaforka/check.php"));
  var data = json.decode(response.body);
  if(data == "online"){
    return Fluttertoast.showToast(
        msg: "Website Kuliah Sedang Online",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
    );
  }else{
    return Fluttertoast.showToast(
        msg: "Website Kuliah Sedang Offline",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }
}

AppBar appBar(context) {
  return AppBar(
    iconTheme: const IconThemeData(color: colorAccent),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text(
      "HIMAFORKA",
      style: TextStyle(
        color: colorAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          getStatus();
        },
        icon: const Icon(
          Icons.web_asset_off,
        )
      ),
      IconButton(
        onPressed: () {
          Navigator.push(context, PageTransition(child: const Leaderboard(), type: PageTransitionType.fade));
        },
        icon: const Icon(
          Icons.leaderboard_outlined,
        )
      ),
      IconButton(
        onPressed: () async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.remove("npm");
          pref.remove("nama");
          pref.remove("email");
          Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        icon: const Icon(
          Icons.logout_outlined,
        )
      )
    ],
  );
}
