import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transcation> recentTransactions;

  const Chart({
    Key? key,
    required this.recentTransactions,
  }) : super(key: key);

  List<Map<String, dynamic>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDays = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDays.day;
        bool sameMonth = recentTransactions[i].date.month == weekDays.month;
        bool sameYear = recentTransactions[i].date.year == weekDays.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransactions[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDays)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValeu {
    return groupedTransactions.fold(
        0.0, (prevE, actE) => prevE + actE['value']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions
              .map((e) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      label: e['day'],
                      value: e['value'],
                      percentage: _weekTotalValeu == 0
                          ? 0
                          : (e['value'] / _weekTotalValeu),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
