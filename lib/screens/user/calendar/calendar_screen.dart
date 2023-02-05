import 'package:flutter/material.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:himaforka/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var _focusedDay = DateTime.now();
  var _selectedDay = DateTime.now();
  var _calendarFormat = CalendarFormat.week;


  var isLoading = false;

  List<KalenderAkademik> listKalenderAkademik = [];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    setState(() {
      isLoading = true;
    });
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('kalender')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var tanggalMulai = doc['tanggal_mulai'].split('-');
        var tanggalSelesai = doc['tanggal_selesai'].split('-');
        
        listKalenderAkademik.add(KalenderAkademik(
            tanggal_mulai: tanggalMulai[0],
            bulan_mulai: checkMonth(tanggalMulai[1]),
            tahun_mulai: tanggalMulai[2],
            tanggal_selesai: tanggalSelesai[0],
            bulan_selesai: checkMonth(tanggalSelesai[1]),
            tahun_selesai: tanggalSelesai[2],
            nama_kegiatan: doc['nama_kegiatan'],
            detail_kegiatan: doc['detail_kegiatan'],
            )
          );
      }
    });
    setState(() {
      isLoading = false;
    });
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
                    // turn off slide
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
                            const Text(
                              "Kalender Akademik",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),  
                                fontSize: 18,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              getmonth(_focusedDay.month),
                              style: const TextStyle(
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
                        itemCount: listKalenderAkademik.length,
                        itemBuilder: (context, index) {
                          // check if the event is in the selected month
                          if(listKalenderAkademik[index].bulan_mulai != _focusedDay.month.toString()){
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
                                    color: Color.fromARGB(255, 47, 117, 196),
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
                                        listKalenderAkademik[index].tanggal_mulai,
                                        style: const TextStyle(
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
                                        listKalenderAkademik[index].nama_kegiatan,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        listKalenderAkademik[index].detail_kegiatan == null ? 'Tidak Ada Keterangan' : '${listKalenderAkademik[index].detail_kegiatan}',
                                        style: const TextStyle(
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

class KalenderAkademik {
  // ignore: non_constant_identifier_names
  final String tanggal_mulai;
  // ignore: non_constant_identifier_names
  final String bulan_mulai;
  // ignore: non_constant_identifier_names
  final String tahun_mulai;
  // ignore: non_constant_identifier_names
  final String? tanggal_selesai;
  // ignore: non_constant_identifier_names
  final String? bulan_selesai;
  // ignore: non_constant_identifier_names
  final String? tahun_selesai;
  // ignore: non_constant_identifier_names
  final String nama_kegiatan;
  // ignore: non_constant_identifier_names
  final String? detail_kegiatan;

  KalenderAkademik({
    // ignore: non_constant_identifier_names
    required this.tanggal_mulai,
    // ignore: non_constant_identifier_names
    required this.bulan_mulai,
    // ignore: non_constant_identifier_names
    required this.tahun_mulai,
    // ignore: non_constant_identifier_names
    required this.tanggal_selesai,
    // ignore: non_constant_identifier_names
    required this.bulan_selesai,
    // ignore: non_constant_identifier_names
    required this.tahun_selesai,
    // ignore: non_constant_identifier_names
    required this.nama_kegiatan,
    // ignore: non_constant_identifier_names
    required this.detail_kegiatan,
  });

  KalenderAkademik.fromJson(data, this.tanggal_mulai, this.bulan_mulai, this.tahun_mulai, this.tanggal_selesai, this.bulan_selesai, this.tahun_selesai, this.nama_kegiatan, this.detail_kegiatan);
}