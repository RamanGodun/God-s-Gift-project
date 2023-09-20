import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gods_gift/models/cashback_model.dart';
import '/models/admin_model.dart';

class DBmethod {
  late FirebaseFirestore firestore;
  late CollectionReference adminCollection;

  DBmethod() {
    firestore = FirebaseFirestore.instance;
    adminCollection = firestore.collection('admin');
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
        if (docName == 'admin_data') {
          final adminData = AdminModel.fromMap(data);
          return adminData;
        } else if (docName == 'cashback_data') {
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
