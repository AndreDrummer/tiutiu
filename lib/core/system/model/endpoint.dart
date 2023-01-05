import 'package:cloud_firestore/cloud_firestore.dart';

enum EndpointEnum {
  example,
  type,
  name,
  path,
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
  });

  factory Endpoint.fromSnapshot(DocumentSnapshot snapshot) {
    return Endpoint(
      example: snapshot.get(EndpointEnum.example.name),
      type: snapshot.get(EndpointEnum.type.name),
      name: snapshot.get(EndpointEnum.name.name),
      path: snapshot.get(EndpointEnum.path.name),
    );
  }

  factory Endpoint.fromMap(Map<String, dynamic> map) {
    return Endpoint(
      example: map[EndpointEnum.example.name],
      type: map[EndpointEnum.type.name],
      name: map[EndpointEnum.name.name],
      path: map[EndpointEnum.path.name],
    );
  }

  Endpoint copyWith({
    String? example,
    String? type,
    String? name,
    String? path,
  }) {
    return Endpoint(
      example: example ?? this.example,
      type: type ?? this.type,
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }

  String example;
  String type;
  String name;
  String path;

  Map<String, dynamic> toMap() {
    return {
      EndpointEnum.example.name: example,
      EndpointEnum.type.name: type,
      EndpointEnum.name.name: name,
      EndpointEnum.path.name: path,
    };
  }

  @override
  String toString() {
    return 'Endpoint(example: $example, type: $type, name: $name, path: $path)';
  }
}
