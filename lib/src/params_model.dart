import 'github.dart';

class GithubParamsModel {
  late String clientId;
  late String clientSecret;
  late String scopes;
  late String callbackUrl;

  GithubParamsModel({
    required this.clientId,
    required this.clientSecret,
    required this.scopes,
    required this.callbackUrl,
  });

  /// Generate the url for the github sign in.
  String generateUrl() {
    return '${Github.signinUrl}?scope=$scopes&client_id=$clientId&redirect_uri=$callbackUrl&state=${Github().stateString}';
  }

  GithubParamsModel.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    clientSecret = json['clientSecret'];
    scopes = json['scopes'];
    callbackUrl = json['callbackUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['clientSecret'] = clientSecret;
    data['scopes'] = scopes;
    data['callbackUrl'] = callbackUrl;
    return data;
  }
}
