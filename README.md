



## Getting Started

Add package dependency

```yaml  
github_signin: any  
```  

## Example
```dart  
	var params = GithubParamsModel(  
		clientId: 'xxxxxx',  
		clientSecret: 'yyyyyy',  
		callbackUrl: 'http://example.com',  
		scopes: 'read:user,user:email',  
	);  
	  
	dynamic result = Navigator.push(context, MaterialPageRoute(builder: (context) => GithubSignIn(params: params)));  
	  
	if (result == null) {  
		// user cancelled the sign in or error occurred
	}  
	  
	var data = result as GithubSignInResponse;  
	  
	if (data.status != ResultStatus.success) {  
		print(result.message);
	}  
	  
	///TODO: use response data  
```

### Custom AppBar
```dart
	GithubSignIn(
      params: params,
      appBar: PreferredSize(
        child: AppBar(
          title: Text("Github Sign In"),
        ),
        preferredSize: const Size.fromHeight(56),
      ),
    )
```