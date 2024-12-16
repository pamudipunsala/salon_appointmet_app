import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salon_appointment_app/signUp.dart';
import 'package:salon_appointment_app/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId); // Save the userId
    print("Saved userId to SharedPreferences: $userId");
  }

  void _login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Please enter both username and password.");
      return;
    }

    final url =
        Uri.parse('http://localhost/mobile_apps/appointmentApp/login.php');
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          final String userId = responseData['userId'].toString();
          await _saveUserId(userId);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BusinessTypePage(userId: userId),
            ),
          );
        } else {
          _showErrorDialog(context, responseData['message']);
        }
      } else {
        _showErrorDialog(context, "Failed to connect to the server.");
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred: $e");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Login Failed'),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background image as a container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/bg5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            height: double.infinity, // Make the container fill the height
          ),
          Container(
            color: Colors.black.withOpacity(0.4), // Overlay to darken the image
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.6), // White background for the content box
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Soft shadow
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20.0),
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 23, 92, 14)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),

                  // Username input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: usernameController,
                          placeholder: 'User Name',
                          padding: const EdgeInsets.all(16.0),
                          keyboardType: TextInputType.text,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'User Name',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                  const SizedBox(height: 16.0),

                  // Password input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: passwordController,
                          placeholder: 'Password',
                          padding: const EdgeInsets.all(16.0),
                          obscureText: !_isPasswordVisible,
                          suffix: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            child: Icon(
                                _isPasswordVisible
                                    ? CupertinoIcons.eye
                                    : CupertinoIcons.eye_slash,
                                color: const Color.fromARGB(255, 23, 92, 14)),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromRGBO(118, 118, 118, 1),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                  const SizedBox(height: 30.0),

                  // Login button
                  Platform.isIOS
                      ? CupertinoButton(
                          onPressed: () {
                            _login(); 
                          },
                          child: const Text('Login'),
                          color: Color.fromARGB(255, 23, 92, 14),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _login(); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 23, 92, 14),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white)),
                        ),

                  const SizedBox(height: 20.0),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 14.0),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 23, 92, 14),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  Text(
                    Platform.isIOS
                        ? 'Powered by Synnex IT Solutions 2024 (iOS)'
                        : 'Powered by Synnex IT Solutions 2024 (Android)',
                    style: GoogleFonts.archivo(
                      color: const Color.fromRGBO(0, 0, 0, 0.541),
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
