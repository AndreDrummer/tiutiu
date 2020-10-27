import 'dart:async';

class FormValidator {

  final validateEmpty = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {           
      if (text.isEmpty) {
        sink.addError("* Campo obrigatório.");      
      } else {
        sink.add(text);
      }
    },
  );

  final validatePhotos = StreamTransformer<List, List>.fromHandlers(
    handleData: (photos, sink) {           
      if (photos.isEmpty) {
        sink.addError("* Insira pelo menos uma foto");
      } else {
        sink.add(photos);
      }
    },
  );

  final validateAge = StreamTransformer<int, int>.fromHandlers(
    handleData: (age, sink) {           
      if (age == 0) {
        sink.addError("* Campo obrigatório e diferente de zero");      
      } else {
        sink.add(age);
      }
    },
  );
}