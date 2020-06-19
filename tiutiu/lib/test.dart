import 'package:tiutiu/backend/Database/database.dart';
import './backend/Controller/dog_controller.dart';
import './backend/Model/dog_model.dart';
import 'backend/Controller/user_controller.dart';
import 'backend/Model/user_model.dart';

main() async {  
  DataBaseHandler db = DataBaseHandler.instance;
  if(db != null) {
    await db.initDB();
  }

  Dog dogModel = Dog(
    age: 1,
    breed: 'Viralata',
    details: 'Cachorrin fé da puta',
    id: '1',
    name: 'Fido',
    owner: 'dfgsdgf',
    size: 'Médio'
  );

  User userModel = User(
    id: '2',
    name: 'André Felipe',
    avatar: 'sfsdaasdfasfdsadf',
    email: 'asdf@sadf.asdf',
    password: '21342134',
    whatsapp: '3243245352435243524',
    adopted: 1,
    donated: 1,
    phone: '23453245',
  );

  DogController dog = new DogController();
  UserController user = new UserController();

  await dog.deleteDog('1');
  await dog.insertDog(dogModel);
  await dog.getAllDogs().then((value) {
    print(value[0].name);
  });

  // user.getUser('1');
  // user.deleteUser(userModel.id);

  await user.insertUser(userModel);

  // await user.getUser('2').then((value) => {
  //   value.forEach((element) {
  //     print(element.toJson());
  //   }),
  //   if(value is List) {
  //     print(value)
  //   } else {
  //     print(value.toJson())
  //   }
  // });
}

