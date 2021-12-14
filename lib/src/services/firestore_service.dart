import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenity/src/models/user.dart';
import 'package:serenity/src/services/authentication_service.dart';
import 'package:serenity/src/utils/generic_consts.dart';

class FireStoreService {
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final CollectionReference _users = _fireStore.collection('users');

  ///Creates an entry on the users collection on FireStore Containing the
  ///given user's profile information.
  Future createUser(GraduaUser user) async {
    try {
      if (user.id == emptyUid) {
        throw Exception('The provided User UID from firebase auth was null');
      } else {
        await _users.doc(user.id).set(user.toJson());
      }
    } on Exception catch (e) {
      print(
          "[Logging error] Error writing user to firebase collection. Message: $e");
    }
  }

  ///If it exists, retrieves from the users collection on FireStore the profile
  ///information for the given user uid. The uid can be obtain from the
  ///[AuthenticationService] singleton instance colling credentials.user.uid
  Future<GraduaUser?> getUser(String uid) async {
    try {
      var userReference = await _users.doc(uid).get();
      if (userReference.exists) {
        Map<String, dynamic> data =
            userReference.data() as Map<String, dynamic>;
        return GraduaUser.fromData(data);
      } else {
        print("[COLLECTION REQUEST ERROR] User: ${uid} does not exist.");
      }
    } on Exception catch (e) {
      print(
          "[COLLECTION REQUEST ERROR] Error while retrieving user ${uid} from collections. Message: $e");
    }
  }
}
