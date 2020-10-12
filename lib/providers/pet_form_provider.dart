import 'package:rxdart/subjects.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/utils/form_validators.dart';

class PetFormProvider with ChangeNotifier, FormValidator {
  final _petName = BehaviorSubject<String>.seeded('');
  final _petColor = BehaviorSubject<String>.seeded('Abóbora');
  final _petTypeIndex = BehaviorSubject<int>.seeded(0);
  final _petAge = BehaviorSubject<int>.seeded(0);
  final _petMonths = BehaviorSubject<int>.seeded(0);
  final _petSize = BehaviorSubject<String>.seeded('Pequeno-porte');
  final _petHealthIndex = BehaviorSubject<int>.seeded(0);
  final _petBreedIndex = BehaviorSubject<int>.seeded(0);
  final _petSex = BehaviorSubject<String>.seeded('Macho');
  final _petSelectedCaracteristics = BehaviorSubject<List>.seeded([]);
  final _petDescription = BehaviorSubject<String>.seeded('');
  final _petPhotos = BehaviorSubject<List>.seeded([]);

  // Streams to be listened
  Stream<String> get petName => _petName.stream.transform(validateEmpty);
  Stream<String> get petColor => _petColor.stream;
  Stream<int> get petTypeIndex => _petTypeIndex.stream;
  Stream<int> get petAge => _petAge.stream.transform(validateAge);
  Stream<int> get petMonths => _petMonths.stream;
  Stream<String> get petSize => _petSize.stream;
  Stream<int> get petHealthIndex => _petHealthIndex.stream;
  Stream<int> get petBreedIndex => _petBreedIndex.stream;
  Stream<String> get petSex => _petSex.stream;
  Stream<List> get petSelectedCaracteristics => _petSelectedCaracteristics.stream;
  Stream<String> get petDescription => _petDescription.stream.transform(validateEmpty);
  Stream<List> get petPhotos => _petPhotos.stream.transform(validatePhotos);

  // Stream change
  void Function(String) get changePetName => _petName.sink.add;
  void Function(String) get changePetColor => _petColor.sink.add;
  void Function(int) get changePetTypeIndex => _petTypeIndex.sink.add;
  void Function(int) get changePetAge => _petAge.sink.add;
  void Function(int) get changePetMonths => _petMonths.sink.add;
  void Function(String) get changePetSize => _petSize.sink.add;
  void Function(int) get changePetHealthIndex => _petHealthIndex.sink.add;
  void Function(int) get changePetBreedIndex => _petBreedIndex.sink.add;
  void Function(String) get changePetSex => _petSex.sink.add;
  void Function(List) get changePetSelectedCaracteristics => _petSelectedCaracteristics.sink.add;
  void Function(String) get changePetDescription => _petDescription.sink.add;
  void Function(List) get changePetPhotos => _petPhotos.sink.add;

  // Stream get
  String get getPetName => _petName.value;
  String get getPetColor => _petColor.value;
  int get getPetTypeIndex => _petTypeIndex.value;
  int get getPetAge => _petAge.value;
  int get getPetMonths => _petMonths.value;
  String get getPetSize => _petSize.value;
  int get getPetHealthIndex => _petHealthIndex.value;
  int get getPetBreedIndex => _petBreedIndex.value;
  String get getPetSex => _petSex.value;
  List get getPetSelectedCaracteristics => _petSelectedCaracteristics.value;
  String get getPetDescription => _petDescription.value;
  List get getPetPhotos => _petPhotos.value;

    List<BehaviorSubject> _subjects() {
    return [
      _petName,
      _petColor,
      _petTypeIndex,
      _petAge,
      _petSize,
      _petHealthIndex,
      _petBreedIndex,
      _petSex,
      _petSelectedCaracteristics,
      _petDescription,
      _petPhotos,
    ];
  }

  bool formIsvalid() {
    bool formStatus = true;    

    for (BehaviorSubject subject in _subjects()) {
      if (subject.value == null || subject.value == "") {
        subject.addError("*Campo obrigatório");
        formStatus = false;
      }
    }

    return formStatus;
  }

  @override
  void dispose() {
    _petName.close();
    _petColor.close();
    _petTypeIndex.close();
    _petAge.close();
    _petMonths.close();
    _petSize.close();
    _petHealthIndex.close();
    _petBreedIndex.close();
    _petSex.close();
    _petSelectedCaracteristics.close();
    _petDescription.close();
    super.dispose();
  }
}
