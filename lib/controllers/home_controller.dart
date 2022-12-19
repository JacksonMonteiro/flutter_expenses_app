import 'dart:math';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class HomeController {
  ValueNotifier<List<Transacation>> transactions = ValueNotifier<List<Transacation>>([]);

  List<Transacation> get recentTransactions {
    return transactions.value.where((e) {
      return e.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }
  
  void addTransaction(BuildContext context, String title, double value, DateTime date) {
    final newTransaction = Transacation(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    
    transactions.value.add(newTransaction);

    Navigator.of(context).pop();
  }

  void deleteTransaction(String id) {
    transactions.value.removeWhere((element) => element.id == id);
  }
}
