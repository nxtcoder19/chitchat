import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final String? uid;
  DatabaseMethods({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future<void> addUserInfo(Map<String, dynamic> userData) async {
    try {
      await userCollection.add(userData);
    } catch (e) {
      print("Error adding user info: ${e.toString()}");
    }
  }

  Future<QuerySnapshot> getUserInfo(String email) async {
    try {
      return await userCollection.where("userEmail", isEqualTo: email).get();
    } catch (e) {
      print("Error fetching user info: ${e.toString()}");
      rethrow;
    }
  }

  Future<QuerySnapshot> getUserInfoWithUserName(String userName) async {
    try {
      return await userCollection.where("userName", isEqualTo: userName).get();
    } catch (e) {
      print("Error fetching user info: ${e.toString()}");
      rethrow;
    }
  }

  Future<QuerySnapshot> searchByName(String searchField) async {
    try {
      return await userCollection
          .where('userName', isEqualTo: searchField)
          .get();
    } catch (e) {
      print("Error searching by name: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> addChatRoom(
      Map<String, dynamic> chatRoom, String chatRoomId) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .set(chatRoom);
    } catch (e) {
      print("Error adding chat room: ${e.toString()}");
    }
  }

  // Stream<QuerySnapshot> getChats(String chatRoomId) {
  //   return FirebaseFirestore.instance
  //       .collection("chatRoom")
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .orderBy('time')
  //       .snapshots();
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(
      String chatRoomId, Map<String, dynamic> chatMessageData) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(chatMessageData);
    } catch (e) {
      print("Error adding message: ${e.toString()}");
    }
  }

  // Stream<DocumentSnapshot> getUserChats(String itIsMyName) {
  //   return FirebaseFirestore.instance
  //       .collection("chatRoom")
  //       .where('users', arrayContains: itIsMyName)
  //       .snapshots();
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String itIsMyName) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  Future<void> updateUserData(
      String fullName, String email, String password) async {
    try {
      await userCollection.doc(uid).set({
        'fullName': fullName,
        'email': email,
        'password': password,
        'groups': [],
        'profilePic': ''
      });
    } catch (e) {
      print("Error updating user data: ${e.toString()}");
    }
  }

  Future<void> createGroup(String userName, String groupName) async {
    try {
      DocumentReference groupDocRef = await groupCollection.add({
        'groupName': groupName,
        'groupIcon': '',
        'admin': userName,
        'members': [],
        'groupId': '',
        'recentMessage': '',
        'recentMessageSender': ''
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid! + '_' + userName]),
        'groupId': groupDocRef.id
      });

      DocumentReference userDocRef = userCollection.doc(uid);
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
      });
    } catch (e) {
      print("Error creating group: ${e.toString()}");
    }
  }

  Future<void> togglingGroupJoin(
      String groupId, String groupName, String userName) async {
    try {
      DocumentReference userDocRef = userCollection.doc(uid);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      DocumentReference groupDocRef = groupCollection.doc(groupId);
      List<dynamic> groups = userDocSnapshot['groups'] ?? [];

      if (groups.contains(groupId + '_' + groupName)) {
        await userDocRef.update({
          'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
        });
        await groupDocRef.update({
          'members': FieldValue.arrayRemove([uid! + '_' + userName])
        });
      } else {
        await userDocRef.update({
          'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
        });
        await groupDocRef.update({
          'members': FieldValue.arrayUnion([uid! + '_' + userName])
        });
      }
    } catch (e) {
      print("Error toggling group join: ${e.toString()}");
    }
  }

  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    try {
      DocumentSnapshot userDocSnapshot = await userCollection.doc(uid).get();
      List<dynamic> groups = userDocSnapshot['groups'] ?? [];
      return groups.contains(groupId + '_' + groupName);
    } catch (e) {
      print("Error checking user join status: ${e.toString()}");
      return false;
    }
  }

  Future<QuerySnapshot> getUserData(String email) async {
    try {
      return await userCollection.where('email', isEqualTo: email).get();
    } catch (e) {
      print("Error fetching user data: ${e.toString()}");
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getUserGroups() {
    print(userCollection.doc(uid).snapshots());
    return userCollection.doc(uid).snapshots();
  }

  Future<void> sendMessage(
      String groupId, Map<String, dynamic> chatMessageData) async {
    try {
      await groupCollection
          .doc(groupId)
          .collection('messages')
          .add(chatMessageData);
      await groupCollection.doc(groupId).update({
        'recentMessage': chatMessageData['message'],
        'recentMessageSender': chatMessageData['sender'],
        'recentMessageTime': chatMessageData['time'].toString(),
      });
    } catch (e) {
      print("Error sending message: ${e.toString()}");
    }
  }

  // Stream<QuerySnapshot> getChats(String groupId) {
  //   return groupCollection
  //       .doc(groupId)
  //       .collection('messages')
  //       .orderBy('time')
  //       .snapshots();
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGroupChats(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  // Future<QuerySnapshot> searchByNames(String groupName) async {
  //   try {
  //     return await groupCollection
  //         .where('groupName', isEqualTo: groupName)
  //         .get();
  //   } catch (e) {
  //     print("Error searching by group name: ${e.toString()}");
  //     rethrow;
  //   }
  // }
  Stream<QuerySnapshot<Map<String, dynamic>>> searchByNames(
      String searchField) {
    return FirebaseFirestore.instance
        .collection('groups')
        .where('groupName', isEqualTo: searchField)
        .snapshots();
  }
}
