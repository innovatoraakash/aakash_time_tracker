import 'package:flutter/material.dart';
import '/components/project_colour.dart';

import '/models/project.dart';

class ProjectTile extends StatelessWidget {
  final Iterable<Project> projects;
  final Function(Project? project) isEnabled;
  final Function(Project? project) onToggled;
  final Function() onAllSelected;
  final Function() onNoneSelected;

  const ProjectTile(
      {super.key,
      required this.projects,
      required this.isEnabled,
      required this.onToggled,
      required this.onAllSelected,
      required this.onNoneSelected});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Projects",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700)),
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ElevatedButton(
              onPressed: onNoneSelected,
              child: const Text("Select None"),
            ),
            ElevatedButton(
              onPressed: onAllSelected,
              child: const Text("Select All"),
            ),
          ],
        ),
      ]
          .followedBy(<Project?>[null]
              .followedBy(projects)
              .map((project) => CheckboxListTile(
                    secondary: ProjectColour(
                      project: project,
                    ),
                    title: Text(project?.name ?? "No Project"),
                    value: isEnabled(project),
                    onChanged: (_) => onToggled(project),
                  )))
          .toList(),
    );
  }
}
