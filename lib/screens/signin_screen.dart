import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasker/components/loading_dialog.dart';
import 'package:tasker/screens/home_screen.dart';
import 'package:tasker/screens/signup_screen.dart';
import 'package:tasker/services/auth_services.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  SigninScreenState createState() => SigninScreenState();
}

class SigninScreenState extends State<SigninScreen> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
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
                if (emailController.text == "" ||
                    passwordController.text == "") {
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(
                    msg: "All field are required",
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
                      User? user = await AuthService().signIn(
                        emailController.text,
                        passwordController.text,
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      setState(() {
                        isLoading = false;
                      });
                      if (user != null) {
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(user),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg: "Sorry unable to signin",
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey.shade900,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
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
          SizedBox(height: 20.0),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: Text(
                "Don't have an account? Signup here",
                style: TextStyle(
                  color: Colors.deepPurple.shade100,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (!isLoading) {
                  setState(() {
                    isLoading = true;
                  });
                  LoadingDialog(context);
                  await AuthService().signInWithGoogle();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              icon: SvgPicture.asset(
                "assets/svg/google.svg",
                width: 20.0,
              ),
              label: Text(
                "Continue with Google",
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
