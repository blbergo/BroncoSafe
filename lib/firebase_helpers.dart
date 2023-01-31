import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper functions for using Firebase. All functions are async and require the
/// use of await.
class FirebaseHelpers {
  /// Returns all documents from a given [collectionName].When using this
  /// function, be sure to use await in order to get the data,
  /// otherwise an instance of '_Future<List<Object?>>' will be returned
  static Future<List<Object?>> getAllDocsFromCollection(
      String collectionName) async {
    //get a reference to the collection
    var ref = FirebaseFirestore.instance.collection(collectionName);

    //grab a snapshot of the collection
    QuerySnapshot qs = await ref.get();

    //map the data to a list that can be used
    final allData = qs.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}
