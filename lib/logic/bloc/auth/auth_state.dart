part of 'auth_bloc.dart';

// [[ Ini bakalan menjadi state tiap bloc ]]
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthError extends AuthState {
  String error;
  AuthError(this.error);
}
