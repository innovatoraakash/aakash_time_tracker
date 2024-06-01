import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:time_tracker/blocs/timers/bloc.dart';
import '/blocs/timers/timers_bloc.dart';
import '/blocs/timers/timers_event.dart';
import '/models/timer_entry.dart';

import '/screens/dashboard/bloc/dashboard_bloc.dart';
import '/screens/dashboard/components/filter_button.dart';
import '/screens/dashboard/components/popup_menu.dart';
import '/screens/timer/timer_editor.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late bool _searching;

  final _searchFormKey = GlobalKey<FormState>();
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searching = false;
    _searchFocusNode = FocusNode(debugLabel: "search-focus");
    _searchController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void cancelSearch() {
    setState(() => _searching = false);
    final bloc = BlocProvider.of<DashboardBloc>(context);
    bloc.add(const SearchChangedEvent(null));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    return AppBar(
        leading: _searching
            ? IconButton(
                icon: const Icon(FontAwesomeIcons.chevronLeft),
                onPressed: cancelSearch,
              )
            : const PopupMenu(),
        title: _searching
            ? _SearchBar(
                cancelSearch: cancelSearch,
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                searchFormKey: _searchFormKey,
              )
            : const Text("Aakash Tracker"),
        actions: !_searching
            ? <Widget>[
                IconButton(
                  icon: const Icon(FontAwesomeIcons.magnifyingGlass),
                  onPressed: () {
                    _searchController.text = "";
                    bloc.add(const SearchChangedEvent(""));
                    setState(() => _searching = true);
                    _searchFocusNode.requestFocus();
                  },
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.plus),
                  onPressed: () async {
                    final timers = BlocProvider.of<TimersBloc>(context);
                    TimerEntry timer = TimerEntry.clone(
                      await timers.data.createTimer(description: ""),
                      startTime: DateTime.now().add(const Duration(hours: 1)),
                      endTime: DateTime.now().add(const Duration(hours: 2)),
                    );

                    timers.add(AddTimer(timer));

                    Navigator.of(context).push(MaterialPageRoute<AddNewTimer>(
                      builder: (BuildContext context) => AddNewTimer(
                        timer: timer,
                      ),
                      fullscreenDialog: true,
                    ));
                  },
                ),
                const FilterButton(),
              ]
            : <Widget>[]);
  }
}

class _SearchBar extends StatelessWidget {
  final Function() cancelSearch;
  final GlobalKey<FormState> searchFormKey;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  const _SearchBar(
      {required this.cancelSearch,
      required this.searchFormKey,
      required this.searchController,
      required this.searchFocusNode});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);

    return Form(
        key: searchFormKey,
        child: TextFormField(
          focusNode: searchFocusNode,
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          style: Theme.of(context)
              .primaryTextTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).appBarTheme.foregroundColor),
          onChanged: (search) {
            bloc.add(SearchChangedEvent(search));
          },
          decoration: InputDecoration(
              prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                  color: Theme.of(context).appBarTheme.foregroundColor),
              suffixIcon: IconButton(
                color: Theme.of(context).appBarTheme.foregroundColor,
                icon: const Icon(FontAwesomeIcons.circleXmark),
                onPressed: cancelSearch,
              )),
        ));
  }
}
