import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:himaforka/components/theme.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himaforka/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AktifitasScreen extends StatefulWidget {
  const AktifitasScreen({Key? key}) : super(key: key);

  @override
  _AktifitasScreenState createState() => _AktifitasScreenState();
}

class _AktifitasScreenState extends State<AktifitasScreen> {

  bool isLoading = true;

  List<AktifitasDay> aktifitasDay = [];
  List<AktifitasLastMonth> aktifitasMonth = [];

  @override
  void initState() {
    super.initState();
    getAktifitasToday();
    getAktifitasLastMonth();
  }


  getAktifitasToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.http(host, '/api_himaforka/get_activities.php', {'cat': 'to'}), body: {
      "npm": prefs.getString('npm'),
    });
    if(response.body != '"NULL"'){
      setState(() {
        aktifitasDay = (json.decode(response.body) as List).map((dataRe) => AktifitasDay.fromJson(dataRe, dataRe['nama_event'], dataRe['fullDate'])).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getAktifitasLastMonth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.http(host, '/api_himaforka/get_activities.php', {'cat': 'month'}), body: {
      "npm": prefs.getString('npm'),
    });
    if(response.body != '"NULL"'){
      setState(() {
        aktifitasMonth = (json.decode(response.body) as List).map((dataRe) => AktifitasLastMonth.fromJson(dataRe, dataRe['nama_event'], dataRe['fullDate'])).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: 
    isLoading ? 
      Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // pulse image
              Image(
                image: AssetImage("assets/images/logo.gif"),
                width: 600,
                height: 600,
              ),
            ],
          ),
        ),
      )
       :
    Scaffold(
          backgroundColor: const Color.fromRGBO(248, 250, 254, 1),
          appBar: appBar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              'Bulan Ini',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(62, 158, 158, 158).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: 
                      (aktifitasDay.length == 0) ?
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: Center(
                          child: Text(
                            'Tidak ada aktifitas bulan lalu',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ) :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: aktifitasDay.length,
                        itemBuilder: (context, index) {
                          return Container(
                          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(62, 158, 158, 158).withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    color: Color.fromARGB(255, 67, 88, 94),
                                    size: 30,
                                  )
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      aktifitasDay[index].name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Text(
                                      aktifitasDay[index].time,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        }
                      )
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20,),
                            child: Text(
                              'Bulan Lalu',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(62, 158, 158, 158).withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: (aktifitasMonth.length == 0) ? 
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: Center(
                          child: Text(
                            'Tidak ada aktifitas bulan lalu',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ) :
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: aktifitasMonth.length,
                        itemBuilder: (context, index) {
                          return Container(
                          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(62, 158, 158, 158).withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    color: Color.fromARGB(255, 67, 88, 94),
                                    size: 30,
                                  )
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Membuat QR Code',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Text(
                                      '12:00',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                        }
                      )
                      )
                    ],
                  ),
                
                ],
            ),
          ),
        ),
    );
  }
}

class AktifitasDay {
  final String name;
  final String time;

  AktifitasDay({
    required this.name,
    required this.time,
  });

  AktifitasDay.fromJson(data, this.name, this.time);
}

class AktifitasLastMonth {
  final String name;
  final String time;

  AktifitasLastMonth({
    required this.name,
    required this.time,
  });

  AktifitasLastMonth.fromJson(data, this.name, this.time);
}