import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart';
import 'package:bustrackerapp/screens/UserScreens/UserHome.dart';

class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
        
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 60.0),
                Image.asset(
                  'assets/images/bt.png',
                  width: 140.0, // Adjust the width as needed
                  height: 140.0, // Adjust the height as needed
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         
                          Text(
                            'Bienvenue,',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          Text(
                            'veuillez vous inscrire',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                          Text(
                            'pour créer un compte',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0), // Add space between text and logo

                  ],
                ),
                // Your other form fields and buttons here

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nom',
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          errorText: _wrongEmail ? 'Email erronée' : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          labelText: 'Mot de passe',
                          errorText:
                              _wrongPassword ? 'Mot de passe Incorrecte ' : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _confirmPassword = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Confirmer mot de passe',
                          labelText: 'Confirmer mot de passe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10.0), backgroundColor: const Color(0xFFFFC25C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ForgotPassword');
                      },
                      child: const Text(
                        'Mot de passe oublié?',
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/LoginPage');
                      },
                      child: const Text(
                        'Vous avez déjà un compte ? Connectez-vous',
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState == null) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _wrongEmail = false;
      _wrongPassword = false;
    });

    try {
      final user = await DatabaseHelper.register(_name, _email, _password);
      if (user != null) {
        // Successful registration, navigate to the home screen
        Navigator.pushNamed(context, HomeScreen.id);
      } else {
        // Failed registration, display error message
        showToast('Informations invalides, veuillez réessayer.');
      }
    } catch (e) {
      showToast('Une erreur sest produite, veuillez réessayer');
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
