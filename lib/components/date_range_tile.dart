import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '/blocs/settings/settings_bloc.dart';

import '/utils/clone_time_extension.dart';
import '/models/filter_preset.dart';

class DateRangeTile extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  final Function(DateTime?) onStartChosen;
  final Function(DateTime?) onEndChosen;
  final bool initiallyExpanded;

  const DateRangeTile(
      //todo change label to date range
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.onStartChosen,
      required this.onEndChosen,
      this.initiallyExpanded = true});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMEd();
    final defaultFilterDays =
        BlocProvider.of<SettingsBloc>(context).getDefaultFilterDays();
    return ExpansionTile(
      title: Text("Filter",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700)),
      initiallyExpanded: initiallyExpanded,
      children: <Widget>[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
                children: FilterPreset.values
                    .map((fp) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ActionChip(
                          label: Text(fp.display(context, defaultFilterDays)),
                          onPressed: () {
                            onStartChosen(fp.getStartDate(
                                MaterialLocalizations.of(context)
                                    .firstDayOfWeekIndex,
                                defaultFilterDays));
                            onEndChosen(fp.getEndDate());
                          },
                        )))
                    .toList())),
        ListTile(
          leading: const Icon(FontAwesomeIcons.calendar),
          title: const Text("from"),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            startDate == null
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text("--"),
                  )
                : Text(dateFormat.format(startDate!)),
            if (startDate != null)
              IconButton(
                tooltip: "remove",
                icon: const Icon(FontAwesomeIcons.circleMinus),
                onPressed: () => onStartChosen(null),
              )
          ]),
          onTap: () async {
            final oldStartDate = startDate?.clone();
            await dt.DatePicker.showDatePicker(context,
                currentTime: startDate,
                onCancel: () => onStartChosen(oldStartDate),
                onChanged: (dt) =>
                    onStartChosen(DateTime(dt.year, dt.month, dt.day)),
                onConfirm: (dt) =>
                    onStartChosen(DateTime(dt.year, dt.month, dt.day)),
                theme: dt.DatePickerTheme(
                  cancelStyle: Theme.of(context).textTheme.labelLarge!,
                  doneStyle: Theme.of(context).textTheme.labelLarge!,
                  itemStyle: Theme.of(context).textTheme.bodyMedium!,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ));
          },
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.calendar),
          title: const Text("to"),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            endDate == null
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text("--"),
                  )
                : Text(dateFormat.format(endDate!)),
            if (endDate != null)
              IconButton(
                tooltip: "remove",
                icon: const Icon(FontAwesomeIcons.circleMinus),
                onPressed: () => onEndChosen(null),
              )
          ]),
          onTap: () async {
            final oldStartDate = endDate?.clone();
            await dt.DatePicker.showDatePicker(context,
                currentTime: endDate,
                onCancel: () => onEndChosen(oldStartDate),
                onChanged: (dt) => onEndChosen(
                    DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                onConfirm: (dt) => onEndChosen(
                    DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 999)),
                theme: dt.DatePickerTheme(
                  cancelStyle: Theme.of(context).textTheme.labelLarge!,
                  doneStyle: Theme.of(context).textTheme.labelLarge!,
                  itemStyle: Theme.of(context).textTheme.bodyMedium!,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ));
          },
        ),
      ],
    );
  }
}
