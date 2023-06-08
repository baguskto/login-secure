import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:http/http.dart' as http;

class LoginController {
  Future<bool> attemptLogin(String username, String password) async {
    // Initialize encryption
    final key = enc.Key.fromUtf8(
        'your-32-char-secret-key'); // replace with your own secret key
    final iv = enc.IV
        .fromLength(16); // an initialization vector for symmetric algorithms
    final encrypter = enc.Encrypter(
        enc.AES(key, mode: enc.AESMode.cbc)); // using AES encryption here

    // Encrypt password
    final encryptedPassword = encrypter.encrypt(password, iv: iv);

    final response = await http.post(
      Uri.parse('https://example.com/login'),
      body: jsonEncode(<String, String>{
        'username': username,
        'password': encryptedPassword.base64, // pass encrypted password
      }),
    );

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      if (responseJson['status'] == "success") {
        return true;
      }
    }
    return false;
  }
}
