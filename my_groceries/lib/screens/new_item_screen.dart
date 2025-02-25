import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_groceries/data/categories.dart';
import 'package:my_groceries/models/category.dart';
import 'package:my_groceries/providers/grocery_items_provider.dart';

class NewItemScreen extends ConsumerStatefulWidget {
  const NewItemScreen({super.key});

  @override
  ConsumerState<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends ConsumerState<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredTitle = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.dairy]!;

  void _onSubmit() {
    // Try to validate the form
    if (_formKey.currentState!.validate()) {
      // Trigger form save
      _formKey.currentState!.save();

      // Set the form value to the global state
      ref.read(groceryItemsProvider.notifier).addItem(
          DateTime.now().toIso8601String(),
          _enteredTitle,
          _enteredQuantity,
          _selectedCategory);

      // Close our current screen
      Navigator.of(context).pop();
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Item'),
        ),
        // body: Padding(padding: EdgeInsets.all(20), child: Form(child: )),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Name')),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length > 50) {
                        return 'Please enter a valid item name';
                      }

                      if (value.trim().length < 2 || value.length > 50) {
                        return 'Must be between 1 to 50 characters.';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _enteredTitle = value!;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _enteredQuantity.toString(),
                          decoration:
                              const InputDecoration(label: Text('Quantity')),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return 'Please enter a valid quantity';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredQuantity = int.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: DropdownButtonFormField(
                        items: categories.entries
                            .map((category) => DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: category.value.color,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(category.value.title)
                                  ],
                                )))
                            .toList(),
                        onChanged: (category) {
                          setState(() {
                            _selectedCategory = category!;
                          });
                        },
                        value: _selectedCategory,
                        // No need to use onSaved on dropdown
                        // sicne we already save the currently selected category
                        // onSaved: (category) {
                        //   setState(() {
                        //     _savedCategory = category!;
                        //   });
                        // },
                        decoration:
                            const InputDecoration(label: Text('Category')),
                      ))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: _resetForm, child: Text('Reset')),
                      SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: _onSubmit, child: Text('Submit'))
                    ],
                  )
                ],
              ),
            )));
  }
}
