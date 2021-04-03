import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/screens/confirm_sign_up_screen.dart';
import 'package:todo_amplify/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
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

  Future<void> registerUser() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_registerFormKey.currentState.validate()) {
      setIsBusy(true);
      final dynamic result = await _authService.registerUser(
        username: username,
        email: email,
        password: password,
      );
      setIsBusy(false);

      if (result is SignUpResult) {
        if (result.isSignUpComplete) {
          print("Sign Up Successful! ${result.nextStep.signUpStep}");
          switch (result.nextStep.signUpStep) {
            case "CONFIRM_SIGN_UP_STEP":
              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => ConfirmSignUpScreen(
                    username: username,
                  ),
                ),
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
                  "Register",
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _registerFormKey,
                  autovalidateMode: autoValidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (String value) {
                          final String trimmedValue = value.trim();

                          if (trimmedValue == "")
                            return "Email cannot be empty!";

                          if (!trimmedValue.contains("@"))
                            return "Email must be correct!";

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                                await registerUser();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
