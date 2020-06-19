import 'package:tiutiu/backend/Database/database.dart';
// import './backend/Controller/dog_controller.dart';
import './backend/Controller/user_controller.dart';
// import './backend/Model/dog_model.dart';
import './backend/Model/user_model.dart';
import './backend/Provider/connection_provider.dart';

main() async {  
  DataBaseHandler db = DataBaseHandler.instance;
  if(db != null) {
    await db.initDB();
  }
  
  ConnectionStatusSingleton internetConection = ConnectionStatusSingleton.getInstance();
  internetConection.initialize();
  

  // Dog dogModel = Dog(
  //   age: 5,
  //   breed: 'Maltês',
  //   details: 'Cão de raça',
  //   id: '2',
  //   name: 'GALINHA',
  //   owner: 'Cara ai',
  //   size: 'Grande'
  // );

  User userModel = User(
    id: 'ZZwzsbC9NlW7pqGCo1QP',
    name: 'André JOÃO',
    avatar: 'sfsdaasdfasfdsadf',
    email: 'asdf@sadf.asdf',
    password: '21342134',
    whatsapp: '3243245352435243524',
    adopted: 1,
    donated: 1,
    phone: '23453245',
  );

  // DogController dog = new DogController();

  // await dog.getDog('2').then((dog) { OK
  //   print(dog);
  // });

  // await dog.deleteDog('1'); OK
  // await dog.updateDog(dogModel); OK
  // await dog.insertDog(dogModel); OK
  // await dog.getAllDogs().then((value) { OK
  //   print(internetConection.hasConnection);
  //   print(value[0].name);
  // });



  UserController user = new UserController();

  // await user.insertUser(userModel); OK

  // await user.getUser('ZZwzsbC9NlW7pqGCo1QP').then((value) => print(value.name)); OK
  // await user.updateUser(userModel); OK 
  // await user.deleteUser(userModel.id); OK

  
}

