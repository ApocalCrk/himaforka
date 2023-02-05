import 'package:flutter/material.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:himaforka/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  bool isLoading = true;
  bool search = false;

  List<ListEvent> listEvent = [];
  List<ListEvent> searchEvent = [];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var splitTanggalEvent = element['tanggal_event'].split('-');
        var splitTanggalPendaftaran = element['pendaftaran'].split('-');
        ListEvent data = ListEvent(
          nama_event: element['nama_event'],
          detail_event: element['detail_event'],
          lokasi_event: element['lokasi_event'],
          tanggal_event: splitTanggalEvent[0] + ' ' + getmonth(int.parse(checkMonth(splitTanggalEvent[1]))) + ' ' + splitTanggalEvent[2],
          pendaftaran: splitTanggalPendaftaran[0] + ' ' + getmonth(int.parse(checkMonth(splitTanggalEvent[1]))) + ' ' + splitTanggalPendaftaran[2],
          pendaftaran_akhir: element['pendaftaran_akhir'],
          gambar_event: element['gambar_event']
        );
        listEvent.add(data);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void searchData(String query) {
    List<ListEvent> dummySearchList = [];
    dummySearchList.addAll(listEvent);
    if (query.isNotEmpty) {
      List<ListEvent> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.nama_event.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        search = true;
        searchEvent.clear();
        searchEvent.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
        searchEvent.clear();
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
                const Text(
                  "Event",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 24,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Cari",
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300),
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.only(left: 20, top: 16, bottom: 16),
                          ),
                          onChanged: (value) {
                            searchData(value);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 47, 117, 196),
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                (search == false) ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listEvent.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: defaultPadding,
                          right: defaultPadding,
                          top: defaultPadding,
                          bottom: 10),
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color.fromARGB(40, 83, 83, 83),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listEvent[index].nama_event,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  listEvent[index].detail_event,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                      textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.today,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      listEvent[index].tanggal_event,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.edit_calendar,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      listEvent[index].pendaftaran,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      listEvent[index].lokasi_event,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                    );
                  },
                )
                :
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchEvent.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: defaultPadding,
                          right: defaultPadding,
                          top: defaultPadding,
                          bottom: 10),
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color.fromARGB(40, 83, 83, 83),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchEvent[index].nama_event,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  searchEvent[index].detail_event,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                      textAlign: TextAlign.justify,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.today,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      searchEvent[index].tanggal_event,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.edit_calendar,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      searchEvent[index].pendaftaran,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      searchEvent[index].lokasi_event,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  ]
                                ),
                              ]
                            )
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            height: 100,
                          ),
                        ]
                      )
                    );
                  }
                )
              ],
            ),
          ),
      ),
    );
  }
}

class ListEvent {
  // ignore: non_constant_identifier_names
  final String nama_event;
  // ignore: non_constant_identifier_names
  final String detail_event;
  // ignore: non_constant_identifier_names
  final String lokasi_event;
  // ignore: non_constant_identifier_names
  final String tanggal_event;
  // ignore: non_constant_identifier_names
  final String pendaftaran;
  // ignore: non_constant_identifier_names
  final String? pendaftaran_akhir;
  // ignore: non_constant_identifier_names
  final String? gambar_event;

  ListEvent(
      // ignore: non_constant_identifier_names
      {required this.nama_event,
      // ignore: non_constant_identifier_names
      required this.detail_event,
      // ignore: non_constant_identifier_names
      required this.lokasi_event,
      // ignore: non_constant_identifier_names
      required this.tanggal_event,
      // ignore: non_constant_identifier_names
      required this.pendaftaran,
      // ignore: non_constant_identifier_names
      required this.pendaftaran_akhir,
      // ignore: non_constant_identifier_names
      required this.gambar_event});

    ListEvent.fromJson(data, this.nama_event, this.detail_event, this.lokasi_event, this.tanggal_event, this.pendaftaran, this.pendaftaran_akhir, this.gambar_event);
}