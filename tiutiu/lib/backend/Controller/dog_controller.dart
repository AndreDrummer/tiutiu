import '../Database/database.dart';
import '../Model/dog_model.dart';

class DogController {
  DataBaseHandler db = DataBaseHandler.instance;
  
  Future getDog(String id) async {
    List<Map<String, dynamic>> map = await db.getById('Dog', id);    

    if (map.isNotEmpty) {
      Dog dog = Dog(
        id: map[0]['id'],
        name: map[0]['name'],
        age: map[0]['age'],
        breed: map[0]['breed'],
        details: map[0]['details'],
        size: map[0]['size'],
        owner: map[0]['owner'],
      );
      return dog;
    }

    return [];
  }

  Future<List<Dog>> getAllDogs() async {
    List<Map<String, dynamic>> dogList = await db.getAll('Dog');

    return List.generate(
      dogList.length,
      (i) {
        return Dog(
            id: dogList[i]['id'],
            name: dogList[i]['name'],
            age: dogList[i]['age'],
            breed: dogList[i]['breed'],
            details: dogList[i]['details'],
            owner: dogList[i]['owner'].toString(),
            size: dogList[i]['size']);
      },
    );
  }

  Future<void> insertDog(Dog dog) async {
    await db.insert('Dog', dog);
  }

  Future<void> updateDog(Dog dog) async {
    await db.update('Dog', dog);
  }

  Future<void> deleteDog(String id) async {
    await db.delete('Dog', id);
  }
}
