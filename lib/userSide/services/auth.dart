import 'package:firebase_auth/firebase_auth.dart';
import '../shared/user.dart';
import 'services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;

    return uid;
  }

  // create user obj based on firebase user
  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser> get user {
    return _auth
        .authStateChanges()
        // .map((User user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password combination.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          return "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";
          break;
        default:
          return "Login failed. Please try again.";
          break;
      }
    }
    return null;
  }

// register with email and password
  Future registerWithEmailAndPassword(
      String name,
      String email,
      String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).addUserData(
          user.uid, name, email,);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          return "Email already used. Go to login page.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          return "Wrong email/password combination.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          return "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";
          break;
        default:
          return "Registration failed. Please try again.";
          break;
      }
    }
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
