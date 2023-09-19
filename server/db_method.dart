import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/admin_model.dart';

class DBmethod {
  late FirebaseFirestore firestore;
  late CollectionReference adminCollection;

  DBmethod() {
    firestore = FirebaseFirestore.instance;
    adminCollection = firestore.collection('admin');
  }

  Future<void> saveAdminInfoOnFirebase(AdminModel adminInfo) async {
    DocumentSnapshot snapshot = await adminCollection.doc('admin_data').get();
    try {
      if (snapshot.exists) {
        await adminCollection.doc('admin_data').update(adminInfo.toMap());
      } else {
        await adminCollection.doc('admin_data').set(adminInfo.toMap());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<AdminModel?> fetchAdminDataFromFirestore() async {
    DocumentSnapshot snapshot = await adminCollection.doc('admin_data').get();
    try {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final generalData = AdminModel.fromMap(data);
        return generalData;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
