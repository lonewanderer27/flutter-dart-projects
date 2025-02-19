import 'package:expense_tracker/enums/category.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  // how to add new constructor functions
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    if (expenses.isEmpty) return 0;

    return expenses
        .map((expense) => expense.amount)
        .reduce((prev, next) => prev + next);
  }
}
