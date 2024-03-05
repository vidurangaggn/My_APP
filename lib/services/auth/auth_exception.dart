//Login Exception
class UserNotFoundAuthException implements Exception {
  final String message = 'User not found';
}
class WrongPasswordAuthException implements Exception {
  final String message = 'User not found';
}

//Register Exception
class WeakPasswordAuthException implements Exception {
  final String message = 'The password provided is too weak.';
}
class EmailAlreadyInUseAuthException implements Exception {
  final String message = 'The account already exists for that email.';
}
class InvalidEmailAuthException implements Exception {
  final String message = 'The email is invalid';
}

//Generic Exception
class GenericAuthException implements Exception {
  final String message = 'An error occurred';
}
class UserNotLoggedInException implements Exception {
  final String message = 'User not logged in';
}