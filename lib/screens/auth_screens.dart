import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isloading = false;

  Future<void> submitauthform(String email, String username, String password,
      bool islogin, BuildContext ctx) async {
    UserCredential authresult;

    try {
      setState(() {
        _isloading = true;
      });

      if (islogin) {
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      //Firebase storage--image upload

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authresult.user!.uid)
          .set({'username': username, 'email': email, 'password': password});
    } on PlatformException catch (err) {
      String? message = "An error occurred, please check your crendittals";

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message!,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );

      setState(() {
        _isloading = false;
      });
    } catch (err) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      // print(err);

      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Todo-App"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                NetworkImage("http://cdn.wallpapersafari.com/7/86/gqiGH7.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: AuthForm(submitauthform, _isloading),
      ),
    );
  }
}
