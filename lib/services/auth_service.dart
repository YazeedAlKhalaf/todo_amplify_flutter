import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  Future<SignUpResult> registerUser({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      final SignUpResult signUpResult = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: CognitoSignUpOptions(
          userAttributes: {
            'email': email,
          },
        ),
      );

      return signUpResult;
    } on AuthException catch (e) {
      print(e.message);

      return null;
    }
  }

  Future<SignUpResult> confirmEmail({
    @required String username,
    @required String confirmationCode,
  }) async {
    try {
      final SignUpResult signUpResult = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );

      return signUpResult;
    } on AuthException catch (e) {
      print(e.message);

      return null;
    }
  }

  Future<AuthUser> getCurrentUser() async {
    final AuthUser authUser = await Amplify.Auth.getCurrentUser();

    return authUser;
  }
}
