
import 'package:flutter/material.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:himaforka/screens/user/home/home_screen.dart';
import 'package:himaforka/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HimarewardsScreen extends StatefulWidget {
  const HimarewardsScreen({Key? key}) : super(key: key);

  @override
  _HimarewardsScreenState createState() => _HimarewardsScreenState();
}

class _HimarewardsScreenState extends State<HimarewardsScreen> {
  @override
  void initState() {
    super.initState();
    getAllData();
    getMyData();
  }

  int check = 0;
  int search = 0;
  int point = 0;
  bool isLoading = true;

  List<LeaderboardList> allDataRewards = [];
  List<LeaderboardList> searchList = [];
  List<LeaderboardList> dataRewards = [];

  getMyData() async {
    var response = await http.get(Uri.parse('https://rewards.himaforka-uajy.org/api/v1/himarewards'));
    dataRewards = (json.decode(response.body) as List).map((dataRe) => LeaderboardList.fromJson(dataRe, dataRe['peringkat'], dataRe['nama'], dataRe['poin']['total_poin'], dataRe['npm'])).toList();
    for (var i = 0; i < dataRewards.length; i++) {
      if (dataRewards[i].npm == data['npm']) {
        setState(() {
          check = 1;
          point = dataRewards[i].score!;
        });
      }
    }

  }

  getAllData() async {
    var response = await http.get(Uri.parse('https://rewards.himaforka-uajy.org/api/v1/himarewards'));
    setState(() {
      isLoading = false;
      allDataRewards = (json.decode(response.body) as List).map((dataRe) => LeaderboardList.fromJson(dataRe, dataRe['peringkat'], dataRe['nama'], dataRe['poin']['total_poin'], dataRe['npm'])).toList();
    });
  }

  void filterAllData(String query) {
    List<LeaderboardList> dummySearchList = [];
    dummySearchList.addAll(allDataRewards);
    if(query.isNotEmpty) {
      List<LeaderboardList> dummyListData = [];
      for (var item in dummySearchList) {
        if(item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        search = 1;
        searchList.clear();
        searchList.addAll(dummyListData);
      });
      if(searchList.isEmpty){
        setState(() {
          search = 2;
        });
      }
    } else {
      setState(() {
        search = 0;
        searchList.clear();
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
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'HIMAPOIN',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      const Image(
                                        image: AssetImage(
                                            'assets/images/himarewards.png'),
                                        width: 30,
                                        height: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        check == 0 ? "0" : point.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ]
                                  ),
                                ],
                              ),
                            ),
                            (check == 0) ? 
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                "Anda belum terdaftar dalam HIMARewards."
                                , 
                                style: TextStyle(
                                  color: Color.fromRGBO(209, 52, 52, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ) : Container(),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: const Text(
                                "HIMARewards merupakan program kerja dari Himaforka UAJY yang bertujuan untuk menghitung jumlah poin yang dikumpulkan oleh mahasiswa informatika yang aktif dan ikut berpartisipasi dalam kegiatan yang di adakan oleh Himaforka."
                                , 
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
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
                            filterAllData(value);
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

                (search == 0) ?
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allDataRewards.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        allDataRewards[index].name.truncateTo(18),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                                'assets/images/himarewards.png'),
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${allDataRewards[index].score}',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(0, 0, 0, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ]
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: Text(
                                    'Peringkat ke-${allDataRewards[index].rank}',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
                : (search == 1) ? 
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        searchList[index].name.truncateTo(18),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        children: [
                                          const Image(
                                            image: AssetImage(
                                                'assets/images/himarewards.png'),
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${searchList[index].score}',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(0, 0, 0, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ]
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: Text(
                                    'Peringkat ke-${searchList[index].rank}',
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ]
                            ),
                          ),
                        ]
                      ),
                    );
                  },
                )
                :
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              child:
                                const Center(child: 
                                Text(
                                  'Tidak ada data',
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class LeaderboardList {
  final int rank;
  final String name;
  final int? score;
  final String npm;

  LeaderboardList({
    required this.rank,
    required this.name,
    required this.score,
    required this.npm,
  });
  
  LeaderboardList.fromJson(data, this.rank, this.name, this.score, this.npm);
}