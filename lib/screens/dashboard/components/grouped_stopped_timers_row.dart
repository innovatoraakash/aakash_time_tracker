import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/projects/projects_bloc.dart';
import '/blocs/settings/settings_bloc.dart';
import '/blocs/timers/timers_bloc.dart';
import '/blocs/timers/timers_event.dart';
import '/models/project.dart';
import '/models/timer_entry.dart';
import '/screens/dashboard/components/grouped_stopped_timers_row_narrow_simple.dart';
import '/utils/responsiveness_utils.dart';
import '/screens/dashboard/components/grouped_stopped_timers_row_narrowdense.dart';
import '/screens/dashboard/components/grouped_stopped_timers_rowwide.dart';

class GroupedStoppedTimersRow extends StatelessWidget {
  final List<TimerEntry> timers;
  final bool isWidescreen;
  final bool showProjectName;

  const GroupedStoppedTimersRow(
      {Key? key,
      required this.timers,
      required this.isWidescreen,
      required this.showProjectName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDuration = Duration(
        seconds: timers.fold(
            0,
            (int sum, TimerEntry t) =>
                sum + t.endTime!.difference(t.startTime).inSeconds));
    return ResponsivenessUtils.isWidescreen(context)
        ? GroupedStoppedTimersRowWide(
            showProjectName: showProjectName,
            timers: timers,
            totalDuration: totalDuration,
            resumeTimer: _resumeTimer,
          )
        : BlocProvider.of<SettingsBloc>(context).state.showProjectNames
            ? GroupedStoppedTimersRowNarrowDense(
                timers: timers,
                totalDuration: totalDuration,
                resumeTimer: _resumeTimer,
              )
            : GroupedStoppedTimersRowNarrowSimple(
                timers: timers,
                totalDuration: totalDuration,
                resumeTimer: _resumeTimer,
              );
  }

  void _resumeTimer(BuildContext context) {
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    final projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    Project? project = projectsBloc.getProjectByID(timers.first.projectID);
    if (settingsBloc.state.oneTimerAtATime) {
      timersBloc.add(const StopAllTimers());
    }
    timersBloc.add(CreateTimer(
        description: timers.first.description ?? "", project: project));
  }
}
