import 'package:expense_tracker/widgets/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final void Function(String id, int index) removeExpense;
  const ExpensesList(
      {super.key, required this.expenses, required this.removeExpense});

  final List<Expense> expenses;

  Widget _itemBuilder(BuildContext context, int index) {
    return Dismissible(
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context).colorScheme.error,
          ),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          child: Center(
            child: Text(
              'Delete',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        key: Key(expenses[index].id),
        child: ExpenseItem(expense: expenses[index]),
        onDismissed: (direction) {
          removeExpense(expenses[index].id, index);
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: _itemBuilder, itemCount: expenses.length);
  }
}
