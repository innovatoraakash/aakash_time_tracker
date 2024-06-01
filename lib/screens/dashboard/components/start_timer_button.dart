import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/blocs/settings/settings_bloc.dart';
import '/blocs/settings/settings_state.dart';
import '/blocs/timers/bloc.dart';

import '/screens/dashboard/bloc/dashboard_bloc.dart';
import '/screens/dashboard/components/start_timer_speed_dial.dart';

class StartTimerButton extends StatefulWidget {
  const StartTimerButton({Key? key}) : super(key: key);

  @override
  State<StartTimerButton> createState() => _StartTimerButtonState();
}

class _StartTimerButtonState extends State<StartTimerButton> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState settingsState) {
      return BlocBuilder<TimersBloc, TimersState>(
          builder: (BuildContext context, TimersState timersState) {
        if (timersState.timers.where((t) => t.endTime == null).isEmpty) {
          return FloatingActionButton(
            key: const Key("startTimerButton"),
            onPressed: () {
              final timers = BlocProvider.of<TimersBloc>(context);
              timers.add(CreateTimer(
                  description: bloc.state.newDescription,
                  project: bloc.state.newProject));
              bloc.add(const TimerWasStartedEvent());
            },
            child: const Stack(
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 18,
                  child: Icon(FontAwesomeIcons.play),
                )
              ],
            ),
          );
        } else if (settingsState.oneTimerAtATime &&
            timersState.timers.where((t) => t.endTime == null).length == 1) {
          return FloatingActionButton(
            key: const Key("stopAllTimersButton"),
            backgroundColor: Colors.pink[600],
            foregroundColor: Colors.white,
            onPressed: () {
              final timers = BlocProvider.of<TimersBloc>(context);
              timers.add(const StopAllTimers());
            },
            child: const Stack(
              // shenanigans to properly centre the icon (font awesome glyphs are variable
              // width but the library currently doesn't deal with that)
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  top: 15,
                  left: 16,
                  child: Icon(FontAwesomeIcons.stop),
                )
              ],
            ),
          );
        } else {
          return const StartTimerSpeedDial();
        }
      });
    });
  }
}
