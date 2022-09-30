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
      disappeared: map[FilterParamsEnum.disappeared.name],
      state: map[FilterParamsEnum.state.name],
      type: map[FilterParamsEnum.type.name],
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
      FilterParamsEnum.disappeared.name: disappeared,
      FilterParamsEnum.state.name: state,
      FilterParamsEnum.type.name: type,
    };
  }

  @override
  String toString() =>
      'FilterParams(type: $type, state: $state, disappeared: $disappeared)';
}
