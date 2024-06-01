import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/blocs/theme/theme_bloc.dart';

import '/models/theme_type.dart';

class ThemeOptions extends StatelessWidget {
  const ThemeOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ThemeBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme"),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
          bloc: bloc,
          builder: (BuildContext context, ThemeState state) {
            return ListView(
              shrinkWrap: true,
              children: <Widget>[
                RadioListTile<ThemeType>(
                  key: const Key("themeAuto"),
                  title: const Text("Auto"),
                  value: ThemeType.auto,
                  groupValue: state.theme,
                  onChanged: (ThemeType? type) => changeTheme(bloc, type!),
                ),
                RadioListTile<ThemeType>(
                  key: const Key("themeLight"),
                  title: const Text("Light"),
                  value: ThemeType.light,
                  groupValue: state.theme,
                  onChanged: (ThemeType? type) => changeTheme(bloc, type!),
                ),
                RadioListTile<ThemeType>(
                  key: const Key("themeDark"),
                  title: const Text("Dark"),
                  value: ThemeType.dark,
                  groupValue: state.theme,
                  onChanged: (ThemeType? type) => changeTheme(bloc, type!),
                ),
              ],
            );
          }),
    );
  }

  changeTheme(ThemeBloc bloc, ThemeType type) {
    bloc.add(ChangeThemeEvent(type));
  }
}
