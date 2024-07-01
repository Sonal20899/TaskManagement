import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_management/screen/start_screen.dart';
import 'package:task_management/ui/mycolor.dart';

import '../components/shared_key/shared_key.dart';

import '../ui/dialogbox/dialogbox_screen.dart';

import 'datetime_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  String userEmail = '';

  Future<String?> fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(SharedKey.userName)!;
    userEmail = prefs.getString(SharedKey.userEmail)!;
    return null;
  }

  void signout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StartPage(),
        ));
    quickalert(context, "Log Out", QuickAlertType.success);
  }

  final user = FirebaseAuth.instance.currentUser;

  //document id
  List<String> docIds = [];

  //delete
  Future<void> deleteUser(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Vivek').doc(docId).delete();
      print('User deleted successfully');
      await getDocIds(); // Refresh document IDs
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

// Fetch document IDs
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

  bool onTap = true;

  @override
  void initState() {
    super.initState();
    getDocIds();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.sizeOf(context);
    return Scaffold(
      drawer: Padding(
        padding: EdgeInsets.symmetric(vertical: media.height * 0.05),
        child: Drawer(
          width: media.width * 0.74,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors.black,
                      )),
                ),
              ),
              ListTile(
                subtitle: Text(userEmail),
                title: Text(userName),
              ),
              Divider(
                indent: 15,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.black,
                ),
                title: GestureDetector(
                    onTap: () {
                      signout();
                      print("logout");
                    },
                    child: Text('Logout')),
              ),
            ],
          ),
        ),
      ), //Drawer
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
        backgroundColor: Colors.blue,
        title: Text(
          'All Task',
          style: GoogleFonts.actor(
              fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        color: backgroundColor,
        height: media.height,
        width: media.width,
        child: Column(
          children: [
            Expanded(
                child: docIds.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No tasks',
                            style: GoogleFonts.actor(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tap the Add button to create a tasks',
                            style: GoogleFonts.actor(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: docIds.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Vivek')
                                .doc(docIds[index])
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return ListTile(
                                  title: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.data() == null) {
                                return ListTile(
                                  title: Text(
                                    'No Data Available',
                                    style: GoogleFonts.actor(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              } else {
                                final data = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DateTimePage(
                                              id: docIds[index],
                                            ),
                                          )).then((value) => getDocIds());
                                    },
                                    child: SizedBox(
                                      height: media.height * 0.2,
                                      width: media.width * 0.99,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              width: media.width * 0.7,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        data['Title'] ?? '',
                                                        style:
                                                            GoogleFonts.actor(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 5),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        data['Description'] ??
                                                            '',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            data['start_date'] ??
                                                                '',
                                                            style: GoogleFonts.inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            data['StartTime'] ??
                                                                '',
                                                            style: GoogleFonts.inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            data['end_date'] ??
                                                                '',
                                                            style: GoogleFonts.inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            data['EndTime'] ??
                                                                '',
                                                            style: GoogleFonts.inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await deleteUser(
                                                      docIds[index]);
                                                  //alertdialog(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  /*setState(() {
                                                    onTap = !onTap;
                                                  });*/

                                                  // onShowDone(onTap);
                                                  /* ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content:
                                                        Text("Completed..."),
                                                  ));*/
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Icon(
                                                    !onTap
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      )),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: media.height * 0.05, right: 20),
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DateTimePage(id: ''),
                        )).then((value) => getDocIds()); // Refresh document IDs
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
