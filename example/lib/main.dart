import 'package:flutter/material.dart';
import 'package:github_signin_aksoyhlc/github_signin_aksoyhlc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                var params = GithubParamsModel(
                  clientId: 'xxxxxx',
                  clientSecret: 'yyyyyy',
                  callbackUrl: 'http://example.com',
                  scopes: 'read:user,user:email',
                );

                dynamic result =
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GithubSignIn(params: params)));

                if (result == null) {
                  // user cancelled the sign in or error occurred
                }

                var data = result as GithubSignInResponse;

                if (data.status != ResultStatus.success) {
                  print(result.message);
                }
              },
              child: const Text("Sign in with Github"),
            )
          ],
        ),
      ),
    );
  }
}
