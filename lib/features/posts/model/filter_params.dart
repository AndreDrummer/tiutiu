import 'dart:convert';

enum FilterParamsEnum {
  disappeared,
  orderBy,
  state,
  type,
  name,
}

class FilterParams {
  factory FilterParams.fromJson(String source) =>
      FilterParams.fromMap(json.decode(source) as Map<String, dynamic>);

  factory FilterParams.fromMap(Map<String, dynamic> map) {
    return FilterParams(
      disappeared: map[FilterParamsEnum.disappeared.name],
      orderBy: map[FilterParamsEnum.orderBy.name],
      state: map[FilterParamsEnum.state.name],
      name: map[FilterParamsEnum.name.name],
      type: map[FilterParamsEnum.type.name],
    );
  }
  FilterParams({
    required this.disappeared,
    required this.orderBy,
    required this.state,
    required this.type,
    required this.name,
  });

  final bool disappeared;
  final String orderBy;
  final String state;
  final String name;
  final String type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FilterParamsEnum.disappeared.name: disappeared,
      FilterParamsEnum.orderBy.name: orderBy,
      FilterParamsEnum.state.name: state,
      FilterParamsEnum.name.name: name,
      FilterParamsEnum.type.name: type,
    };
  }

  @override
  String toString() =>
      'FilterParams(type: $type, state: $state, disappeared: $disappeared, name: $name, orderBy: $orderBy)';
}
