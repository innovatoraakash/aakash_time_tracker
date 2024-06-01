import 'package:flutter/material.dart';

import '/themes.dart';

class TimerUtils {
  static String formatDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return "no description";
    }
    return description;
  }

  static TextStyle styleDescription(BuildContext context, String? description) {
    if (description == null || description.trim().isEmpty) {
      return Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: ThemeUtil.getOnBackgroundLighter(context));
    } else {
      return Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Theme.of(context).colorScheme.onBackground);
    }
  }
}
