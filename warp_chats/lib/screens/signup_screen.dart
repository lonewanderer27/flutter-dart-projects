import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warp_chats/constants/assets.dart';
import 'package:warp_chats/screens/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _chosenImage;
  String _enteredEmail = '';
  String _enteredPassword = '';

  void _handleSignIn() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => SigninScreen()));
    }
  }

  Future<void> _uploadImageToFb(File imageFile) async {
    // Get the file

    // Optional: Reduce the size of the image

    // Convert into base64 string
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    // Create the user profile with image
    final profile = <String, dynamic>{'avatarBase64': base64Image};

    // Upload to firestore
    await db
        .collection('avatars')
        .doc(fb.currentUser!.uid.toString())
        .set(profile);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    _formKey.currentState!.save();
    debugPrint('Email: $_enteredEmail');
    debugPrint('Password: $_enteredPassword');

    try {
      // sign up user
      UserCredential userCreds = await fb.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      debugPrint('User creds: $userCreds');

      // submit the image
    } on FirebaseAuthException catch (error) {
      debugPrint('Auth error: ${error.message}');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('There has been an error. Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'header-image',
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 30, bottom: 20, left: 20, right: 20),
                      width: 100,
                      child: Image.asset(Assets.chat)),
                ),
                Hero(
                  tag: 'header-text',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi there!',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Create your account to get started',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 55),
                  child: Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50, left: 16, right: 16, bottom: 16),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.mail),
                                    label: Text('Email')),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please return a valid email';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock),
                                    label: Text('Password')),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: _submit,
                                      child: Text('Sign Up'))
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(116, 3, 3, 54),
                            blurRadius: 50 // Shadow position
                            ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _chosenImage == null
                          ? Image.asset(Assets.unisexAvatar, width: 100).image
                          : Image.file(_chosenImage!).image,
                    ),
                  ),
                )
              ],
            ),
            Text(
              'Or continue using',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.red,
                  ),
                  child: Image.asset(
                    'assets/images/google.png',
                    scale: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _handleSignIn,
                  child: Text(
                    "Sign In",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
