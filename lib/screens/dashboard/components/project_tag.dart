import 'package:flutter/material.dart';
import '/components/project_colour.dart';

import '/models/project.dart';
import '/themes.dart';

class ProjectTag extends StatelessWidget {
  final Project? project;

  const ProjectTag({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ProjectColour(mini: true, project: project),
      const SizedBox(width: 6),
      Text(
        project?.name ?? "(no project)",
        style: theme.textTheme.bodyMedium?.copyWith(
            color: project == null
                ? ThemeUtil.getOnBackgroundLighter(context)
                : theme.colorScheme.onBackground),
      )
    ]);
  }
}
