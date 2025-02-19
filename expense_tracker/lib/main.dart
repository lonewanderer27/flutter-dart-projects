import 'package:expense_tracker/widgets/modals/expenses_modal.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/theme/colorScheme.dart';
import 'package:expense_tracker/theme/theme.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ExpenseTrackerApp(),
    theme: theme,
    darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
  ));
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  final List<Expense> _expenses = [];

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _removeExpense(String id, int index) {
    // store our removed expense temporarily
    var removedExpense = _expenses.singleWhere((exp) => exp.id == id);

    setState(() {
      _expenses.removeWhere((exp) => exp.id == id);
    });

    // show the snackbar
    // if the user wants to bring back the removed expense, add it here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted'),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(index, removedExpense);
            });
          }),
    ));
  }

  void _openAddExpenseModal() {
    // Flutter automatically adds a global context variable
    // that's why we can access this even though it's below.
    // We rename builder context as ctx as to not clash
    // with the global context variable.
    showModalBottomSheet(
        // make our bottom sheet fullscreen
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ExpensesModal(
              addExpense: _addExpense,
            ));
  }

  @override
  Widget build(BuildContext context) {
    // if there's no expenses at all.
    // show the empty message as mainContent

    // otherwise, get the current width
    // if it's wide enough, use the row layout
    // else, use the default column.

    var width = MediaQuery.of(context).size.width;

    Widget emptyMessage = Center(
      child: Text(
        'No expenses found. Start adding some!',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseModal, icon: const Icon(Icons.add))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: _expenses.isEmpty
            ? emptyMessage
            : width > 600
                ? Row(
                    children: [
                      Expanded(child: Chart(expenses: _expenses)),
                      SizedBox(
                          // if width is greater than 600, we're in a row layout
                          // therefore we need to set the width
                          // width: 5,
                          // otherwise if it's smaller, then we're in default column layout
                          // therefore we need to set the height
                          height: 5),
                      Expanded(
                          child: ExpensesList(
                        expenses: _expenses,
                        removeExpense: _removeExpense,
                      ))
                    ],
                  )
                : Column(
                    children: [
                      Chart(expenses: _expenses),
                      SizedBox(
                          // if width is greater than 600, we're in a row layout
                          // therefore we need to set the width
                          // width: 5,
                          // otherwise if it's smaller, then we're in default column layout
                          // therefore we need to set the height
                          height: 5),
                      Expanded(
                          child: ExpensesList(
                        expenses: _expenses,
                        removeExpense: _removeExpense,
                      ))
                    ],
                  ),
      ),
    );
  }
}
