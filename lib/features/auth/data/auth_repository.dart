import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../domain/user.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<AppUser?> get userStream => _auth.authStateChanges().map(
        (firebaseUser) => firebaseUser != null
            ? AppUser(
                id: firebaseUser.uid,
                email: firebaseUser.email!,
                displayName: firebaseUser.displayName,
              )
            : null,
      );

  Future<AppUser?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final u = cred.user!;
    return AppUser(id: u.uid, email: u.email!, displayName: u.displayName);
  }

  Future<AppUser?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await _auth.signInWithCredential(credential);
    final u = cred.user!;
    return AppUser(id: u.uid, email: u.email!, displayName: u.displayName);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  AppUser? get currentUser {
    final u = _auth.currentUser;
    if (u == null) return null;
    return AppUser(id: u.uid, email: u.email!, displayName: u.displayName);
  }
}
