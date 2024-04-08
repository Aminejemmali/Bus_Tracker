import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/screens/AdminScreens/AdminHome.dart';
import 'package:bustrackerapp/screens/Forgetpassword.dart';
import 'package:bustrackerapp/screens/Register.dart';
import 'package:bustrackerapp/screens/UserScreens/UserHome.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 40.0),
                   Image.asset(
                    'assets/images/bt.png',
                    width: 140.0, // Adjust the width as needed
                    height: 140.0, // Adjust the height as needed
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome back',
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Please login',
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.black),
                            ),
                            Text(
                              'to your account',
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          errorText: _wrongEmail ? 'Invalid email' : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          errorText:
                              _wrongPassword ? 'Incorrect password' : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10.0), backgroundColor: const Color(0xFFFFC25C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPassword.id);
                        },
                        child: const Text(
                          'Forgot Password?',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black54),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          'Don\'t have an account? Register',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _wrongEmail = false;
      _wrongPassword = false;
    });

    try {
      final user = await DatabaseHelper.login(_email, _password);
      if (user != null) {
        if (user.role == 0) {
          // Regular user, navigate to user home screen
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        } else if (user.role == 1) {
          // Admin user, navigate to admin home screen
          Navigator.pushReplacementNamed(context, AdminHomeScreen.id);
        } else {
          // Invalid role, display error message
          showToast('Invalid role for user');
        }
      } else {
        // Failed login, display error message
        setState(() {
          _wrongEmail = true;
          _wrongPassword = true;
        });
      }
    } catch (e) {
      logger.e(e);
      showToast('An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
