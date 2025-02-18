import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpensesChart extends StatelessWidget {
  const ExpensesChart({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Bar Chart')],
    );
  }
}
