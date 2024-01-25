import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account!!',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(
              height: 21,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  label: Text('Name'),
                  hintText: "Enter Name here..",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21))),
            ),
            SizedBox(
              height: 11,
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
                onPressed: () async{
                  var mAuth = FirebaseAuth.instance;
                  try{
                   var userCred = await mAuth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passController.text.toString());

                   var mFireStore = FirebaseFirestore.instance;

                   mFireStore
                       .collection("users")
                       .doc(userCred.user!.uid).set({
                     'email' : emailController.text.toString(),
                     'name' : nameController.text.toString(),
                   });

                   Navigator.pop(context);

                  } on FirebaseAuthException catch (e){
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e){
                    print("No Internet Connection..");
                  }
                },
                child: Text('Sign Up')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an Account',),
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      },
                    child: Text(' login now..',style: TextStyle(fontWeight: FontWeight.bold),)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
