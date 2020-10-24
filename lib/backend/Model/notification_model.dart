import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';

class NotificationModel {

  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {    
    notificationType = snapshot.data()['notificationType'];

    if(snapshot.data()['petRef'].runtimeType != DocumentReference) {
      getReference(snapshot.data()['petRef']['_path']['segments'], snapshot, 'petRef').then((value) => petRef = value);
    } else {
      petRef = snapshot.data()['petRef'];
    }

    if(snapshot.data()['userRef'].runtimeType != DocumentReference) {
      getReference(snapshot.data()['userRef']['_path']['segments'], snapshot, 'userRef').then((value) => userRef = value);
    } else {
      userRef = snapshot.data()['userRef'];
    }
        
    time = snapshot.data()['time'];
    title = snapshot.data()['title'];
    message = snapshot.data()['message'];
    open = snapshot.data()['open'];
  }

  PetController petController = PetController();

  Map<String, dynamic> toJson() {
    return {
      'notificationType': notificationType,
      'petRef': petRef,
      'userRef': userRef,
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
  DocumentReference petRef;
  DocumentReference userRef;
  String time;
  String title;
  String message;
  bool open;

}
