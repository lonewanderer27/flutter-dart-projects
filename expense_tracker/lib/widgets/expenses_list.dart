import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final void Function(String id) removeExpense;
  const ExpensesList(
      {super.key, required this.expenses, required this.removeExpense});

  final List<Expense> expenses;

  Widget _itemBuilder(BuildContext context, int index) {
    return Dismissible(
        key: Key(expenses[index].id),
        child: ExpenseItem(expense: expenses[index]),
        onDismissed: (direction) {
          removeExpense(expenses[index].id);
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: _itemBuilder, itemCount: expenses.length);
  }
}
