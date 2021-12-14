import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late CollectionReference users;

  FireStoreService() {
    init();
  }

  void init() {
    users = _fireStore.collection('users');
    // users.doc("hBC6uj0rHzQGWlhG5SdQ").get().then((value) {
    //   if (!value.exists) {
    //     print("[FireStore ERROR] document does not exists");
    //   } else {
    //     Map<String, dynamic> data = value.data() as Map<String, dynamic>;
    //     print("[DATA] ${data.toString()}");
    //   }
    // });
  }
}
