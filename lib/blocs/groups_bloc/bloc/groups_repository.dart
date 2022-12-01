import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/groups_users_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class GroupsRepository {
  final usersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.users);
  final groupsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groups);
  final groupsUsersCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groupsUsers);
  final groupsSpendingsCollection = FirebaseFirestore.instance
      .collection(FirebaseCollections.groupsSpendings);
  final spendingsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.spendings);

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
    return groupsData
        .map(
          (doc) => GroupModel.fromMap(doc.data()!..addAll({'groupId': doc.id})),
        )
        .toList();
  }

  Future<GroupModel?> createNewUserGroup(
    String description,
    String groupName,
    String groupPicUrl,
    List<UserModel> members,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    final Map<String, dynamic> dataToUpload = {
      'createdAt': Timestamp.now(),
      'description': description,
      'groupName': groupName,
      'groupPicUrl': groupPicUrl,
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
    return GroupModel.fromMap(dataToUpload..addAll({'groupId': groupRef.id}));
  }

  Future<List<UserModel>> getMembersOfGroup(GroupModel group) async {
    final groupsUsersDocs = await groupsUsersCollection
        .where(
          "group",
          isEqualTo: groupsCollection.doc(group.groupId),
        )
        .get();
    final List<GroupsUsersModel> groupUsers = groupsUsersDocs.docs
        .map((doc) => GroupsUsersModel.fromMap(doc.data()))
        .toList();
    final usersDocs = await Future.wait(
      groupUsers
          .map(
            (groupUser) => groupUser.user.get(),
          )
          .toList(),
    );
    return usersDocs
        .map((userDoc) => UserModel.fromMap(userDoc.data()!))
        .toList();
  }

  Future<bool> saveSpendingForGroup(
    GroupModel group,
    Map<UserModel, double> userToAmountToPay,
    double amount,
    String description,
    String spendingPic,
    DistributionType distributionType,
    UserModel paidBy,
  ) async {
    final SpendingModel spendingModel = SpendingModel(
      amount: amount,
      createdAt: Timestamp.now(),
      description: description,
      distributionType: distributionType,
      paidBy: usersCollection.doc(
        paidBy.uid,
      ),
      participants: userToAmountToPay.keys
          .map((e) => usersCollection.doc(e.uid))
          .toList(),
      spendingPic: spendingPic,
      addedBy: usersCollection.doc(
        FirebaseAuth.instance.currentUser!.uid,
      ),
    );
    final spendingRef = await spendingsCollection.add(spendingModel.toMap());
    await Future.wait(
      userToAmountToPay.entries.map((entry) {
        GroupSpendingModel newRecord = GroupSpendingModel(
          group: groupsCollection.doc(group.groupId),
          spending: spendingRef,
          user: usersCollection.doc(entry.key.uid),
          amountToPay: entry.value,
        );
        return groupsSpendingsCollection.add(
          newRecord.toMap(),
        );
      }).toList(),
    );
    return false;
  }
}
