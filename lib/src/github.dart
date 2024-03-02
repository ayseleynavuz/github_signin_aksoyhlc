import 'dart:convert';

import 'package:http/http.dart' as http;

import 'params_model.dart';
import 'response_model.dart';

/// Github authentication helper class.
///
class Github {
  Github._internal();
  static final Github _instance = Github._internal();
  factory Github() => _instance;

  static const signinUrl = 'https://github.com/login/oauth/authorize';
  static const accesTokenUrl = 'https://github.com/login/oauth/access_token';
  static const userDataUrl = 'https://api.github.com/user';
  static const emailUrl = 'https://api.github.com/user/emails';
  String stateString = '';
  GithubParamsModel? params;
  String message = '';
  String? accessToken = '';

  http.Response response = http.Response("", 200);

  Future<GithubSignInResponse> authenticate(String code) async {
    try {
      accessToken = await getAccesToken(code);
      if (accessToken != null) {
        var userData = await getUserData();
        var email = await getEmail();
        return GithubSignInResponse(
          message: "Success",
          status: ResultStatus.success,
          email: email,
          image: userData?['avatar_url'].toString(),
          name: userData?['name'].toString(),
          userName: userData?['login'].toString(),
          id: userData?['id'].toString(),
          allUserData: jsonEncode(userData),
        );
      }
      return GithubSignInResponse(
        message: message,
        status: ResultStatus.error,
      );
    } catch (e) {
      return GithubSignInResponse(
        message: "$message\n\n$e",
        status: ResultStatus.error,
      );
    }
  }

  /// Get the access token from the code.
  Future<String?> getAccesToken(String code) async {
    try {
      response = await http.post(
        Uri.parse(accesTokenUrl),
        headers: {'Accept': 'application/json'},
        body: {
          'client_id': params!.clientId,
          'client_secret': params!.clientSecret,
          'code': code,
          'redirect_uri': params!.callbackUrl,
        },
      );
      return jsonDecode(response.body)['access_token'];
    } catch (e) {
      message = "Status Code: ${response.statusCode}\n\n Response Body: ${response.body} \n\n Error: ${e.toString()}";
      return null;
    }
  }

  /// Get the user data from the access token.
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      response = await http.get(
        Uri.parse(userDataUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $accessToken",
        },
      );
      var userData = jsonDecode(response.body);
      return userData;
    } catch (e) {
      return null;
    }
  }

  /// Get the email from the access token.
  /// Github email scope is not required. If the user does not give permission to access the email, the email will not be returned.
  Future<String?> getEmail() async {
    if (!params!.scopes.contains("email")) {
      return null;
    }
    try {
      response = await http.get(
        Uri.parse(emailUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': "Bearer $accessToken",
        },
      );
      List emails = jsonDecode(response.body);
      if (emails.isEmpty) {
        return null;
      }

      var match = emails.where((element) => element['primary'] == true);

      if (match.isEmpty) {
        return null;
      }

      String? email = match.first['email'];
      return email;
    } catch (e) {
      message = "Status Code: ${response.statusCode}\n\n Response Body: ${response.body} \n\n Error: ${e.toString()}";
      return null;
    }
  }
}
