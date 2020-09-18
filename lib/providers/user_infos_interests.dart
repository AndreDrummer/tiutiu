import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class UserInfoOrAdoptInterestsProvider with ChangeNotifier {
  final _adoptInterest = BehaviorSubject<List<String>>.seeded([]);
  final _infos = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get adoptInterest => _adoptInterest.stream;
  Stream<List<String>> get infos => _infos.stream;

  void Function(List<String>) get changeAdoptInterest => _adoptInterest.sink.add;
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
}