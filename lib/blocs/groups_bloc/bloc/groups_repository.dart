import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/groups_users_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class GroupsRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  final groupsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groups);
  final groupsUsersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groupsUsers);

  Future<List<GroupModel>> getUserGroups() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return [];
    }
    final userRef = usersCollection.doc(uid);
    final groupsUsersData =
        await groupsUsersCollection.where('user', isEqualTo: userRef).get();
    final userGroupsRefs = groupsUsersData.docs
        .map((doc) => GroupsUsersModel.fromMap(doc.data()))
        .toList();
    final groupsData = await Future.wait(
        userGroupsRefs.map((group) => group.group.get()).toList());
    return groupsData.map((doc) => GroupModel.fromMap(doc.data()!)).toList();
  }

  Future<GroupModel?> createNewUserGroup(
      GroupModel groupData, List<UserModel> members) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    final Map<String, dynamic> dataToUpload = {
      'createdAt': groupData.createdAt,
      'description': groupData.description,
      'groupName': groupData.groupName,
      'groupPicUrl': groupData.groupPicUrl,
      'owner': usersCollection.doc(uid),
    };
    final groupRef = await groupsCollection.add(dataToUpload);
    final userRef = usersCollection.doc(uid);
    await groupsUsersCollection.add({
      'group': groupRef,
      'user': userRef,
    });
    await Future.wait(
      members
          .map(
            (member) => groupsUsersCollection.add(
              {
                'group': groupRef,
                'user': usersCollection.doc(member.uid),
              },
            ),
          )
          .toList(),
    );
    return GroupModel.fromMap(dataToUpload);
  }
}
