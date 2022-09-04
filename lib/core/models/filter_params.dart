import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'dart:convert';

enum FilterParamsEnum {
  type,
}

class FilterParams {
  factory FilterParams.fromJson(String source) =>
      FilterParams.fromMap(json.decode(source) as Map<String, dynamic>);

  factory FilterParams.fromMap(Map<String, dynamic> map) {
    return FilterParams(
      type: map[FilterParamsEnum.type.tostring()] as String,
    );
  }
  FilterParams({
    required this.type,
  });

  final String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FilterParamsEnum.type.tostring(): type,
    };
  }

  @override
  String toString() => 'FilterParams(type: $type)';
}
