import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/projects/projects_bloc.dart';
import '/blocs/settings/settings_bloc.dart';
import '/blocs/timers/timers_bloc.dart';
import '/blocs/timers/timers_event.dart';

import '/models/project.dart';
import '/models/timer_entry.dart';
import '/screens/dashboard/components/stopped_timer_row_narrow_simple.dart';
import '/utils/responsiveness_utils.dart';
import '/screens/dashboard/components/stopped_timer_row_narrow_dense.dart';
import '/screens/dashboard/components/stopped_timer_row_wide.dart';

class StoppedTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final bool isWidescreen;
  final bool showProjectName;

  const StoppedTimerRow(
      {Key? key,
      required this.timer,
      required this.isWidescreen,
      required this.showProjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsivenessUtils.isWidescreen(context)
        ? StoppedTimerRowWide(
            timer: timer,
            resumeTimer: _resumeTimer,
            deleteTimer: _deleteTimer,
            showProjectName: showProjectName)
        : BlocProvider.of<SettingsBloc>(context).state.showProjectNames
            ? StoppedTimerRowNarrowDense(
                timer: timer,
                resumeTimer: _resumeTimer,
                deleteTimer: _deleteTimer)
            : StoppedTimerRowNarrowSimple(
                timer: timer,
                resumeTimer: _resumeTimer,
                deleteTimer: _deleteTimer);
  }

  void _resumeTimer(BuildContext context) {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    Project? project = projectsBloc.getProjectByID(timer.projectID);
    if (settingsBloc.state.oneTimerAtATime) {
      timersBloc.add(const StopAllTimers());
    }
    timersBloc
        .add(CreateTimer(description: timer.description, project: project));
  }

  void _deleteTimer(BuildContext context) async {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final bool delete = await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Confirm Delete"),
                  content:
                      const Text("Are you sure you want to delete this timer?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("cancel"),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text("delete"),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ))) ??
        false;
    if (delete) {
      timersBloc.add(DeleteTimer(timer));
    }
  }
}
