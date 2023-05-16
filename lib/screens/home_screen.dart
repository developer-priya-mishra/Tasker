import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tasker/screens/add_note_screen.dart';
import 'package:tasker/screens/edit_note_screen.dart';
import 'package:tasker/models/note_model.dart';
import 'package:tasker/screens/signup_screen.dart';
import 'package:tasker/services/auth_services.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen(this.user, {super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              }
            },
            icon: Icon(Icons.logout),
            splashRadius: 20.0,
            tooltip: "Signout",
          )
        ],
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('notes')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.all(20.0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  NoteModel note =
                      NoteModel.fromJson(snapshot.data.docs[index]);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      tileColor: Colors.deepPurple.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      title: Text(
                        note.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        note.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditNoteScreen(note),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No data available"),
              );
            }
          } else {
            return Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: Colors.white,
                size: 50.0,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(user),
            ),
          );
        },
        backgroundColor: Colors.deepPurple.shade300,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
