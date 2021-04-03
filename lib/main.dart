import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/amplifyconfiguration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    /// Add PinPoint and Cognito Plugins.
    await Amplify.addPlugin(AmplifyAuthCognito());

    /// Once Plugins are added, configure Amplify.
    /// Note: Amplify can only be configured once.
    try {
      await Amplify.configure(amplifyconfig);

      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException catch (exception) {
      print("Amplify was already configured. Was the app restarted?");
      print("Amplify Exception: $exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            _amplifyConfigured ? "configured" : "not configured",
          ),
        ],
      ),
    );
  }
}
