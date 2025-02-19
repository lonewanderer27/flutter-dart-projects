import 'package:expense_tracker/enums/category.dart';
import 'package:expense_tracker/widgets/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesModal extends StatefulWidget {
  final void Function(Expense expense) addExpense;

  const ExpensesModal({super.key, required this.addExpense});

  @override
  State<ExpensesModal> createState() => _ExpensesModalState();
}

class _ExpensesModalState extends State<ExpensesModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _dateStr;
  DateTime? _dateTime;
  Category _category = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _close() {
    Navigator.pop(context);
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    if (pickedDate == null) return;

    // set the picked date
    setState(() {
      // update the string date format for our custom indicator
      _dateStr = DateFormat('MMMM d, y').format(pickedDate);
      _dateTime = pickedDate;
    });
  }

  void _submitExpense() {
    final enteredAmt = double.tryParse(_amountController.text);

    // check entered amount
    final amountInvalid = enteredAmt == null || enteredAmt <= 0;

    // check title
    final titleInvalid = _titleController.text.trim().isEmpty;

    // check date
    final dateInvalid = _dateStr == null;

    if (amountInvalid || titleInvalid || dateInvalid) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Incomplete'),
                content: Text(
                    'Please make sure a valid ${amountInvalid ? 'amount, ' : ''}${titleInvalid ? 'title, ' : ''}${dateInvalid ? 'date, ' : ''} was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text('OK'))
                ],
              ));
      return;
    }

    // create an instance of expense
    var newExpense = Expense(
        amount: enteredAmt,
        title: _titleController.text,
        date: _dateTime!,
        category: _category);

    // add our new expense to the state
    widget.addExpense(newExpense);

    // dismiss this modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 48, bottom: 20, left: 20, right: 20),
        child: Column(
          children: [
            TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(labelText: 'Title')),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Amount', prefixText: '₱'),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(_dateStr ??= 'Select a date'),
                      IconButton(
                          onPressed: _showDatePicker,
                          icon: Icon(Icons.calendar_month))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Category:', style: TextStyle(fontSize: 15)),
                SizedBox(width: 30),
                Expanded(
                  child: DropdownButton(
                    items: Category.values
                        .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase())))
                        .toList(),
                    onChanged: (selected) {
                      if (selected == null) return;
                      setState(() {
                        _category = selected;
                      });
                    },
                    value: _category,
                  ),
                ),
                SizedBox(width: 20)
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child:
                        TextButton(onPressed: _close, child: Text('Cancel'))),
                SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: _submitExpense, child: Text('Save')))
              ],
            ),
          ],
        ));
  }
}
