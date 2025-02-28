import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/providers/places_provider.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen(this.image, {super.key});
  final File image;

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PlacesNotifier placesNotifier = ref.read(placesProvider.notifier);

    void handleAdd() {
      placesNotifier.add(_nameController.text, widget.image, DateTime.now());
      Navigator.of(context).pop();
    }

    return Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.black54,
          body: Stack(
            children: [
              Hero(
                  tag: 'image-preview',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.hardEdge,
                    child: Image.file(
                      widget.image,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: _nameController,
                              decoration: InputDecoration(
                                  label: Text(
                                'Caption',
                                style: TextStyle(color: Colors.white),
                              )),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length > 50) {
                                  return 'Please enter a valid place name';
                                }

                                if (value.trim().length < 2 ||
                                    value.length > 50) {
                                  return 'Must be between 2 to 50 characters.';
                                }

                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: handleAdd, child: Text('Submit'))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
          // body: SingleChildScrollView(
          //   child: Padding(
          //     padding:
          //         EdgeInsets.only(top: 40, bottom: 20, right: 20, left: 20),
          //     child: Column(
          //       children: [
          //         Hero(
          //             tag: 'image-preview',
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(20),
          //               clipBehavior: Clip.hardEdge,
          //               child: Image.file(widget.image,
          //                   height: 500,
          //                   width: double.infinity,
          //                   fit: BoxFit.fill),
          //             )),
          //         SizedBox(height: 10),
          //         TextFormField(
          //           controller: _nameController,
          //           decoration: InputDecoration(label: Text('Place')),
          //           validator: (value) {
          //             if (value == null || value.isEmpty || value.length > 50) {
          //               return 'Please enter a valid place name';
          //             }

          //             if (value.trim().length < 2 || value.length > 50) {
          //               return 'Must be between 2 to 50 characters.';
          //             }

          //             return null;
          //           },
          //         ),
          //         SizedBox(
          //           height: 20,
          //         ),
          //         ElevatedButton(onPressed: handleAdd, child: Text('Submit'))
          //       ],
          //     ),
          //   ),
          // ),
        ));
  }
}
