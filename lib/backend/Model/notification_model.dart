import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';

class NotificationModel {

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    notificationType = snapshot.data()['notificationType'];    
    if(snapshot.data()['petReference'].runtimeType != DocumentReference) {      
      getReference(snapshot.data()['petReference']['_path']['segments'], snapshot, 'petReference').then((value) => petReference = value);
    } else {
      petReference = snapshot.data()['petReference'];
    }

    if(snapshot.data()['userReference'].runtimeType != DocumentReference) {
      getReference(snapshot.data()['userReference']['_path']['segments'], snapshot, 'userReference').then((value) => userReference = value);
    } else {
      userReference = snapshot.data()['userReference'];
    }
    notificationReference = snapshot.reference;
    time = snapshot.data()['time'];
    title = snapshot.data()['title'];
    message = snapshot.data()['message'];
    open = snapshot.data()['open'];
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

  Future<DocumentReference> getReference(List listReference, DocumentSnapshot snapshot, String fieldName) async {
    String mountPath = '';
    for(int i = 0; i < listReference.length; i++) {      
      mountPath += '/${listReference[i]}';
    }    
    print('PATH $mountPath');
    final ref = await petController.getReferenceFromPath(mountPath, snapshot, fieldName);
    print('REF $ref');    
    return ref;
  }

  

  String notificationType;
  DocumentReference petReference;
  DocumentReference userReference;
  DocumentReference notificationReference;
  String time;
  String title;
  String message;
  bool open;

}
