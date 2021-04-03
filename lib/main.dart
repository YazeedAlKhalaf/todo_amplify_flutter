import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/amplifyconfiguration.dart';
import 'package:todo_amplify/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartupScreen(),
      builder: (BuildContext context, Widget child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus.unfocus();
          },
          child: child,
        );
      },
    );
  }
}

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    /// Once Plugins are added, configure Amplify.
    /// Note: Amplify can only be configured once.
    try {
      /// Add Cognito Plugin.
      await Amplify.addPlugin(AmplifyAuthCognito());

      await Amplify.configure(amplifyconfig);

      setState(() {
        _amplifyConfigured = true;
      });

      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => RegisterScreen()),
        (route) => false,
      );
    } on AmplifyAlreadyConfiguredException catch (exception) {
      print("Amplify was already configured. Was the app restarted?");
    } on AmplifyException catch (exception) {
      print("Amplify Exception: $exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            const SizedBox(height: 15),
            Text(
              _amplifyConfigured ? "configured" : "not configured",
            ),
          ],
        ),
      ),
    );
  }
}
