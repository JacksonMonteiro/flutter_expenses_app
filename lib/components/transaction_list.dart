// ignore_for_file: must_be_immutable

import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  List<Transcation> transactions;
  final void Function(String) onRemove;

  TransactionList({
    Key? key,
    required this.transactions,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (transactions.isNotEmpty)
        ? ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tr = transactions[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(6),
                    child: FittedBox(
                        child: Text(
                      'R\$ ${tr.value}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/y').format(tr.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? ElevatedButton.icon(
                          onPressed: () => onRemove(tr.id),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          label: Text(
                            'Excluir',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              )),
                        )
                      : IconButton(
                          onPressed: () => onRemove(tr.id),
                          color: Theme.of(context).errorColor,
                          icon: const Icon(Icons.delete),
                        ),
                ),
              );
            },
          )
        : const Center(
            child: Text(
              'Nenhuma Despesa registrada',
              style: TextStyle(color: Colors.purple, fontSize: 18),
            ),
          );
  }
}
