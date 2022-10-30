import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  bool get isLoggedIn => _authInstance.currentUser != null;

  Future<GoogleSignInAccount?> signOutGoogleUser() async {
    return _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    return _authInstance.signOut();
  }

  Future<UserDetails?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      throw 'Could not log in with Google';
    }
    final googleAuth = await googleSignInAccount.authentication;

    final AuthCredential credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _authInstance.signInWithCredential(credentials);

    if (_authInstance.currentUser?.uid != null) {
      await _createFirestoreUser(
        _authInstance.currentUser!.uid,
        googleSignInAccount.email,
        googleSignInAccount.photoUrl,
      );
    }
    return UserDetails(
      displayName: googleSignInAccount.displayName ?? googleSignInAccount.email,
      email: googleSignInAccount.email,
      uid: _authInstance.currentUser!.uid,
      pictureUrl: googleSignInAccount.photoUrl,
    );
  }

  Future<void> _createFirestoreUser(
      String uid, String email, String? profilePicture) async {
    final usersQuery = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: uid)
        .get();
    final user = usersQuery.docs.isNotEmpty ? usersQuery.docs.first : null;
    // Si no exite el doc, lo crea con valor default lista vacia
    if (user == null || user.exists == false) {
      await FirebaseFirestore.instance.collection("users").add({
        'uid': uid,
        'email': email,
        'pictureUrl': profilePicture,
      });
    }
  }
}
