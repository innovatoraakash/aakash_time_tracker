import 'package:flutter/material.dart';
import '/components/project_colour.dart';

import '/models/project.dart';

class Legend extends StatelessWidget {
  final Iterable<Project?> projects;

  const Legend({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (projects.length <= 5) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 4.0,
        children:
            projects.map((project) => _LegendChip(project: project)).toList(),
      );
    }
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children:
            projects.map((project) => _LegendChip(project: project)).toList(),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Project? project;

  const _LegendChip({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: ProjectColour(project: project, mini: true),
      label: Text(project?.name ?? "(no project)",
          style: theme.textTheme.bodySmall),
    );
  }
}
