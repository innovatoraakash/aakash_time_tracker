import 'package:flutter/cupertino.dart';

enum ThemeType {
  auto,
  light,
  dark;

  String? get stringify {
    switch (this) {
      case ThemeType.auto:
        return "auto";
      case ThemeType.light:
        return "light";
      case ThemeType.dark:
        return "dark";
    }
  }

  String? display(BuildContext context) {
    switch (this) {
      case ThemeType.auto:
        return "auto";
      case ThemeType.light:
        return "light";
      case ThemeType.dark:
        return "dark";

      default:
        return null;
    }
  }

  static ThemeType fromString(String? type) {
    if (type == null) return ThemeType.auto;
    switch (type) {
      case "auto":
        return ThemeType.auto;
      case "light":
        return ThemeType.light;
      case "dark":
        return ThemeType.dark;

      default:
        return ThemeType.auto;
    }
  }
}
