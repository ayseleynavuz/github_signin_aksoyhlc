class GithubSignInResponse {
  final ResultStatus? status;
  final String? message;
  final String? name;
  final String? email;
  final String? image;
  final String? id;
  final String? userName;
  final String? allUserData;

  GithubSignInResponse({
    this.status,
    this.message,
    this.name,
    this.email,
    this.image,
    this.allUserData,
    this.id,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'message': message,
      'name': name,
      'email': email,
      'image': image,
      'id': id,
      'userName': userName,
      'allUserData': allUserData,
    };
  }
}

enum ResultStatus {
  success,
  error,
  waiting,
}
