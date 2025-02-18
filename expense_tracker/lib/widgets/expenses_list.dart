import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;

  Widget _itemBuilder(BuildContext context, int index) {
    return ExpenseItem(expense: expenses[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: _itemBuilder, itemCount: expenses.length);
  }
}
