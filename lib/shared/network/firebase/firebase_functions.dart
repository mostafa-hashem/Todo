import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/user_model.dart';

class FirebaseFunctions {
  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(UserModel.COLLECTIN_NAME)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()),
          toFirestore: (user, options) => user.toJson(),
        );
  }

  static CollectionReference<TaskModel> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
      toFirestore: (task, options) => task.toJson(),
        );
  }

  static Future<void> addTaskToFireStore(TaskModel task) {
    final collections = getTasksCollection();
    final docRef = collections.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Stream<QuerySnapshot<TaskModel>> getTasksFromFireStore(DateTime date) {
    final collection = getTasksCollection();
    return collection
        .where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("date",
            isEqualTo: DateUtils.dateOnly(date).millisecondsSinceEpoch,)
        .orderBy("time", descending: true)
        .snapshots();
  }

  static Future<void> deleteTask(String id) {
    return getTasksCollection().doc(id).delete();
  }

  static Future<void> updateTask(String id, TaskModel task) {
    return getTasksCollection().doc(id).update(task.toJson());
  }

  static Future<void> addUserToFireStore(UserModel user) {
    final collection = getUsersCollection();
    final docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUser(String id) async {
    final DocumentSnapshot<UserModel> userSnap =
        await getUsersCollection().doc(id).get();
    return userSnap.data();
  }
}
