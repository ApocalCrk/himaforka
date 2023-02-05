import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himaforka/screens/user/home/home_screen.dart';
import 'package:himaforka/constants.dart';
import 'package:http/http.dart' as http;


class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {

  // ignore: non_constant_identifier_names
  String data_link = "";

  void scanQrCode() {
    FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.QR).then((value) {
      setState(() {
        data_link = value;
        sendData(data_link);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    scanQrCode();
  }

  sendData(String link) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var split = link.split("/");
    if(split[0] == "http:" || split[0] == "https:" && split[2] == host){
      final response = await http.post(Uri.parse(link), body: {
        "npm": preferences.getString("npm").toString(),
        "nama": preferences.getString("nama").toString(),
        "email": preferences.getString("email").toString(),
      });
      // ignore: non_constant_identifier_names
      var data_output = json.decode(response.body);
      if(data_output == "success"){
        Fluttertoast.showToast(
            msg: "Berhasil Melakukan Absensi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
        );
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if(data_output == "already exist"){
        Fluttertoast.showToast(
            msg: "Sudah Melakukan Absensi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0
        );
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }else if(data_output == "time not match"){
        Fluttertoast.showToast(
            msg: "Gagal Melakukan Absensi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        Fluttertoast.showToast(
            msg: "Gagal Melakukan Absensi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }else{
      Fluttertoast.showToast(
          msg: "QR Code Salah",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage("assets/images/logo.gif"),
              width: 600,
              height: 600,
            ),
          ],
        ),
      ),
    );
  }
}
