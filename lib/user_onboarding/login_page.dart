import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_70/home_page.dart';
import 'package:firebase_70/user_onboarding/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static final String PREF_USER_ID = "userId";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi, Welcome back..',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(
              height: 21,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  label: Text('Email'),
                  hintText: "Enter Email here..",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21))),
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                  label: Text('Password'),
                  hintText: "Enter Password here..",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21))),
            ),
            SizedBox(
              height: 21,
            ),
            ElevatedButton(
                onPressed: () async {
                  var mAuth = FirebaseAuth.instance;
                  try {
                    var userCred = await mAuth.signInWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passController.text.toString());

                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString(LoginPage.PREF_USER_ID, userCred.user!.uid);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));

                  } on FirebaseAuthException catch (e) {
                    print("Invalid Credentials!!");
                  } catch (e) {
                    print("No Internet Connection..");
                  }
                },
                child: Text('Sign In')),
            SizedBox(
              height: 11,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an Account',
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ));
                    },
                    child: Text(
                      ' create now..',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
