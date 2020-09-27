import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class RefineSearchProvider with ChangeNotifier {
  final _kindSelected = BehaviorSubject<int>.seeded(0);
  final _breedsSelected = BehaviorSubject<List<String>>.seeded([]);
  final _sizesSelected = BehaviorSubject<List<String>>.seeded([]);
  final _agesSelected = BehaviorSubject<List<String>>.seeded([]);
  final _healthsSelected = BehaviorSubject<List<String>>.seeded([]);
  final _distanciesSelected = BehaviorSubject<List<String>>.seeded([]);

  Stream<int> get kindSelected => _kindSelected.stream;  
  Stream<List<String>> get breedsSelected => _breedsSelected.stream;  
  Stream<List<String>> get sizesSelected => _sizesSelected.stream;  
  Stream<List<String>> get agesSelected => _agesSelected.stream;  
  Stream<List<String>> get healthsSelected => _healthsSelected.stream;  
  Stream<List<String>> get distanciesSelected => _distanciesSelected.stream;  
  
  void changeKindSelected(int kind) {
    _kindSelected.sink.add(kind);
    notifyListeners();
  } 

  void changeBreedsSelected(List<String> newList) {
    _breedsSelected.sink.add(newList);
    notifyListeners();
  } 

  void changeSizesSelected(List<String> newList) {
    _sizesSelected.sink.add(newList);
    notifyListeners();
  } 

  void changeAgesSelected(List<String> newList) {
    _agesSelected.sink.add(newList);
    notifyListeners();
  }

  void changeHealthsSelected(List<String> newList) {
    _healthsSelected.sink.add(newList);
    notifyListeners();
  }

  void changeDistanciesSelected(List<String> newList) {
    _distanciesSelected.sink.add(newList);
    notifyListeners();
  }   

  int get getKindSelected => _kindSelected.stream.value; 
  List<String> get getBreedsSelected => _breedsSelected.stream.value; 
  List<String> get getSizesSelected => _sizesSelected.stream.value; 
  List<String> get getAgesSelected => _agesSelected.stream.value; 
  List<String> get getHealthsSelected => _healthsSelected.stream.value; 
  List<String> get getDistanciesSelected => _distanciesSelected.stream.value; 
}