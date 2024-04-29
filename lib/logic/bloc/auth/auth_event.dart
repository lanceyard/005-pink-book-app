part of 'auth_bloc.dart';

// [[ Ini bakalan menjadi method tiap bloc ]]
abstract class AuthEvent {}

class UserAuthLoginPassword extends AuthEvent {
  String email;
  String password;
  UserAuthLoginPassword(this.email, this.password);
}

class UserAuthRegisterPassword extends AuthEvent {
  String email;
  String password;
  UserAuthRegisterPassword(this.email, this.password);
}

class UserAuthLoginGoogle extends AuthEvent {
  UserAuthLoginGoogle();
}

class UserAuthLogout extends AuthEvent {
  UserAuthLogout();
}
