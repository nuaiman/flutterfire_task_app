import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _txtCon = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late User? user;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void getUser() async {
    User? u = firebaseAuth.currentUser;
    setState(() {
      user = u;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void _showDialg() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Add Task'),
            content: TextField(
              controller: _txtCon,
              decoration: InputDecoration(
                labelText: 'Write here',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text('Q U I T'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              ElevatedButton(
                child: Text('D O N E'),
                onPressed: () async {
                  String task = _txtCon.text.trim();

                  _firebaseFirestore
                      .collection('users')
                      .doc(user!.uid)
                      .collection('tasks')
                      .add(
                    {
                      'task': task,
                      'dateTime': Timestamp.now(),
                    },
                  );

                  _txtCon.clear();

                  Navigator.of(ctx).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firebaseFirestore
            .collection('users')
            .doc(user!.uid)
            .collection('tasks')
            .orderBy('dateTime', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasData) {
            return ListView(
              // reverse: true,
              children: snapShot.data!.docs.map((snap) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Card(
                    child: ListTile(
                      onTap: () {},
                      // leading: Radio(
                      //   onChanged: (_) {},
                      //   groupValue: true,
                      //   value: 1,
                      // ),
                      title: Text(snap.get('task')),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).errorColor,
                        ),
                        onPressed: () {
                          _firebaseFirestore
                              .collection('users')
                              .doc(user!.uid)
                              .collection('tasks')
                              .doc(snap.id)
                              .delete();
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return Center(
            child: Text('Start Adding Tasks'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.power_settings_new_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_outline),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialg,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
