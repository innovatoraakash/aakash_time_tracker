import 'dart:async';

import 'dart:io';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '/blocs/projects/bloc.dart';
import '/blocs/settings/settings_bloc.dart';
import '/blocs/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/settings/settings_state.dart';
import '/blocs/theme/theme_bloc.dart';
import '/blocs/timers/bloc.dart';
import '/data_providers/data/data_provider.dart';
import '/data_providers/notifications/notifications_provider.dart';
import '/data_providers/settings/settings_provider.dart';
import '/fontlicenses.dart';
import '/models/theme_type.dart';
import '/screens/dashboard/dashboard_screen.dart';
import '/themes.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

import '/data_providers/data/database_provider.dart';
import '/data_providers/settings/shared_prefs_settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SettingsProvider settings = await SharedPrefsSettingsProvider.load();

  // get a path to the database file
  if (Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final databaseFile = await DatabaseProvider.getDatabaseFile();
  await databaseFile.parent.create(recursive: true);

  final DataProvider data = await DatabaseProvider.open(databaseFile.path);
  final NotificationsProvider notifications =
      await NotificationsProvider.load();
  await runMain(settings, data, notifications);
}

/*import '/data_providers/data/mock_data_provider.dart';
import '/data_providers/settings/mock_settings_provider.dart';
Future<void> main() async {
  final SettingsProvider settings = MockSettingsProvider();
  final DataProvider data = MockDataProvider(Locale.fromSubtags(languageCode: "en"));
  await runMain(settings, data);
}*/

Future<void> runMain(SettingsProvider settings, DataProvider data,
    NotificationsProvider notifications) async {
  // setup intl date formats?
  //await initializeDateFormatting();
  LicenseRegistry.addLicense(getFontLicenses);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(settings),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(settings, data),
      ),
      BlocProvider<TimersBloc>(
        create: (_) => TimersBloc(data, settings),
      ),
      BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(data),
      ),
    ],
    child: TimeTrackerApp(settings: settings),
  ));
}

class TimeTrackerApp extends StatefulWidget {
  final SettingsProvider settings;
  const TimeTrackerApp({Key? key, required this.settings}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeTrackerAppState();
}

class _TimeTrackerAppState extends State<TimeTrackerApp>
    with WidgetsBindingObserver {
  late Timer _updateTimersTimer;
  Brightness? brightness;

  @override
  void initState() {
    _updateTimersTimer = Timer.periodic(const Duration(seconds: 1),
        (_) => BlocProvider.of<TimersBloc>(context).add(const UpdateNow()));
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final timersBloc = BlocProvider.of<TimersBloc>(context);
    settingsBloc.stream.listen((settingsState) => _updateNotificationBadge(
        settingsState, timersBloc.state.countRunningTimers()));
    timersBloc.stream.listen((timersState) => _updateNotificationBadge(
        settingsBloc.state, timersState.countRunningTimers()));

    // send commands to our top-level blocs to get them to initialize
    settingsBloc.add(LoadSettingsFromRepository());
    timersBloc.add(LoadTimers());
    BlocProvider.of<ProjectsBloc>(context).add(LoadProjects());
    BlocProvider.of<ThemeBloc>(context).add(const LoadThemeEvent());
  }

  void _updateNotificationBadge(SettingsState settingsState, int count) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!settingsState.hasAskedNotificationPermissions &&
          !settingsState.showBadgeCounts) {
        // they haven't set the permission yet
        return;
      } else if (settingsState.showBadgeCounts) {
        // need to ask permission
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      } else {
        // remove any and all badges if we disable the option
        FlutterAppBadger.removeBadge();
      }
    }
  }

  @override
  void dispose() {
    _updateTimersTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() => brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }

  ThemeData getTheme(
      ThemeType? type, ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    switch (type) {
      case ThemeType.light:
        return ThemeUtil.lightTheme;
      case ThemeType.dark:
        return ThemeUtil.darkTheme;

      default:
        return brightness == Brightness.dark
            ? ThemeUtil.darkTheme
            : ThemeUtil.lightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SettingsProvider>.value(value: widget.settings),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (BuildContext context, ThemeState themeState) =>
                DynamicColorBuilder(
                  builder:
                      (ColorScheme? lightDynamic, ColorScheme? darkDynamic) =>
                          MaterialApp(
                    title: 'Time Cop',
                    home: const DashboardScreen(),
                    theme:
                        getTheme(themeState.theme, lightDynamic, darkDynamic),
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                  ),
                )));
  }
}
