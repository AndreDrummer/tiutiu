import 'package:tiutiu/backend/Database/database.dart';
import './backend/Controller/dog_controller.dart';
import './backend/Model/dog_model.dart';
import 'backend/Controller/user_controller.dart';
import 'backend/Model/user_model.dart';

import './backend/Provider/connection_provider.dart';

main() async {  
  DataBaseHandler db = DataBaseHandler.instance;
  if(db != null) {
    await db.initDB();
  }
  
  ConnectionStatusSingleton internetConection = ConnectionStatusSingleton.getInstance();
  internetConection.initialize();
  

  Dog dogModel = Dog(
    age: 5,
    breed: 'Maltês',
    details: 'Cão de raça',
    id: '2',
    name: 'GALINHA',
    owner: 'Cara ai',
    size: 'Grande'
  );

  // User userModel = User(
  //   id: '2',
  //   name: 'André Felipe',
  //   avatar: 'sfsdaasdfasfdsadf',
  //   email: 'asdf@sadf.asdf',
  //   password: '21342134',
  //   whatsapp: '3243245352435243524',
  //   adopted: 1,
  //   donated: 1,
  //   phone: '23453245',
  // );

  DogController dog = new DogController();

  // await dog.getDog('2').then((dog) { OK
  //   print(dog);
  // });

  // await dog.deleteDog('1'); OK
  await dog.updateDog(dogModel); 
  // await dog.insertDog(dogModel); OK
  // await dog.getAllDogs().then((value) { OK
  //   print(internetConection.hasConnection);
  //   print(value[0].name);
  // });



  // UserController user = new UserController();

  // user.getUser('1');
  // user.deleteUser(userModel.id);

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

