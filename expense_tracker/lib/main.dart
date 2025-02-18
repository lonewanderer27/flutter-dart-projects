import 'package:expense_tracker/data/expenses_data.dart';
import 'package:expense_tracker/widgets/expenses_chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                ExpensesChart(expenses: expensesData),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: ExpensesList(expenses: expensesData))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
