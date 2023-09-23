import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/casheBack_system_model.dart';
import '/models/admin_model.dart';

class DBmethod {
  late FirebaseFirestore firestore;
  late FirebaseStorage storage;
  late CollectionReference adminCollection;
  late CollectionReference cashBackCollection;

  DBmethod() {
    firestore = FirebaseFirestore.instance;
    adminCollection = firestore.collection('admin');
    cashBackCollection = firestore.collection('cashBack');
  }

  // Future<void> saveAdminInfoOnFirebase(
  //     AdminModel? adminInfo, CasheBackModel? casheBackModel) async {
  //   String info = '';
  //   String casheback = '';
  //   DocumentSnapshot snapshot = await adminCollection.doc().get();
  //   try {
  //     if (snapshot.exists) {
  //       await adminCollection.doc(adminInfo ==null? casheback : info).update();
  //     } else {
  //       await adminCollection.doc(adminInfo ==null? casheback : info).set(adminInfo.toMap());
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> saveAdminInfoOnFirebase({
    AdminModel? adminInfo,
    CasheBackModel? cashbackInfo,
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

  Future<dynamic> fetchAdminDataFromFirestore(String collectionName) async {
    DocumentSnapshot snapshot = await adminCollection.doc(collectionName).get();
    try {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (collectionName == 'admin_info') {
          final adminData = AdminModel.fromMap(data);
          return adminData;
        } else if (collectionName == 'casheBack') {
          final casheBackData = CasheBackModel.fromMap(data);
          return casheBackData;
        }
      }
    } catch (e) {}
    return null;
  }

  // Future<CasheBackModel?> fetchCasheBack() async {
  //   DocumentSnapshot snapshot =
  //       await adminCollection.doc('casheBackData').get();
  //   try {
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       final casheBackData = CasheBackModel.fromMap(data);
  //       return casheBackData;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future<void> saveCashBackSystem(CasheBackModel casheBack) async {
    try {
      await cashBackCollection.doc('cashBackSystem').set(casheBack.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<CasheBackModel?> getCashBackSystem() async {
    try {
      final snapshot = await cashBackCollection.doc('cashBackSystem').get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final cashBack = CasheBackModel.fromMap(data);
        return cashBack;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> uploadImageToStorage(
    File imageFile,
  ) async {
    try {
      final imagePath = 'images/${const Uuid().v4()}';
      final storageReference = FirebaseStorage.instance.ref().child(imagePath);
      final uploadTask = storageReference.putFile(imageFile);
      final taskSnapshot = await uploadTask;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Ошибка при загрузке изображения: $e');
      return null;
    }
  }
}
