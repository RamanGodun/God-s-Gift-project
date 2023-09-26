import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gods_gift/models/cashback_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '/models/admin_model.dart';

class DBmethod {
  late FirebaseFirestore firestore;
  late CollectionReference adminCollection;
  late FirebaseStorage firebaseStorage;

  DBmethod() {
    firestore = FirebaseFirestore.instance;
    adminCollection = firestore.collection('admin');
    firebaseStorage = FirebaseStorage.instance;
  }

  Future<String?> saveImageToStorage(
      {File? imageFile, String? imageName}) async {
    Reference storageReference =
        firebaseStorage.ref().child('images/adminPhoto/$imageName');
    UploadTask uploadTask = storageReference.putFile(imageFile as File);
    TaskSnapshot storageSnapshot = await uploadTask;
    String downloadURL = await storageSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> saveAdminInfoOnFirebase({
    AdminModel? adminInfo,
    CashbackModel? cashbackInfo,
    String? docName,
  }) async {
    DocumentSnapshot snapshot = await adminCollection.doc(docName).get();
    try {
      if (snapshot.exists) {
        await adminCollection.doc(docName).update(
            adminInfo == null ? cashbackInfo!.toMap() : adminInfo.toMap());
      } else {
        await adminCollection
            .doc(docName)
            .set(adminInfo == null ? cashbackInfo!.toMap() : adminInfo.toMap());
      }
    } catch (e) {
      print(e.toString());
    }
  }

//   Future<void> saveAdminInfoOnFirebase({
//   AdminModel? adminInfo,
//   CashbackModel? cashbackInfo,
//   String? docName,
// }) async {
//   try {
//     Map<String, dynamic> dataToSave = adminInfo?.toMap() ?? cashbackInfo?.toMap() ?? {};

//     if (dataToSave.isNotEmpty) {
//       await adminCollection.doc(docName).set(dataToSave, SetOptions(merge: true));
//     }
//   } catch (e) {
//     print(e.toString());
//   }
// }

  Future<dynamic> fetchAdminDataFromFirestore(String docName) async {
    DocumentSnapshot snapshot = await adminCollection.doc(docName).get();
    try {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (docName == 'adminData') {
          final adminData = AdminModel.fromMap(data);
          return adminData;
        } else if (docName == 'cashbackData') {
          final cashbackData = CashbackModel.fromMap(data);
          return cashbackData;
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
