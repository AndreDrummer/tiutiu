import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SupportUsController extends GetxController {
  Future<String> getPixKey() async {
    final snapshot =
        await FirebaseFirestore.instance.collection(FirebaseEnvPath.projectName).doc(FirebaseEnvPath.keys).get();

    return snapshot.data()![FirebaseEnvPath.pix];
  }
}
