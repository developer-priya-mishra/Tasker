import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasker/components/loading_dialog.dart';
import 'package:tasker/models/note_model.dart';
import 'package:tasker/services/firestore_services.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;
  const EditNoteScreen(this.note, {super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Please confirm"),
                    content: Text("Are you sure to delete note?"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          if (!isLoading) {
                            setState(() {
                              isLoading = true;
                            });
                            LoadingDialog(context);
                            try {
                              await FireStoreService()
                                  .deleteNote(widget.note.id);
                              if (context.mounted) {
                                Navigator.pop(context);
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
                        },
                        child: Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
            splashRadius: 20.0,
            tooltip: "Delete",
          ),
        ],
      ),
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
            minLines: 5,
            maxLines: 10,
            controller: descriptionController,
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
                      await FireStoreService().updateNote(
                        id: widget.note.id,
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
          ),
        ],
      ),
    );
  }
}
