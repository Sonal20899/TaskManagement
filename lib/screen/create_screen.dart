import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateData extends StatefulWidget {
  final String docId;
  const CreateData({super.key, required this.docId});

  @override
  State<CreateData> createState() => _CreateDataState();
}

class _CreateDataState extends State<CreateData> {
  final user = FirebaseAuth.instance.currentUser;

  //document id
  List<String> docIds = [];

  //delete
  Future<void> deleteUser(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('newUsers')
          .doc(docId)
          .delete();
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
          await FirebaseFirestore.instance.collection('newUsers').get();
      setState(() {
        docIds = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching document IDs: $e');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> delay(int index) async {
    Future.delayed(Duration(seconds: 2));
    return FirebaseFirestore.instance
        .collection('newUsers')
        .doc(docIds[index])
        .get();
  }

  @override
  void initState() {
    super.initState();
    getDocIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Update your Task',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.blue.withOpacity(0.6),
      ),
      body: Column(
        children: [
          Expanded(
              child: docIds.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: docIds.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('newUsers')
                              .doc(docIds[index])
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                title: Text('Loading...'),
                              );
                            } else if (snapshot.hasError) {
                              return ListTile(
                                title: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              final data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Column(
                                children: [
                                  Text('User Name: ${data['user name']}'),
                                  Text('Password: ${data['password']}'),
                                  Text('Phone: ${data['phone']}'),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          print('doc id ${docIds[index]}');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateData(
                                                        docId: docIds[index]),
                                              )).then((value) => getDocIds());
                                        },
                                        child: Text('Update'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Call deleteUser with the document ID
                                          await deleteUser(docIds[index]);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const Text('loading');
                          },
                        );
                      },
                    )),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateData(docId: ''),
                ),
              ).then((value) => getDocIds()); // Refresh document IDs
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
