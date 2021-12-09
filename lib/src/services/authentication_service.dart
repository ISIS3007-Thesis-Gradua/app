import 'package:firebase_auth/firebase_auth.dart';

enum AuthResult { signedIn, signedUp, signedOut, error }

class SignUpResult {
  AuthResult status;
  UserCredential? credentials;
  SignUpResult(this.status, this.credentials);
}

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  UserCredential? credentials;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> get name async {
    try {
      String? name = _firebaseAuth.currentUser?.displayName;
      print('Username: $name');
      return name;
    } on FirebaseException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<AuthResult> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return AuthResult.signedOut;
    } on FirebaseException catch (e) {
      print(e.message);
      return AuthResult.error;
    }
  }

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    try {
      credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthResult.signedIn;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return AuthResult.error;
    }
  }

  Future<SignUpResult> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential credentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return SignUpResult(AuthResult.signedUp, credentials);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return SignUpResult(AuthResult.error, null);
    }
  }
}
