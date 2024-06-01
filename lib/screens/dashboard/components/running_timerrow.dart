import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/blocs/projects/bloc.dart';
import '/blocs/timers/bloc.dart';
import '/components/project_colour.dart';

import '/models/timer_entry.dart';
import '/screens/timer/timer_editor.dart';
import '/utils/timer_utils.dart';

class RunningTimerRow extends StatelessWidget {
  final TimerEntry timer;
  final DateTime now;

  const RunningTimerRow({Key? key, required this.timer, required this.now})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
      startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.15,
          children: <Widget>[
            SlidableAction(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: FontAwesomeIcons.trash,
              onPressed: (_) async {
                final timersBloc = BlocProvider.of<TimersBloc>(context);
                final bool delete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text(
                                  "Are you sure you want to delete this timer?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("cancel"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text("delete"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            )) ??
                    false;
                if (delete == true) {
                  timersBloc.add(DeleteTimer(timer));
                }
              },
            )
          ]),
      child: ListTile(
          leading: ProjectColour(
              project: BlocProvider.of<ProjectsBloc>(context)
                  .getProjectByID(timer.projectID)),
          title: Text(TimerUtils.formatDescription(context, timer.description),
              style: TimerUtils.styleDescription(context, timer.description)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(timer.formatTime(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                )),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(FontAwesomeIcons.solidCircleStop),
              onPressed: () {
                final timers = BlocProvider.of<TimersBloc>(context);
                timers.add(StopTimer(timer));
              },
            ),
          ]),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute<TimerEditor>(
                builder: (BuildContext context) => TimerEditor(
                  timer: timer,
                ),
                fullscreenDialog: true,
              ))),
    );
  }
}
