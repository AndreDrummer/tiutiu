extension EnumString on Enum {
  String tostring() => this.toString().split('.').last;
}
