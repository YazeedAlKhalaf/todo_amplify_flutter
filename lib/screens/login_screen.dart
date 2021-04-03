import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/screens/home_screen.dart';
import 'package:todo_amplify/screens/register_screen.dart';
import 'package:todo_amplify/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool autoValidate = false;
  bool showPassword = false;
  bool isBusy = false;
  void setIsBusy(bool newValue) {
    setState(() {
      isBusy = newValue;
    });
  }

  Future<void> loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (_loginFormKey.currentState.validate()) {
      setIsBusy(true);
      final dynamic result = await _authService.loginUser(
        username: username,
        password: password,
      );
      setIsBusy(false);

      if (result is SignInResult) {
        if (result.isSignedIn) {
          print("Sign In Successful! ${result.nextStep.signInStep}");
          switch (result.nextStep.signInStep) {
            case "DONE":
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
              break;
          }
        }
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                isBusy ? LinearProgressIndicator() : SizedBox.shrink(),
                const SizedBox(height: 20),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _loginFormKey,
                  autovalidateMode: autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        ),
                        validator: (String value) {
                          final String trimmedValue = value.trim();

                          if (trimmedValue == "")
                            return "Username cannot be empty!";

                          if (trimmedValue.length < 3)
                            return "Username must be more than 2 characters!";

                          if (trimmedValue.length > 15)
                            return "Username must be less than 15 characters!";

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: !showPassword,
                        validator: (String value) {
                          final String trimmedValue = value.trim();

                          if (trimmedValue == "")
                            return "Password cannot be empty!";

                          if (trimmedValue.length < 8)
                            return "Password must be more than 8 characters!";

                          if (trimmedValue.length > 15)
                            return "Password must be less than 15 characters!";

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await loginUser();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Have no account? Register!",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
