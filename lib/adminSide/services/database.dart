import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference rehmaniFoodsCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUserData(String uid, String name, String email) async {
    return await rehmaniFoodsCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'timestamp': DateTime.now(),
    });
  }

  Future<void> updateUserData(String name) async {
    return await rehmaniFoodsCollection.doc(uid).update({
      'name': name,
    });
  }
}