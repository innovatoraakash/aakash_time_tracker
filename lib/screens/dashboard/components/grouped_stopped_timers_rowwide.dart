import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '/blocs/projects/bloc.dart';
import '/components/project_colour.dart';

import '/models/timer_entry.dart';
import '/screens/dashboard/components/project_tag.dart';
import '/screens/dashboard/components/row_separator.dart';
import '/screens/dashboard/components/stopped_timer_row.dart';
import '/themes.dart';

import '/utils/timer_utils.dart';

class GroupedStoppedTimersRowWide extends StatefulWidget {
  final List<TimerEntry> timers;
  final Function(BuildContext) resumeTimer;
  final Duration totalDuration;
  final bool showProjectName;

  const GroupedStoppedTimersRowWide(
      {Key? key,
      required this.totalDuration,
      required this.timers,
      required this.resumeTimer,
      required this.showProjectName})
      : assert(timers.length > 1),
        super(key: key);

  @override
  State<GroupedStoppedTimersRowWide> createState() =>
      _GroupedStoppedTimersRowWideState();
}

class _GroupedStoppedTimersRowWideState
    extends State<GroupedStoppedTimersRowWide>
    with SingleTickerProviderStateMixin {
  static const _spaceWidth = 16.0;
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: -0.5);

  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _expanded = false;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.timers.last.endTime != null);
    final theme = Theme.of(context);

    final timeFormat = DateFormat.jm();
    final timeSpanStyle = theme.textTheme.bodyMedium?.copyWith(
      color: ThemeUtil.getOnBackgroundLighter(context),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final project = BlocProvider.of<ProjectsBloc>(context)
        .getProjectByID(widget.timers[0].projectID);
    return ExpansionTile(
      onExpansionChanged: (expanded) {
        setState(() {
          _expanded = expanded;
          if (_expanded) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        });
      },
      leading: widget.showProjectName ? null : ProjectColour(project: project),
      title: widget.showProjectName
          ? Row(children: [
              Flexible(
                  child: Text(
                      TimerUtils.formatDescription(
                          context, widget.timers[0].description),
                      style: TimerUtils.styleDescription(
                          context, widget.timers[0].description))),
              const SizedBox(width: _spaceWidth),
              ProjectTag(project: project)
            ])
          : Text(
              TimerUtils.formatDescription(
                  context, widget.timers[0].description),
              style: TimerUtils.styleDescription(
                  context, widget.timers[0].description)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: _spaceWidth),
          Text(
            timeFormat.format(widget.timers.last.startTime),
            style: timeSpanStyle,
          ),
          const SizedBox(
            width: _spaceWidth,
          ),
          const Text("-"),
          const SizedBox(
            width: _spaceWidth,
          ),
          Text(
            timeFormat.format(widget.timers.first.endTime!),
            style: timeSpanStyle,
          ),
          if (widget.totalDuration.inDays > 0)
            Transform.translate(
              offset: const Offset(2, -4),
              child: Text(
                "+${widget.totalDuration.inDays}",
                textScaler: const TextScaler.linear(0.8),
                style: timeSpanStyle,
              ),
            ),
          const SizedBox(width: _spaceWidth),
          const RowSeparator(),
          const SizedBox(width: _spaceWidth),
          Container(
            alignment: Alignment.centerRight,
            width: 80,
            child: Text(
              TimerEntry.formatDuration(widget.totalDuration),
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(width: _spaceWidth),
          const RowSeparator(),
          const SizedBox(width: _spaceWidth + 8),
          RotationTransition(
            turns: _iconTurns,
            child: const Icon(
              Icons.expand_more,
            ),
          ),
          const SizedBox(width: _spaceWidth + 8),
          IconButton(
            icon: const Icon(FontAwesomeIcons.circlePlay),
            onPressed: () => widget.resumeTimer(context),
          ),
        ],
      ),
      children: widget.timers
          .map((timer) => StoppedTimerRow(
              timer: timer,
              isWidescreen: true,
              showProjectName: widget.showProjectName))
          .toList(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
