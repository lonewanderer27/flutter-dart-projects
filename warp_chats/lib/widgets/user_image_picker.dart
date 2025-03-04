import 'dart:io';

import 'package:flutter/material.dart';
import 'package:warp_chats/constants/assets.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.onPickImage, required this.currentImage});
  File currentImage;
  void Function(File image) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _chosenImage;

  @override
  void initState() {
    super.initState();
    _chosenImage = widget.currentImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 70 // Shadow position
                            ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundImage: _chosenImage == null
                          ? Image.asset(Assets.unisexAvatar).image
                          : Image.file(_chosenImage!).image,
                    ),
                  );
  }
}
