import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/backend/Model/interested_model.dart';

class UserInfoOrAdoptInterestsProvider with ChangeNotifier {
  final _adoptInterest = BehaviorSubject<List<String>>.seeded([]);
  final _infos = BehaviorSubject<List<String>>.seeded([]);
  final _interedtedList = BehaviorSubject<List<InterestedModel>>();

  Stream<List<String>> get adoptInterest => _adoptInterest.stream;
  Stream<List<String>> get infos => _infos.stream;
  Stream<List<InterestedModel>> get interested => _interedtedList.stream;

  void Function(List<String>) get changeAdoptInterest => _adoptInterest.sink.add;
  void Function(List<String>) get changeInfos => _infos.sink.add;
  void Function(List<InterestedModel>) get changeInterested => _interedtedList.sink.add;

  List<String> get getAdoptInterest => _adoptInterest.value;
  List<String> get getInfos => _infos.value;
  List<InterestedModel> get getInterested => _interedtedList.value;

  void insertAdoptInterestID(String id) {
    List<String> newList = [...getAdoptInterest];
    newList.add(id);
    changeAdoptInterest(newList);
    notifyListeners();
  }

  void insertInfosID(String id) {
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

    if (pet.data() != null) {
      List interestedList = pet.data()['adoptInteresteds'];      

      if (interestedList != null) {
        for (int i = 0; i < interestedList.length; i++) {
          String userRefId =
              await consultReference(interestedList[i]['userReference']);
          if (userRefId == userId) {
            print(userRefId);
            insertAdoptInterestID(pet.id);
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
          insertInfosID(pet.id);
        }
      }
    }
  } 

  void loadInterested(DocumentReference petRef) async {    
    final pet = await petRef.get();
    List<InterestedModel> interested = [];

    if (pet.data() != null) {
      List interestedList = pet.data()['adoptInteresteds'];
      print(interestedList);
      for(int i = 0; i < interestedList.length; i++) {
        interested.add(InterestedModel.fromMap(interestedList[i]));
      }
      changeInterested(interested);      
    }
  }

  void loadInfos(DocumentReference petRef, String userId) async {    
    final pet = await petRef.get();

    List infoList = pet.data()['infoInteresteds'];

    if (infoList != null) {
      for (int i = 0; i < infoList.length; i++) {
        String userRefId = await consultReference(infoList[i]['userReference']);
        if (userRefId == userId) {
          print(userRefId);
          insertInfosID(pet.id);
        }
      }
    }
  } 

  @override
  void dispose() {
    super.dispose();
    _infos.close();
    _adoptInterest.close();
    _interedtedList.close();
  }
}
