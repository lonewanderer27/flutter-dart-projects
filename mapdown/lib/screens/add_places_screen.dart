import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapdown/providers/favorite_places_provider.dart';
import 'package:mapdown/widgets/image_input.dart';

class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  ConsumerState<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  late File? pickedImage;
  late final FavoritePlacesNotifier favoritePlaces;

  @override
  void initState() {
    super.initState();
    favoritePlaces = ref.read(favoritePlacesProvider.notifier);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void handleAdd() {
      if (formKey.currentState!.validate() == false) return;

      favoritePlaces.add(nameController.text, pickedImage!);
      Navigator.of(context).pop();
    }

    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(title: Text('Add Place')),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageInput(
                  handlePhoto: (file) {
                    pickedImage = file;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(label: Text('Place')),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 50) {
                      return 'Please enter a valid place name';
                    }

                    if (value.trim().length < 2 || value.length > 50) {
                      return 'Must be between 2 to 50 characters.';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(onPressed: handleAdd, child: Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
