import 'package:chitchat/model/user.dart';
import 'package:chitchat/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Convert Firebase User to custom User model
  User? _userFromFirebaseUser(auth.User? user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("Error during sign in: ${e.toString()}");
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.User? user = result.user;

      // Add user data to the database
      await DatabaseMethods(uid: user?.uid)
          .updateUserData(fullName, email, password);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print("Error during sign up: ${e.toString()}");
      return null;
    }
  }

  // Reset password
  Future resetPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Error during password reset: ${e.toString()}");
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print("Error during sign out: ${e.toString()}");
      return null;
    }
  }
}

// class User {
//   final String? uid;
//   User({this.uid});
// }
