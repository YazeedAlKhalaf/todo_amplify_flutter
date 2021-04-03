import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:todo_amplify/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  AuthUser _authUser;

  @override
  void initState() {
    super.initState();

    _authService.getCurrentUser().then((AuthUser authUser) {
      setState(() {
        _authUser = authUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _authUser != null
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Hello SOME_NAME!"),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
