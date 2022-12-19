import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/controllers/home_controller.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Controller
  final HomeController _controller = HomeController();

  // Variables
  bool _showChart = false;

  // Delete Expense Method
  _delTransaction(String id) {
    setState(() {
      _controller.deleteTransaction(id);
    });
  }

  // UI Methods
  _openTransactionModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) => TransactionForm(onSubmit: _controller.addTransaction));
  }

  _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(onPressed: fn, icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    final mQuery = MediaQuery.of(context);

    bool isLandscape = mQuery.orientation == Orientation.landscape;

    final actions = [
      if (isLandscape)
        _getIconButton(
          _showChart
              ? (Platform.isIOS ? CupertinoIcons.list_bullet : Icons.list)
              : (Platform.isIOS
                  ? CupertinoIcons.chart_pie_fill
                  : Icons.pie_chart),
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionModal(context),
      ),
    ];

    final appBar = AppBar(
      title: const Text('Despesas Pessoais'),
      actions: [...actions],
    );

    final availableHeight =
        mQuery.size.height - appBar.preferredSize.height - mQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_showChart || !isLandscape)
                SizedBox(
                    height: availableHeight * (isLandscape ? 0.75 : 0.3),
                    child: Chart(recentTransactions: _controller.recentTransactions)),
              if (!_showChart || !isLandscape)
                SizedBox(
                  height: availableHeight * 0.7,
                  child: TransactionList(
                    transactions: _controller.transactions.value,
                      onRemove: _delTransaction),
                ),
            ],
          ),
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [...actions],
              ),
            ),
            child: bodyPage)
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionModal(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
