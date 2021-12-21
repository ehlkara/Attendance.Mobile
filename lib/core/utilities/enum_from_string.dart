class EnumFromString {
  static T get<T>(List<T> values, String comp) {
    T enumValue;
    values.forEach((item) {
      var enumStrings = item.toString().split(".");
      if (enumStrings.length > 1 && enumStrings[1] == comp) {
        enumValue = item;
      }
    });
    return enumValue;
  }
}
