import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_alert/auth/login_page.dart';
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
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user != null) {
            return checkUserType(context, user);
          } else {
            return LoginPage();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget checkUserType(BuildContext context, User user) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('User').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          if (snapshot.hasData) {
            var data = snapshot.data;
            String userType = data!['User_Type'];

            if (userType == 'ADMIN') {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminHome()));
              
            } else if (userType == 'CDRRMO') {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CdrrmoHome()));
              
            } else if (userType == 'COMCEN') {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ComcenHome()));
              
            } else if (userType == 'PUBLIC') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('You are not authorized to access this page.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            await AuthService().signOut(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              });
            }
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  //sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      print('Signed Out');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed Out'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (err) {
      print(err.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  //sign in
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
