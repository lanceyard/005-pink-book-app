import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';
part 'auth_event.dart';

// [[ Due to limited time, bloc will be needed but not to solve every problems]]

// [[ Main Bloc, process event and state ]]
// [[ cek ini, bloc extends ke event sama state yang dirujuk ]]
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // [[ Constructor, AuthInitial will be the one as an initial state ]]
  AuthBloc() : super(AuthInitial()) {
    // [[ pada contoh satu ini, dia ingin login (event or method UserAuthLogin) ]]

    // -- blank space
    // [[ --------------- User Auth Login with Password event --------------- ]]
    on<UserAuthLoginPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthLoaded(user));
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    // [[ ------------------------------------------------------------------- ]]

    // [[ --------------- User Auth Login with Google --------------- ]]
    on<UserAuthLoginGoogle>((event, emit) async {
      emit(AuthLoading());
      GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? gAuth = await gUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

      try {
        final user =
            await FirebaseAuth.instance.signInWithCredential(credential);
        emit(AuthLoaded(user));
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    // [[ ----------------------------------------------------------- ]]

    // [[ --------------- User Auth Register with Password --------------- ]]
    on<UserAuthRegisterPassword>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthLoaded(user));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          emit(AuthError('The password provided is too weak.'));
        } else if (e.code == 'email-already-in-use') {
          emit(AuthError('The account already exists for that email.'));
        } else {
          emit(AuthError(e.message!));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    // [[ ---------------------------------------------------------------- ]]

    // [[ --------------- User Auth Register with Password --------------- ]]
    on<UserAuthLogout>((event, emit) async {
      emit(AuthLoading());
      await GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
      emit(AuthInitial());
    });
    // [[ ---------------------------------------------------------------- ]]
  }
}
