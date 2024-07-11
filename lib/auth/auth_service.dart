import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_alert/auth/login_page.dart';
import 'package:e_alert/pages/ADMIN/adminMainPage.dart';
import 'package:e_alert/pages/CDRRMO/cdrrmoMainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Handle Authentication
  Widget handleAuth() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: checkUserType(context, snapshot.data!),
            builder: (context, userTypeSnapshot) {
              if (userTypeSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (userTypeSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${userTypeSnapshot.error}')),
                );
              } else {
                return userTypeSnapshot.data!;
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<Widget> checkUserType(BuildContext context, User user) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('User').doc(user.uid).get();
      String userType = doc['User_Type'];
      if (userType == 'ADMIN') {
        return const AdminMainPage();
      } else if (userType == 'CDRRMO') {
        return const CDRRMOMainPage();
      } else if (userType == 'COMCEN') {
        // return ComcenHome();
      } else if (userType == 'PUBLIC') {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('You are not authorized to access this app.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await AuthService().signout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
    } catch (e) {
      print('Error checking user type: $e');
      return Scaffold(
        body: Center(child: Text('Error: $e')),
      );
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  // sign out
  Future<void> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Signed out');
    } catch (err) {
      print('Error signing out: $err');
    }
  }

  // sign in
  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Signed in');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed in'),
          duration: Duration(seconds: 3),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // specific FirebaseAuthException instances
      String errorMessage = 'Error signing in';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      }
      // Displays error in the SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // other errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
