enum StateEnum {
  initial,
  cities,
  name,
}

class UFLocation {
  factory UFLocation.fromMap(Map<String, dynamic> map) {
    return UFLocation(
      states: List<State>.from(
        map['states'].map(
          (state) => State.fromMap(state),
        ),
      ),
    );
  }

  UFLocation({required this.states});
  List<State> states;

  Map<String, dynamic> toMap() {
    return {'states': states};
  }
}

class State {
  factory State.fromMap(Map<String, dynamic> map) {
    return State(
      initial: map[StateEnum.initial.name],
      cities: (map[StateEnum.cities.name]),
      name: map[StateEnum.name.name],
    );
  }

  State({
    required this.initial,
    required this.cities,
    required this.name,
  });
  String initial;
  String name;
  List cities;

  Map<String, dynamic> toMap() {
    return {
      StateEnum.initial.name: initial,
      StateEnum.cities.name: cities,
      StateEnum.name.name: name,
    };
  }
}
