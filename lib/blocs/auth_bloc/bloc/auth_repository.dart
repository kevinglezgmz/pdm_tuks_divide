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

  Future<UserDetails> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      throw 'Could not log in with Google';
    }
    final googleAuth = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _authInstance.signInWithCredential(credential);

    if (_authInstance.currentUser?.uid == null) {
      throw 'Invalid uid for Google sign in';
    }
    final UserDetails userDetails = await _createFirestoreUser(
      _authInstance.currentUser!.uid,
      googleSignInAccount.email,
      googleSignInAccount.photoUrl,
      googleSignInAccount.displayName ?? googleSignInAccount.email,
      null,
      null,
    );
    return userDetails;
  }

  Future<UserDetails> signInWithEmail(String email, String password) async {
    final UserCredential credential = await _authInstance
        .signInWithEmailAndPassword(email: email, password: password);
    final UserDetails? currUser = await _getFirestoreUser(credential.user!.uid);
    if (currUser == null) {
      throw 'User is not in users database';
    }
    return currUser;
  }

  Future<UserDetails> signUpWithEmail(
      UserDetails newUserDetails, String password) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: newUserDetails.email,
      password: password,
    );
    final UserDetails insertedUserDetails = await _createFirestoreUser(
      credential.user!.uid,
      credential.user!.email!,
      newUserDetails.pictureUrl,
      newUserDetails.displayName,
      newUserDetails.firstName,
      newUserDetails.lastName,
    );
    return insertedUserDetails;
  }

  Future<UserDetails> _createFirestoreUser(
    String uid,
    String email,
    String? profilePicture,
    String? displayName,
    String? firstName,
    String? lastName,
  ) async {
    UserDetails? user = await _getFirestoreUser(uid);
    if (user == null) {
      final Map<String, dynamic> userToInsert = {
        'uid': uid,
        'email': email,
        'pictureUrl': profilePicture,
        'displayName': displayName,
        'firstName': firstName,
        'lastName': lastName,
      };
      await FirebaseFirestore.instance.collection("users").add(userToInsert);
      user = UserDetails.fromMap(userToInsert);
    }
    return UserDetails(
      uid: uid,
      pictureUrl: profilePicture,
      email: email,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<UserDetails?> _getFirestoreUser(String uid) async {
    final usersQuery = await FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: uid)
        .get();
    return usersQuery.docs.isNotEmpty
        ? UserDetails.fromMap(usersQuery.docs[0].data())
        : null;
  }
}
