import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weatherapp/models/userModel.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  storeUserDataInFirebase(name, email, pass) async {
    final user = UserModel(name: name, email: email, password: pass);
    await firestore.collection('users').doc(email).set(user.toMap());
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
