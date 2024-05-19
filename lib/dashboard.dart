import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:cms/repository.dart';
import 'package:cms/database.dart';
import 'package:cms/chatScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cms/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  //fireabase displaying username
  String _userName = ''; //variable to store users name
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    var initializationSettingsAndroid = AndroidInitializationSettings(
        'android/app/src/main/res/mipmap-hdpi/ic_launcher.png');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //method 4 retrieving username using firebase auth
  void _getUserDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? '';
      });
    }
  }

  void _showReminderDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set a Reminder",
              style: GoogleFonts.ptSans(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black))),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                  },
                  child: Text(selectedDate == null
                      ? "Select Date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: Text(selectedTime == null
                      ? "Select Time"
                      : "${selectedTime!.hour}:${selectedTime!.minute}"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    selectedDate != null &&
                    selectedTime != null) {
                  DateTime reminderDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );
                  Reminder reminder = Reminder(
                      title: titleController.text, dateTime: reminderDateTime);
                  _saveReminder(reminder);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Reminder set!',
                        style: GoogleFonts.ptSansNarrow(
                            textStyle:
                                TextStyle(fontSize: 15, color: Colors.black))),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    behavior: SnackBarBehavior.floating,
                  ));
                } else {
                  // Show error message if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill all fields",
                          style: GoogleFonts.ptSansNarrow(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Colors.black))),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _saveReminder(Reminder reminder) async {
    await _databaseHelper.insertReminder(reminder); //i created a reminder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reminder saved"),
      ),
    );
  }

  /*void _scheduleNotification(Reminder reminder) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      reminder.title,
      reminder.dateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: SizedBox(width: 0.0),
        title: Text(
          'Welcome To ContraSave',
          textAlign: TextAlign.left, // not displaying correctly, username
          style: GoogleFonts.bebasNeue(
              textStyle: TextStyle(fontSize: 33, color: Colors.black)),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: Color.fromARGB(255, 223, 39, 39)),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 40,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 164, 32, 32),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          constraints:
                              BoxConstraints(maxWidth: 400, maxHeight: 200),
                          child: Icon(
                            Icons.alarm,
                            color: Color.fromARGB(255, 164, 32, 32),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _showReminderDialog(context);
                                },
                                child: Text(
                                  'Set a Reminder',
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          fontSize: 20, color: Colors.black)),
                                  textAlign: TextAlign.right,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 164, 32, 32),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    constraints: BoxConstraints(
                        maxWidth: 600, maxHeight: 250), // Adjust the maxWidth
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex:
                              2, // Adjust the flex to control the width of the image
                          child: Container(
                            // Add padding if necessary
                            child: Image.asset(
                              'assets/images/repoimage.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                            width:
                                20), // Adjust the width between the image and text
                        Expanded(
                          flex:
                              3, // Adjust the flex to control the width of the text
                          child: Container(
                            padding: EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 164, 32, 32),
                                borderRadius: BorderRadius.circular(10)),
                            constraints:
                                BoxConstraints(maxWidth: 300, maxHeight: 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),

                                Text(
                                  'Contract Status',
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          fontSize: 20, color: Colors.black)),
                                ),
                                // ignore: prefer_const_constructors
                                Align(
                                  alignment: Alignment.centerRight,
                                ),
                                SizedBox(
                                    height:
                                        20), // Adjust the height between texts
                                FutureBuilder<int?>(
                                  future:
                                      _databaseHelper.getTotalContractsCount(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      int totalContracts = snapshot.data ?? 0;
                                      return Text(
                                        'Total Contracts: $totalContracts',
                                        style: GoogleFonts.ptSans(
                                            textStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        )),
                                      );
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    //virtual assistant container
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // Implement virtual assistant UI here
                      padding: EdgeInsets.all(55),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/cb.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter),
                        color: Color.fromARGB(255, 164, 32, 32),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 100),
                                Text('Your Virtual Assistant',
                                    style: GoogleFonts.ptSans(
                                        textStyle: TextStyle(fontSize: 20))),
                                Align(
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 150,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 224, 26, 11)),
                                    onPressed: () {
                                      Get.to(ChatroomScreen());
                                    },
                                    child: Text(
                                      "Ask CB",
                                      style: GoogleFonts.ptSans(
                                          textStyle: TextStyle(fontSize: 15)),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ), // Replace with actual assistant UI
                    ),
                  ),
                ],
              ),
              // ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage('assets/images/1E73BE.png')),
            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(Icons.store),
                    onPressed: () {
                      Get.to(MyRepository());
                    }),
                IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      Get.offAllNamed('/login');
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
