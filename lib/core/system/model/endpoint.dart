import 'package:cloud_firestore/cloud_firestore.dart';

enum EndpointEnum {
  example,
  type,
  name,
  path,
  id,
}

enum EndpointTypeEnum {
  collection,
  doc,
}

class Endpoint {
  Endpoint({
    required this.example,
    required this.type,
    required this.name,
    required this.path,
    required this.id,
  });

  factory Endpoint.fromSnapshot(DocumentSnapshot snapshot) {
    return Endpoint(
      example: snapshot.get(EndpointEnum.example.name),
      type: snapshot.get(EndpointEnum.type.name),
      name: snapshot.get(EndpointEnum.name.name),
      path: snapshot.get(EndpointEnum.path.name),
      id: snapshot.id,
    );
  }

  String example;
  String type;
  String name;
  String path;
  String id;

  Map<String, dynamic> toMap() {
    return {
      EndpointEnum.example.name: example,
      EndpointEnum.type.name: type,
      EndpointEnum.name.name: name,
      EndpointEnum.path.name: path,
      EndpointEnum.id.name: id,
    };
  }

  @override
  String toString() {
    return 'Endpoint(example: $example, type: $type, name: $name, id: $id, path: $path)';
  }
}
