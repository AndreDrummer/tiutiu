import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RefineSearchProvider with ChangeNotifier {
  final _kindSelected = BehaviorSubject<int>.seeded(0);
  final _breedSelected = BehaviorSubject<String>.seeded('');
  final _sexSelected = BehaviorSubject<String>.seeded('');
  final _sizeSelected = BehaviorSubject<String>.seeded('');
  final _ageSelected = BehaviorSubject<String>.seeded('');
  final _healthSelected = BehaviorSubject<String>.seeded('');
  final _distancieSelected = BehaviorSubject<String>.seeded('');
  final _isDisappeared = BehaviorSubject<bool>.seeded(false);

  Stream<int> get kindSelected => _kindSelected.stream;  
  Stream<String> get breedSelected => _breedSelected.stream;  
  Stream<String> get sexSelected => _sexSelected.stream;  
  Stream<String> get sizeSelected => _sizeSelected.stream;  
  Stream<String> get ageSelected => _ageSelected.stream;  
  Stream<String> get healthSelected => _healthSelected.stream;  
  Stream<String> get distancieSelected => _distancieSelected.stream;  
  Stream<bool> get isDisappeared => _isDisappeared.stream;  
  
  void changeKindSelected(int kind) {
    _kindSelected.sink.add(kind);
    notifyListeners();
  } 

  void changeSexSelected(String value) {
    _sexSelected.sink.add(value);
    notifyListeners();
  } 

  void changeBreedSelected(String newList) {
    _breedSelected.sink.add(newList);
    notifyListeners();
  } 

  void changeSizeSelected(String newList) {
    _sizeSelected.sink.add(newList);
    notifyListeners();
  } 

  void changeAgeSelected(String newList) {
    _ageSelected.sink.add(newList);
    notifyListeners();
  }

  void changeHealthSelected(String newList) {
    _healthSelected.sink.add(newList);
    notifyListeners();
  }

  void changeDistancieSelected(String newList) {
    _distancieSelected.sink.add(newList);
    notifyListeners();
  }  

  void changeIsDisappeared(bool newValue) {
    _isDisappeared.sink.add(newValue);
    notifyListeners();
  }   

  int get getKindSelected => _kindSelected.stream.value; 
  String get getBreedSelected => _breedSelected.stream.value; 
  String get getSexSelected => _sexSelected.stream.value; 
  String get getSizeSelected => _sizeSelected.stream.value; 
  String get getAgeSelected => _ageSelected.stream.value; 
  String get getHealthSelected => _healthSelected.stream.value; 
  String get getDistancieSelected => _distancieSelected.stream.value; 
  bool get getIsDisappeared => _isDisappeared.stream.value; 
}