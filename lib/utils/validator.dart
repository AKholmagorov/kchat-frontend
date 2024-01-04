import 'package:kchat/services/http_requests.dart';

enum ValidatorType {
  USERNAME,
  GROUP_NAME,
  PASSWORD,
  CONFIRM,
  BIO
}

Future<({bool error, String? errorText})> CheckUsername(String value, {String? curUsername}) async {
  int minUsernameLength = 3;

  // ERRORS
  if (value == curUsername)
    return (error: true, errorText: null);
  else if (value.isEmpty)
    return (error: true, errorText: null);
  else if (!isValidSymbols(value) && !value.isEmpty)
    return (error: true, errorText: 'Only A-z, 0-9, _ symbols');
  else if (value.length < minUsernameLength)
    return (error: true, errorText: 'At least $minUsernameLength characters');
  else if(await isUsernameExists(value))
    return (error: true, errorText: 'Username already taken');
  // OK
  else
    return (error: false, errorText: 'Available');
}

({bool error, String? errorText}) CheckGroupName(String value) {
  int minUsernameLength = 3;

  // ERRORS
  if (value.isEmpty)
    return (error: true, errorText: null);
  else if (!isValidSymbols(value) && !value.isEmpty)
    return (error: true, errorText: 'Only A-z, 0-9, _ symbols');
  else if (value.length < minUsernameLength)
    return (error: true, errorText: 'At least $minUsernameLength characters');
  // OK
  else
    return (error: false, errorText: '');
}

({bool error, String? errorText}) CheckPassword(String value) {
  int minPassLength = 8;

  // ERRORS
  if (value.isEmpty)
    return (error: true, errorText: null);
  else if (!isValidSymbols(value) && !value.isEmpty)
    return (error: true, errorText: 'Only A-z, 0-9, _ symbols');
  else if (value.length < minPassLength)
    return (error: true, errorText: 'At least $minPassLength characters');
  // OK
  else
    return (error: false, errorText: '');
}

({bool error, String? errorText}) CheckConfirmation(String oldValue, String newValue) {
  // ERRORS
  if (newValue.isEmpty)
    return (error: true, errorText: null);
  else if (newValue != oldValue)
    return (error: true, errorText:"Didn't match");
  // OK
  else
    return (error: false, errorText: '');
}

({bool error, String? errorText}) CheckBio(String newValue, String? initValue) {
  // ERRORS
  if (newValue.isEmpty && initValue == null || newValue == initValue)
    return (error: true, errorText: null);
  // OK
  else
    return (error: false, errorText: null);
}

bool isValidSymbols(String text) {
  final RegExp regex = RegExp(r'^[A-Za-z0-9_]+$');
  return regex.hasMatch(text);
}
