import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kchat/models/error.dart';
import 'package:kchat/models/sign_up_data.dart';
import 'package:kchat/services/k_jwt.dart' as jwt;

const String _host = 'http://localhost:8080';

Future<bool> isUsernameExists(String username) async {
  try {
    var response = await http.post(
      Uri.parse('$_host/is_username_exists'),
      body: jsonEncode({'username': username}),
    );

    bool status = jsonDecode(response.body)['status'];
    if (response.statusCode == 200) {
      return status;
    }
    else {
      print('Request failed with status: ${response.statusCode}.');
      return true;
    }
  }
  catch (e) {
    print('Server not available');
    return true;
  }
}

Future<bool> signUpUser(SignUpData signUpData) async {
  var response = await http.post(
    Uri.parse('$_host/sign_up'),
    body: jsonEncode(await signUpData.toJson()),
  );

  var jsonData = jsonDecode(response.body);
  bool status = jsonData['status'];

  if (response.statusCode == 200 && status) {
    await jwt.storeToken(jsonData['jwt']);
    return status;
  }
  else {
    print('Request failed with status: ${response.statusCode}.');
    return false;
  }
}

Future<KError> authUser(String username, String password) async {
  try {
    var response = await http.post(
      Uri.parse('$_host/auth'),
      body: jsonEncode({'username': username, 'password': password})
    );

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonData['status']) {
      await jwt.storeToken(jsonData['jwt']);
      return KError(false, 'OK.');
    }
    else if (response.statusCode == 200 && !jsonData['status'])
      return KError(true, 'User not found.');
    else
      return KError(true, 'Error (${response.statusCode}): ${response.body}');
  }
  on SocketException {
    return KError(true, 'Server not available.');
  }
  catch (e) {
    return KError(true, 'Unknown error: $e');
  }
}
