import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:himaforka/screens/user/aktifitas/activity_screen.dart';
import 'package:himaforka/screens/user/calendar/calendar_screen.dart';
import 'package:himaforka/screens/user/event/event_screen.dart';
import 'package:himaforka/screens/user/leaderboard/himarewards_screen.dart';
import 'package:himaforka/components/appbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:himaforka/screens/user/data/shared.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Map<String, dynamic> data = {
  'nama': '',
  'npm': '',
  'email': '',
};


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    storeData();
  }

  storeData() async {
    String nama = await SharedPref.readPrefStr("nama");
    String npm = await SharedPref.readPrefStr("npm");
    String email = await SharedPref.readPrefStr("email");
    setState(() {
      data['nama'] = nama;
      data['npm'] = npm;
      data['email'] = email;
    });
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
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      children: const [
                        Text(
                        "Selamat Datang,",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 27,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300),
                        ),
                      ]
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                        data['nama'],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 47, 117, 196),
                            fontSize: 27,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500),
                        ),
                      ]
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
                              //search
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
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30, left: 40),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const CalendarScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(31, 141, 141, 141),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 45),
                                          child: const Image(
                                            image: AssetImage("assets/images/calender.png"),
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: const Text(
                                            "Kalender",
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const EventScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  width: 160,
                                  height: 160,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(31, 141, 141, 141),
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 45),
                                        child: const Image(
                                          image: AssetImage("assets/images/event1.png"),
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: const Text(
                                          "Event",
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, left: 40),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const ActivityScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(31, 141, 141, 141),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 45),
                                          child: const Image(
                                            image: AssetImage("assets/images/activity.png"),
                                            width: 50,
                                            height: 50,
                                          )
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: const Text(
                                            "Aktifitas",
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const HimarewardsScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    width: 160,
                                    height: 160,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(31, 141, 141, 141),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 45),
                                          child: const Image(
                                            image: AssetImage("assets/images/himarewards.png"),
                                            width: 50,
                                            height: 50,
                                          )
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: const Text(
                                            "HimaRewards",
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontSize: 16,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]
                  )
                  
                ],
              ),
            ),
        ),
      );
  }

}