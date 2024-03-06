import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'github.dart';
import 'params_model.dart';
import 'random_str.dart';
import 'response_model.dart';

class GithubSignIn extends StatefulWidget {
  const GithubSignIn({
    super.key,
    required this.params,
    this.appBar,
    this.defaultAppBarVisible = true,
  });
  final GithubParamsModel params;
  final PreferredSize? appBar;
  final bool defaultAppBarVisible;

  @override
  State<GithubSignIn> createState() => _GithubSignInState();

  // create a static method to hide the navigator.push
  static Future<GithubSignInResponse> signIn(BuildContext context, {required GithubParamsModel params}) async {
    dynamic result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => GithubSignIn(params: params)));
    if (result == null) {
      return GithubSignInResponse(
        status: ResultStatus.error,
        message: "User cancelled the sign in or error occurred",
      );
    } else {
      return result as GithubSignInResponse;
    }
  }
}

class _GithubSignInState extends State<GithubSignIn> {
  final GlobalKey webViewKey = GlobalKey();
  final github = Github();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    github.params = widget.params;
    github.stateString = RandomString.generate(16);
  }

  InAppWebViewController? webViewController;

  String code = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.appBar ??
            (!widget.defaultAppBarVisible
                ? null
                : AppBar(
                    title: const Text(
                      "Github Sign In",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: const Color(0xff211f1f),
                    centerTitle: true,
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  )),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.params.generateUrl())),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            if (kDebugMode) {
              print("LoadStart $url");
            }
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            String url = navigationAction.request.url.toString();
            try {
              bool urlControl = url.startsWith(widget.params.callbackUrl.toString());
              Uri uri = Uri.parse(navigationAction.request.url.toString());
              bool codeControl = uri.queryParameters['code'] != null;

              if (urlControl && codeControl) {
                code = uri.queryParameters['code']!;
                GithubSignInResponse response = await github.authenticate(code);

                Navigator.pop(context, response);

                return NavigationActionPolicy.CANCEL;
              } else {
                if (uri.queryParameters['error'] != null) {
                  Navigator.pop(
                    context,
                    GithubSignInResponse(
                      message: uri.queryParameters['error_description'] ?? "Error",
                      status: ResultStatus.error,
                    ),
                  );
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              }
            } catch (e) {
              return NavigationActionPolicy.ALLOW;
            }
          },
        ),
      ),
    );
  }
}
