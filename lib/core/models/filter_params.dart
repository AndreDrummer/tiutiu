import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'dart:convert';

enum FilterParamsEnum {
  disappeared,
  state,
  type,
}

class FilterParams {
  factory FilterParams.fromJson(String source) =>
      FilterParams.fromMap(json.decode(source) as Map<String, dynamic>);

  factory FilterParams.fromMap(Map<String, dynamic> map) {
    return FilterParams(
      disappeared: map[FilterParamsEnum.disappeared.tostring()],
      state: map[FilterParamsEnum.state.tostring()],
      type: map[FilterParamsEnum.type.tostring()],
    );
  }
  FilterParams({
    required this.disappeared,
    required this.state,
    required this.type,
  });

  final bool disappeared;
  final String state;
  final String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FilterParamsEnum.disappeared.tostring(): disappeared,
      FilterParamsEnum.state.tostring(): state,
      FilterParamsEnum.type.tostring(): type,
    };
  }

  @override
  String toString() =>
      'FilterParams(type: $type, state: $state, disappeared: $disappeared)';
}
