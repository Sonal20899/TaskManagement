import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../noti.dart';
import 'home_screen.dart';

class DateTimePage extends StatefulWidget {
  final String id;
  const DateTimePage({super.key, required this.id});

  @override
  State<DateTimePage> createState() => _DateTimePageState();
}

TimeOfDay? time = const TimeOfDay(hour: 12, minute: 60);

class _DateTimePageState extends State<DateTimePage> {
  TextEditingController datecontroller1 = TextEditingController();
  TextEditingController datecontroller2 = TextEditingController();
  TextEditingController timecontroller1 = TextEditingController();
  TextEditingController timecontroller2 = TextEditingController();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id.isNotEmpty) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Vivek')
          .doc(widget.id)
          .get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      setState(() {
        title.text = data['Title'] ?? '';
        content.text = data['Description'] ?? '';
        timecontroller1.text = data['StartTime'] ?? '';
        timecontroller2.text = data['EndTime'] ?? '';
        datecontroller1.text = data['start_date'] ?? '';
        datecontroller2.text = data['end_date'] ?? '';
      });
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  Future<void> datepicker1() async {
    DateTime? pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (pick != null) {
      setState(() {
        datecontroller1.text = DateFormat('dd/MM/yyyy').format(pick);
      });
    }
  }

  Future<void> datepicker2() async {
    DateTime? pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (pick != null) {
      setState(() {
        datecontroller2.text = DateFormat('dd/MM/yyyy').format(pick);
      });
    }
  }

  //document id
  List<String> docIds = [];

  Future<void> getDocIds() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Vivek').get();
      setState(() {
        docIds = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching document IDs: $e');
    }
  }

// add data in firestore
  Future addTaskDetails() async {
    try {
      await FirebaseFirestore.instance.collection('Vivek').add({
        'Title': title.text,
        'Description': content.text,
        'StartTime': timecontroller1.text,
        'EndTime': timecontroller2.text,
        'start_date': datecontroller1.text,
        'end_date': datecontroller2.text,
      });

      print(
          'Add ${title.text} ${content.text} ${timecontroller1.text} ${timecontroller2.text} ${datecontroller1.text} ${datecontroller2.text}');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } catch (e) {
      print('Failed to add user: $e');
    }
  }

  //update
  Future<void> updateUserDetail(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Vivek').doc(docId).update({
        'Title': title.text,
        'Description': content.text,
        'StartTime': timecontroller1.text,
        'EndTime': timecontroller2.text,
        'start_date': datecontroller1.text,
        'end_date': datecontroller2.text,
      });
      print('User updated successfully');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } catch (e) {
      print('Failed to update user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: size.height * 1,
          width: size.width * 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Hey there! ${widget.id}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "What shall I remind you ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    controller: title,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: "Title"),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: TextField(
                    maxLines: 5,
                    maxLength: 100,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    controller: content,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: "Description"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      child: TextField(
                        controller: datecontroller1,
                        onTap: () {
                          datepicker1();
                        },
                        decoration: const InputDecoration(
                            hintText: "From",
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        readOnly: true,
                      ),
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        controller: datecontroller2,
                        onTap: () {
                          datepicker2();
                        },
                        decoration: const InputDecoration(
                            hintText: "To",
                            filled: true,
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        readOnly: true,
                      ),
                    ),
                  ],
                ), // TimePicker
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      child: TextField(
                        controller: timecontroller1,
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              timecontroller1.text = time.format(context);
                            });
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: "Start Time",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            filled: true,
                            prefixIcon: Icon(Icons.watch_later_outlined),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        readOnly: true,
                      ),
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        controller: timecontroller2,
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              timecontroller2.text = time.format(context);
                            });
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: "End Time",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            filled: true,
                            prefixIcon: Icon(Icons.watch_later_outlined),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue))),
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                widget.id == ''
                    ? GestureDetector(
                        onTap: () {
                          print(
                              'button ${title.text} ${content.text} ${timecontroller1.text} ${timecontroller2.text} ${datecontroller1.text} ${datecontroller2.text}');
                          addTaskDetails();
                        },
                        child: Container(
                          height: 45,
                          width: 300,
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              "Add Task",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          print(
                              'button ${title.text} ${content.text} ${timecontroller1.text} ${timecontroller2.text} ${datecontroller1.text} ${datecontroller2.text}');
                          updateUserDetail(widget.id);
                        },
                        child: Container(
                          height: 45,
                          width: 300,
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              "Update Task",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
