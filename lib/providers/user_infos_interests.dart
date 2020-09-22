import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class UserInfoOrAdoptInterestsProvider with ChangeNotifier {
  final _adoptInterest = BehaviorSubject<List<String>>.seeded([]);
  final _infos = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get adoptInterest => _adoptInterest.stream;
  Stream<List<String>> get infos => _infos.stream;

  void Function(List<String>) get changeAdoptInterest =>
      _adoptInterest.sink.add;
  void Function(List<String>) get changeInfos => _infos.sink.add;

  List<String> get getAdoptInterest => _adoptInterest.value;
  List<String> get getInfos => _infos.value;

  void insertAdoptInterest(String id) {
    List<String> newList = [...getAdoptInterest];
    newList.add(id);
    changeAdoptInterest(newList);
    notifyListeners();
  }

  void insertInfos(String id) {
    List<String> newList = [...getInfos];
    newList.add(id);
    changeInfos(newList);
    notifyListeners();
  }

  Future<String> consultReference(DocumentReference ref) async {
    final refData = await ref.get();
    return Future.value(refData.data()['uid']);
  }

  void checkInterested(DocumentReference petRef, String userId) async {
    changeAdoptInterest([]);
    final pet = await petRef.get();

    if (pet.data()['adoptInteresteds']) {
      List interestedList = pet.data()['adoptInteresteds'];

      if (interestedList != null) {
        for (int i = 0; i < interestedList.length; i++) {
          String userRefId =
              await consultReference(interestedList[i]['userReference']);
          if (userRefId == userId) {
            print(userRefId);
            insertAdoptInterest(pet.id);
          }
        }
      }
    }
  }

  void checkInfo(DocumentReference petRef, String userId) async {
    changeInfos([]);
    final pet = await petRef.get();

    List infoList = pet.data()['infoInteresteds'];

    if (infoList != null) {
      for (int i = 0; i < infoList.length; i++) {
        String userRefId = await consultReference(infoList[i]['userReference']);
        if (userRefId == userId) {
          print(userRefId);
          insertInfos(pet.id);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _infos.close();
    _adoptInterest.close();
  }
}
