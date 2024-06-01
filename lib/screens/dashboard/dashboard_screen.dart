import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/projects/bloc.dart';
import '/blocs/settings/settings_bloc.dart';
import '/screens/dashboard/bloc/dashboard_bloc.dart';
import '/screens/dashboard/components/description_field.dart';
import '/screens/dashboard/components/project_select_field.dart';
import '/screens/dashboard/components/running_timers.dart';
import '/screens/dashboard/components/start_timer_button.dart';
import '/screens/dashboard/components/stopped_timers.dart';
import '/screens/dashboard/components/top_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final screenBorders = MediaQuery.of(context).padding;

    return BlocProvider<DashboardBloc>(
        create: (_) => DashboardBloc(projectsBloc, settingsBloc),
        child: Scaffold(
          appBar: const TopBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Expanded(
                flex: 1,
                child: StoppedTimers(),
              ),
              const RunningTimers(),
              Material(
                elevation: 8.0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8 + screenBorders.left, 8,
                      8 + screenBorders.right, 8 + screenBorders.bottom),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ProjectSelectField(),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                          child: DescriptionField(),
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        height: 72,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: const StartTimerButton(),
        ));
  }
}
