import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warp_chats/constants/assets.dart';

// Setup the global firebase instance
final _fb = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _signUp = false;
  String _enteredEmail = '';
  String _enteredPassword = '';

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    _formKey.currentState!.save();
    debugPrint('Email: $_enteredEmail');
    debugPrint('Password: $_enteredPassword');

    try {
      if (_signUp) {
        // sign up user
        UserCredential userCreds = await _fb.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        debugPrint('User creds: $userCreds');
      } else {
        // sign in user
        UserCredential userCreds = await _fb.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        debugPrint('User creds: $userCreds');
      }
    } on FirebaseAuthException catch (error) {
      debugPrint('Auth error: ${error.message}');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('There has been an error. Try again.')));
    }
  }

  void _toggleSignUp() {
    setState(() {
      _signUp = !_signUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset(Assets.chat)),
            Text(
              _signUp ? 'Hi there!' : 'Welcome back!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              _signUp
                  ? 'Create your account to get started'
                  : "Please enter your credentials to continue",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                              icon: Icon(Icons.mail), label: Text('Email')),
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
                              icon: Icon(Icons.lock), label: Text('Password')),
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
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
                                child: Text(_signUp ? 'Sign Up' : 'Sign In'))
                          ],
                        ),
                      ],
                    )),
              ),
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
                  _signUp
                      ? "Already have an account?"
                      : "Don't have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _toggleSignUp,
                  child: Text(
                    _signUp ? "Sign In" : "Sign Up",
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
