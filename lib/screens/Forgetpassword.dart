import 'package:bustrackerapp/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:bustrackerapp/db_Functions/db_helper.dart';

class ForgotPassword extends StatefulWidget {
  static String id = '/ForgotPassword';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';
  String newPassword = '';
  bool showNewPasswordField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 Image.asset(
                  'assets/images/bt.png',
                  width: 140.0, // Adjust the width as needed
                  height: 140.0, // Adjust the height as needed
                ),
                Text(
                  'Réinitialisez votre mot de passe',
                  style: TextStyle(fontSize: 40.0,
                  fontWeight: FontWeight.bold,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [


                    const Text(
                      'Entrez votre adresse e-mail',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    if (showNewPasswordField) ...[
                      const SizedBox(height: 20.0),
                      const Text(
                        'Entrez votre nouveau mot de passe',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        obscureText: true,
                        onChanged: (value) {
                          newPassword = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nouveau mot de passe',
                        ),
                      ),
                    ],
                  ],
                ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                backgroundColor: const Color(0xFFFFC25C),
              ),
              onPressed: () async {
                if (!showNewPasswordField) {
                  final emailExists = await DatabaseHelper.checkEmailExists(email);
                  if (emailExists) {
                    setState(() {
                      showNewPasswordField = true;
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('E-mail non trouvé ❌'),
                          content: const Text(
                              'Ladresse e-mail saisie nexiste pas dans nos dossiers.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  final success =
                  await DatabaseHelper.resetPassword(email, newPassword);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(success
                            ? 'Réinitialisation du mot de passe ✅'
                            : 'Échec de la réinitialisation du mot de passe ❌'),
                        content: success
                            ? const Text('Réinitialisation du mot de passe réussie.')
                            : const Text(
                            '"La réinitialisation du mot de passe a échoué. Veuillez réessayer.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (success) {
                                Navigator.pushReplacementNamed(context, LoginPage.id);
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Reset Password',
                style: TextStyle(fontSize: 25.0, color: Colors.white),
              ),
            ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
