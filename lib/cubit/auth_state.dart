part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSuuccess extends AuthState {
  final String uid;

  AuthSuuccess({required this.uid});
}

final class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

final class AuthLoading extends AuthState {}




// enum AuthStatus { authenticated, unauthenticated }

// class AuthState {
//   final AuthStatus status;
//   final User? user;

//   AuthState({required this.status, this.user});
// }
