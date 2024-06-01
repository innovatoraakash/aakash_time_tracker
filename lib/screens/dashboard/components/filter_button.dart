import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/screens/dashboard/bloc/dashboard_bloc.dart';
import '/screens/dashboard/components/filter_sheet.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<DashboardBloc>(context);
    return IconButton(
      icon: const Icon(FontAwesomeIcons.filter),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => FilterSheet(
          dashboardBloc: bloc,
        ),
      ),
    );
  }
}
