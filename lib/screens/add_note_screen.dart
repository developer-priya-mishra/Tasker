import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasker/components/loading_dialog.dart';
import 'package:tasker/services/firestore_services.dart';

class AddNoteScreen extends StatefulWidget {
  final User user;
  const AddNoteScreen(this.user, {super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Text",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Description",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: descriptionController,
            minLines: 5,
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                if (titleController.text == "" ||
                    descriptionController.text == "") {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: "All field are required!",
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey.shade900,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  if (!isLoading) {
                    setState(() {
                      isLoading = true;
                    });
                    LoadingDialog(context);
                    try {
                      await FireStoreService().insertNote(
                        userId: widget.user.uid,
                        title: titleController.text,
                        description: descriptionController.text,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    } catch (error) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                        msg: error.toString(),
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  }
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade100,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
