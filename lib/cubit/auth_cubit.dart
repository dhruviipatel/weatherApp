import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/services/auth_services.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;

  AuthState({required this.status, this.user});
}

class AuthBloc extends Cubit<AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService)
      : super(AuthState(status: AuthStatus.unauthenticated));

  Future<void> signIn(String email, String password) async {
    final user = await _authService.signInWithEmail(email, password);

    if (user != null) {
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } else {
      emit(AuthState(status: AuthStatus.unauthenticated));
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) =>
              _authService.storeUserDataInFirebase(name, email, password));

      emit(AuthState(
          status: AuthStatus.authenticated, user: userCredential.user));
    } catch (e) {}
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(AuthState(status: AuthStatus.unauthenticated));
  }
}
