import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/chat/model/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService extends GetxController {
  Stream<List<Message>> messages(String userId, String contactId) {
    return _pathToMessages(userId, contactId)
        .orderBy(MessageEnum.createdAt.name, descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      return snapshot.docs.map((favorite) => Message.fromSnapshot(favorite)).toList();
    });
  }

  Stream<Pet> postTalkingAbout(DocumentReference reference) {
    return reference.snapshots().asyncMap((snapshot) {
      return Pet.fromSnapshot(snapshot);
    });
  }

  Stream<List<Contact>> contacts(String userId) {
    return _pathToContacts(userId)
        .orderBy(ContactEnum.lastMessageTime.name, descending: true)
        .snapshots()
        .asyncMap((snapshot) {
      return snapshot.docs.map((favorite) => Contact.fromSnapshot(favorite)).toList();
    });
  }

  void sendMessageAndUpdateContact(Message message, Contact contact) {
    /// Because that Firebase does not support queries like OR, we need to duplicate the data there
    /// in order to guarantee performance. So that is why we need to record the same data in a path
    /// under the user sender messages collection and another under the user receiver messages collection.

    _pathToMessages(message.sender.uid!, contact.id!).doc(message.id).set(message.toJson());
    _pathToContact(message.sender.uid!, contact.id!).set(contact.copyWith(open: true).toJson());

    _pathToMessages(message.receiver.uid!, contact.id!).doc(message.id).set(message.toJson());
    _pathToContact(message.receiver.uid!, contact.id!).set(contact.toJson());
  }

  void markMessageAsRead(Contact contact, String userId) {
    _pathToContact(userId, contact.id!).set(contact.copyWith(open: true).toJson(), SetOptions(merge: true));
  }

  CollectionReference<Map<String, dynamic>> _pathToContacts(String userId) {
    return EndpointResolver.getCollectionEndpoint(EndpointNames.pathToContacts.name, [userId]);
  }

  DocumentReference<Map<String, dynamic>> _pathToContact(String userId, String contactId) {
    return EndpointResolver.getDocumentEndpoint(EndpointNames.pathToContact.name, [userId, contactId]);
  }

  CollectionReference<Map<String, dynamic>> _pathToMessages(String userId, String contactId) {
    return EndpointResolver.getCollectionEndpoint(EndpointNames.pathToMessages.name, [userId, contactId]);
  }
}
