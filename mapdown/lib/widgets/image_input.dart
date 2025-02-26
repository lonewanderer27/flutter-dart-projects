import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.handlePhoto});
  final void Function(File? image) handlePhoto;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void takePhoto({bool gallery = false}) async {
    final imagePicker = ImagePicker();
    XFile? pickedImage;
    if (gallery == false) {
      pickedImage = await imagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 600);
    } else {
      pickedImage = await imagePicker.pickMedia(maxWidth: 600);
    }

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage!.path);
      widget.handlePhoto(_selectedImage!);
    });
  }

  void clearPhoto() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
            onPressed: () {
              takePhoto();
            },
            label: Text('Take a Photo'),
            icon: Icon(Icons.camera)),
        TextButton.icon(
            style: ButtonStyle(),
            onPressed: () {
              takePhoto(gallery: true);
            },
            label: Text('Pick from Gallery'),
            icon: Icon(Icons.photo_library))
      ],
    );

    if (_selectedImage != null) {
      content = InkWell(
        onTap: clearPhoto,
        child: Image.file(_selectedImage!, fit: BoxFit.fill),
      );
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12)),
      height: 350,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
