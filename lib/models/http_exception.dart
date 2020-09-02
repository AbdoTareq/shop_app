class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  String getErrorMessage(error) {
    var errorMessage = 'Authentication failed';
    if (error.toString().contains('EMAIL_EXISTS')) {
      errorMessage = 'This email address is already in use.';
    } else if (error.toString().contains('INVALID_EMAIL')) {
      errorMessage = 'This is not a valid email address';
    } else if (error.toString().contains('WEAK_PASSWORD')) {
      errorMessage = 'This password is too weak.';
    } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
      errorMessage = 'Could not find a user with that email.';
    } else if (error.toString().contains('INVALID_PASSWORD')) {
      errorMessage = 'Invalid password.';
    }
    return errorMessage;
  }

  @override
  String toString() {
    return message;
  }
}
