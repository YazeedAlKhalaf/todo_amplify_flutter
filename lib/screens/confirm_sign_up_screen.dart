import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/screens/home_screen.dart';
import 'package:todo_amplify/services/auth_service.dart';

class ConfirmSignUpScreen extends StatefulWidget {
  final String username;

  const ConfirmSignUpScreen({
    Key key,
    @required this.username,
  }) : super(key: key);

  @override
  _ConfirmSignUpScreenState createState() => _ConfirmSignUpScreenState();
}

class _ConfirmSignUpScreenState extends State<ConfirmSignUpScreen> {
  final AuthService _authService = AuthService();

  final GlobalKey<FormState> _confirmEmailFormKey = GlobalKey<FormState>();

  final TextEditingController _confirmationCodeController =
      TextEditingController();

  bool autoValidate = false;
  bool isBusy = false;
  void setIsBusy(bool newValue) {
    setState(() {
      isBusy = newValue;
    });
  }

  Future<void> confirmEmail() async {
    final String username = widget.username.trim();
    final String confirmationCode = _confirmationCodeController.text.trim();

    if (_confirmEmailFormKey.currentState.validate()) {
      setIsBusy(true);
      final dynamic result = await _authService.confirmEmail(
        username: username,
        confirmationCode: confirmationCode,
      );
      setIsBusy(false);

      if (result is SignUpResult) {
        if (result.isSignUpComplete) {
          print("Confirmation Successful! ${result.nextStep.signUpStep}");
          switch (result.nextStep.signUpStep) {
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
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              isBusy ? LinearProgressIndicator() : SizedBox.shrink(),
              const SizedBox(height: 20),
              Text(
                "Confirm Email",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _confirmEmailFormKey,
                autovalidateMode: autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _confirmationCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Code",
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 6,
                      validator: (String value) {
                        final String trimmedValue = value.trim();

                        if (trimmedValue == "") return "Code cannot be empty!";

                        if (trimmedValue.length != 6)
                          return "Code must be 6 characters!";

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await confirmEmail();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Confirm",
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
    );
  }
}
