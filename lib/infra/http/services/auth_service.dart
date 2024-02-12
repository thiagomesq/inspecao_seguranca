import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  Future<void> sendCode(
    String phone,
    void Function(String verificationId, int? resendToken) codeSent,
    void Function(FirebaseAuthException e) verificationFailed,
  ) async {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    listenUser();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<User?> getUser() async {
    _user = _auth.currentUser;
    return _user;
  }

  Future<bool> isLogged() async {
    _user = _auth.currentUser;
    return _user != null;
  }

  Future<void> listenUser() async {
    _auth.authStateChanges().listen((event) {
      _user = event;
    });
  }

  Future<void> updateProfile(String name) async {
    await _user?.updateDisplayName(name);
  }

  FirebaseAuth get auth => _auth;
}
