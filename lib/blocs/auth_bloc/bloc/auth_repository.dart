import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/user_model.dart';

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

  Future<UserModel> signInWithGoogle() async {
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
    final UserModel userDetails = await _createFirestoreUser(
      _authInstance.currentUser!.uid,
      googleSignInAccount.email,
      googleSignInAccount.photoUrl,
      googleSignInAccount.displayName ?? googleSignInAccount.email,
      null,
      null,
    );
    return userDetails;
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    final UserCredential credential = await _authInstance
        .signInWithEmailAndPassword(email: email, password: password);
    final UserModel? currUser = await _getFirestoreUser(credential.user!.uid);
    if (currUser == null) {
      throw 'User is not in users database';
    }
    return currUser;
  }

  Future<UserModel> signUpWithEmail(
      UserModel newUserDetails, String password) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: newUserDetails.email,
      password: password,
    );
    final UserModel insertedUserDetails = await _createFirestoreUser(
      credential.user!.uid,
      credential.user!.email!,
      newUserDetails.pictureUrl,
      newUserDetails.displayName,
      newUserDetails.firstName,
      newUserDetails.lastName,
    );
    return insertedUserDetails;
  }

  Future<UserModel> _createFirestoreUser(
    String uid,
    String email,
    String? profilePicture,
    String? displayName,
    String? firstName,
    String? lastName,
  ) async {
    UserModel? user = await _getFirestoreUser(uid);
    if (user == null) {
      final Map<String, dynamic> userToInsert = {
        'uid': uid,
        'email': email,
        'pictureUrl': profilePicture,
        'displayName': displayName,
        'firstName': firstName,
        'lastName': lastName,
      };
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.users)
          .doc(uid)
          .set(userToInsert);
      user = UserModel.fromMap(userToInsert);
    }
    return UserModel(
      uid: uid,
      pictureUrl: profilePicture,
      email: email,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<UserModel?> _getFirestoreUser(String uid) async {
    final meUser = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .doc(uid)
        .get();
    final Map<String, dynamic>? docData = meUser.data();
    if (docData == null) {
      return null;
    }
    return UserModel.fromMap(docData);
  }

  Future<UserModel?> getMeUser() async {
    User? me = FirebaseAuth.instance.currentUser;
    if (me == null) {
      return null;
    }
    final usersQuery = await FirebaseFirestore.instance
        .collection(FirebaseCollections.users)
        .where('uid', isEqualTo: me.uid)
        .get();
    return usersQuery.docs.isNotEmpty
        ? UserModel.fromMap(usersQuery.docs[0].data())
        : null;
  }
}
