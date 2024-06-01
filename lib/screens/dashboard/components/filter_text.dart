import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterText extends StatelessWidget {
  final DateTime? filterStart;
  final DateTime? filterEnd;
  const FilterText({Key? key, this.filterStart, this.filterEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    if (filterStart == null && filterEnd == null) return const SizedBox();

    final filterString = (filterStart == null)
        ? "Until ${dateFormat.format(filterEnd!)}"
        : (filterEnd == null)
            ? "From ${dateFormat.format(filterStart!)}"
            : "From${dateFormat.format(filterStart!)} Until ${dateFormat.format(filterEnd!)}";

    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Center(
            child: Text(
          filterString,
          style: Theme.of(context).textTheme.bodySmall,
        )));
  }
}
