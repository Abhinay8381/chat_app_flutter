import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  //reference for our collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  // function for saving userdata
  Future saveUserData(String fullName, String email) async {
    return userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePhoto": "",
      "uid": uid,
    });
  }

  // function for getting userdata
  Future getUSerData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //getting user gropus
  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "admin": "${id}_$userName",
      "groupName": groupName,
      "groupIcon": "",
      "members": [],
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": "",
      "groupId": "",
    });
    await groupDocumentReference.update({
      "groupId": groupDocumentReference.id,
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    });
    DocumentReference userDocumentReference = userCollection.doc(uid);
    userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"]),
    });
  }

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('messageTime')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference documentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['admin'];
  }

  //get group members
  getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search
  searchByName(String groupName) async {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUSerJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference d = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await d.get();
    List<dynamic> groups = documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleUserJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupsDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = userDocumentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupsDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupsDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  Future<String> getUserProfileUrl() async {
    DocumentReference documentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['profilePhoto'];
  }

  Future<String> getUserNameFromUid() async {
    DocumentReference documentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    return documentSnapshot['fullName'];
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageModel) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageModel);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageModel['message'],
      "recentMessageSender": chatMessageModel['messageSender'],
      "recentMessageTime": chatMessageModel['messageTime'].toString()
    });
  }
}
