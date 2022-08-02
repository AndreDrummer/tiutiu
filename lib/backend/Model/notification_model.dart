import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';

class NotificationModel {
  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    if ((snapshot.data() as Map<String, dynamic>)['petReference'] != null) {
      if ((snapshot.data() as Map<String, dynamic>)['petReference']
              .runtimeType !=
          DocumentReference) {
        getReference(
                (snapshot.data() as Map<String, dynamic>)['petReference']
                    ['_path']['segments'],
                snapshot,
                'petReference')
            .then((value) => petReference = value);
      } else {
        petReference =
            (snapshot.data() as Map<String, dynamic>)['petReference'];
      }
    }

    if ((snapshot.data() as Map<String, dynamic>)['userReference']
            .runtimeType !=
        DocumentReference) {
      getReference(
              (snapshot.data() as Map<String, dynamic>)['userReference']
                  ['_path']['segments'],
              snapshot,
              'userReference')
          .then((value) => userReference = value);
    } else {
      userReference =
          (snapshot.data() as Map<String, dynamic>)['userReference'];
    }
    notificationType =
        (snapshot.data() as Map<String, dynamic>)['notificationType'];
    notificationReference = snapshot.reference;
    time = (snapshot.data() as Map<String, dynamic>)['time'];
    title = (snapshot.data() as Map<String, dynamic>)['title'];
    message = (snapshot.data() as Map<String, dynamic>)['message'];
    open = (snapshot.data() as Map<String, dynamic>)['open'];
  }

  PetController petController = PetController();

  Map<String, dynamic> toJson() {
    return {
      'notificationType': notificationType,
      'petReference': petReference,
      'userReference': userReference,
      'notificationReference': notificationReference,
      'time': time,
      'title': title,
      'message': message,
      'open': open,
    };
  }

  Future<DocumentReference> getReference(
      List listReference, DocumentSnapshot snapshot, String fieldName) async {
    String mountPath = '';
    for (int i = 0; i < listReference.length; i++) {
      mountPath += '/${listReference[i]}';
    }
    final ref = await petController.getReferenceFromPath(
        mountPath, snapshot, fieldName);
    return ref;
  }

  DocumentReference? notificationReference;
  DocumentReference? petReference;
  DocumentReference? userReference;
  String? notificationType;
  String? message;
  String? time;
  String? title;
  bool? open;
}
