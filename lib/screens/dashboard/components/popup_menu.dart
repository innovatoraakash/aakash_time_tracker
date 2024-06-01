import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/screens/projects/projects_screen.dart';
import '/screens/reports/reports_screen.dart';
import '/screens/settings/components/theme_options.dart';

enum MenuItem { projects, reports, theme }

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      key: const Key("menuButton"),
      icon: const Icon(FontAwesomeIcons.bars),
      onSelected: (MenuItem item) {
        switch (item) {
          case MenuItem.projects:
            Navigator.of(context).push(MaterialPageRoute<ProjectsScreen>(
              builder: (_) => const ProjectsScreen(),
            ));
            break;
          case MenuItem.reports:
            Navigator.of(context).push(MaterialPageRoute<ReportsScreen>(
              builder: (_) => const ReportsScreen(),
            ));
            break;
          case MenuItem.theme:
            Navigator.of(context).push(MaterialPageRoute<ThemeOptions>(
              builder: (_) => const ThemeOptions(),
            ));
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            key: Key("menuProjects"),
            value: MenuItem.projects,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.layerGroup),
              title: Text("projects"),
            ),
          ),
          const PopupMenuItem(
            key: Key("menuReports"),
            value: MenuItem.reports,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.chartPie),
              title: Text("reports"),
            ),
          ),
          const PopupMenuItem(
            value: MenuItem.theme,
            child: ListTile(
              leading: Icon(FontAwesomeIcons.solidLightbulb),
              title: Text("theme"),
            ),
          ),
        ];
      },
    );
  }
}
