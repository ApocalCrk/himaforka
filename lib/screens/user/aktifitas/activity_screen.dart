import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:himaforka/components/theme.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himaforka/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  var _focusedDay = DateTime.now();
  var _selectedDay = DateTime.now();
  var _calendarFormat = CalendarFormat.week;

  List<ActivityList> listActivity = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getActivities();
  }

  getActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.http(host, '/api/get_activities'), body: {
      "npm": prefs.getString('npm'),
    });
    var data = json.decode(response.body);
    if (data == "NULL") {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        listActivity = (json.decode(response.body) as List).map((activity) => ActivityList.fromJson(activity, activity['nama_event'], activity['tanggal'], activity['bulan'], activity['fullDate'], activity['poin'])).toList();
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
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(31, 133, 133, 133),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onDaySelected: (selectedDay, focusedDay) => setState(() {
                      _focusedDay = focusedDay;
                      _selectedDay = selectedDay;
                    }),
                    headerStyle: HeaderStyle(
                      leftChevronIcon: InkWell(
                        onTap: () => setState(() {
                          _focusedDay = _focusedDay.add(const Duration(days: -7));
                        }),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Color.fromARGB(255, 47, 117, 196),
                        ),
                      ),
                      rightChevronIcon: InkWell(
                        onTap: () => setState(() {
                          _focusedDay = _focusedDay.add(const Duration(days: 7));
                        }),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Color.fromARGB(255, 47, 117, 196),
                        ),
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      weekendTextStyle: TextStyle(color: Colors.red),
                      holidayTextStyle: TextStyle(color: Colors.red),
                      todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 47, 117, 196),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 47, 117, 196),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // create list of events
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(31, 133, 133, 133),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Aktivitas",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),  
                                fontSize: 18,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              getmonth(_focusedDay.month),
                              style: TextStyle(
                                color: Color.fromARGB(122, 50, 93, 143),
                                fontSize: 15,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: listActivity.length,
                        itemBuilder: (context, index) {
                          // check if the event is in the selected month
                          if(listActivity[index].bulan != _focusedDay.month.toString()){
                            return Container();
                          }else{
                          return Container(
                            margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(113, 25, 119, 111),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(31, 124, 124, 124),
                                        blurRadius: 10,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '+${listActivity[index].poin}',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${listActivity[index].namaEvent}',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${listActivity[index].fullDate}',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 13,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                          }
                        },
                        padding: const EdgeInsets.only(bottom: 10),
                      )
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

class ActivityList{
  final String namaEvent;
  final String tanggal;
  final String bulan;
  final String fullDate;
  final int poin;

  ActivityList ({
    required this.namaEvent,
    required this.tanggal,
    required this.bulan,
    required this.fullDate,
    required this.poin
  });

  ActivityList.fromJson(data, this.namaEvent, this.tanggal, this.bulan, this.fullDate, this.poin);
}