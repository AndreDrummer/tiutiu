import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class TiutiuUserController extends GetxController {
  TiutiuUserController(TiutiuUserService tiutiuUserService)
      : _tiutiuUserService = tiutiuUserService;

  final TiutiuUserService _tiutiuUserService;

  final Rx<TiutiuUser> _tiutiuUser = TiutiuUser().obs;

  TiutiuUserService get service => _tiutiuUserService;
  TiutiuUser get tiutiuUser => _tiutiuUser.value;

  void updateTiutiuUser(TiutiuUserEnum property, dynamic data) {
    Map<String, dynamic> map = _tiutiuUser.value.toMap();
    map[property.name] = data;

    TiutiuUser newTiutiuUser = TiutiuUser.fromMap(map);

    _tiutiuUser(newTiutiuUser);
  }

  Future<void> handleNotifications(data) async {
    Map<String, dynamic> notificationData = {};
    String userThatWillReceiveNotification = '';

    switch (data['notificationType']) {
      case 'wannaAdopt':
        notificationData.putIfAbsent(
            'userReference', () => data['userReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Quero adotar!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} tem interesse na adoção de ${data['petName']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'petInfo':
        notificationData.putIfAbsent(
            'userReference', () => data['userReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent(
            'title', () => 'Informações sobre seu PET desaparecido!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} viu seu PET próximo a localização dele.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'adoptionDeny':
        notificationData.putIfAbsent(
            'userReference', () => data['interestedReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Adoção NÃO confirmada!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} negou que tenha adotado ${data['name']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'adoptionConfirmed':
        notificationData.putIfAbsent(
            'userReference', () => data['interestedReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Adoção confirmada!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} confirmou a adoção de ${data['name']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'confirmAdoption':
        notificationData.putIfAbsent(
            'userReference', () => data['ownerReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Confirme adoção!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['ownerName']} pediu que você confirme a adoção de ${data['name']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['interestedID'];
        break;
    }

    print('NOTIFICATION ${data['notificationType']}');

    if (data['notificationType'] != 'chatNotification') {
      String notificationId = data['petReference']['_path']['segments'][1];

      await _tiutiuUserService.createNotification(
        userId: userThatWillReceiveNotification,
        notificationId: notificationId,
        data: notificationData,
      );
    }
  }

  Stream<QuerySnapshot> loadNotifications() {
    return _tiutiuUserService.loadNotifications(tiutiuUser.uid!);
  }

  Future<TiutiuUser> getUserById(String id) async {
    return await _tiutiuUserService.getUserByID(id);
  }

  void resetUserData() {
    _tiutiuUser(TiutiuUser());
  }
}
