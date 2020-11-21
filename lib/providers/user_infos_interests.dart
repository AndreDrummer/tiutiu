import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/backend/Model/interested_model.dart';

class UserInfoOrAdoptInterestsProvider with ChangeNotifier {
  final _adoptInterest = BehaviorSubject<List<String>>.seeded([]);
  final _infos = BehaviorSubject<List<String>>.seeded([]);
  final _interedtedList = BehaviorSubject<List<InterestedModel>>();
  final _infoList = BehaviorSubject<List<InterestedModel>>();
  final _lastimeInterestOrInfo = BehaviorSubject<String>();

  Stream<List<String>> get adoptInterest => _adoptInterest.stream;
  Stream<List<String>> get infos => _infos.stream;
  Stream<List<InterestedModel>> get interested => _interedtedList.stream;
  Stream<List<InterestedModel>> get info => _infoList.stream;
  Stream<String> get lastimeInterestToAdopt => _lastimeInterestOrInfo.stream;

  void Function(List<String>) get changeAdoptInterest =>
      _adoptInterest.sink.add;
  void Function(List<String>) get changeInfos => _infos.sink.add;
  void Function(List<InterestedModel>) get changeInterested =>
      _interedtedList.sink.add;
  void Function(List<InterestedModel>) get changeInfo => _infoList.sink.add;
  void Function(String) get changeLastimeInterestOrInfo =>
      _lastimeInterestOrInfo.sink.add;

  List<String> get getAdoptInterest => _adoptInterest.value;
  List<String> get getInfos => _infos.value;
  List<InterestedModel> get getInterested => _interedtedList.value;
  List<InterestedModel> get getInfo => _infoList.value;
  String get getLastimeInterestOrInfo => _lastimeInterestOrInfo.value;

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

  Future<String> getUidByReference(DocumentReference ref) async {
    final refData = await ref.get();
    if (refData.data() == null) return '';
    return Future.value(refData.data()['uid']);
  }

  void checkInterested(DocumentReference petRef, DocumentReference userReference) async {    
    final pet = await petRef.get();

    if (pet.data() != null) {
      var interestedRef = await petRef.collection('adoptInteresteds').get();
      var interestedList = interestedRef.docs;

      if (interestedList != null) {
        for (int i = 0; i < interestedList.length; i++) {                    
          if (userReference == interestedList[i].data()['userReference']) {
            changeLastimeInterestOrInfo(interestedList[i].data()['interestedAt']);
          }
        }
      }
    }
  }

  void checkInfo(DocumentReference petRef, DocumentReference userReference) async {    
    final pet = await petRef.get();

    if (pet.data() != null) {
      var infoRef = await petRef.collection('infoInteresteds').get();
      var infoList = infoRef.docs;
      if (infoList != null) {
        for (int i = 0; i < infoList.length; i++) {          
          if (userReference == infoList[i].data()['userReference']) {
            changeLastimeInterestOrInfo(infoList[i].data()['interestedAt']);
          }
        }
      }
    }
  }

  void loadInterested(DocumentReference petRef) async {
    final pet = await petRef.get();
    List<InterestedModel> interested = [];

    if (pet.data() != null) {
      var interestedRef = await petRef.collection('adoptInteresteds').get();
      var interestedList = interestedRef.docs;

      for (int i = 0; i < interestedList.length; i++) {
        interested.add(InterestedModel.fromMap(interestedList[i].data()));
      }
      changeInterested(interested);
    }
  }

  void loadInfo(DocumentReference petRef) async {
    final pet = await petRef.get();
    List<InterestedModel> info = [];

    if (pet.data() != null) {
      var infoRef = await petRef.collection('infoInteresteds').get();
      var infoList = infoRef.docs;
      for (int i = 0; i < infoList.length; i++) {
        info.add(InterestedModel.fromMap(infoList[i].data()));
      }
      changeInfo(info);
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
