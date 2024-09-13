import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salon_appointment_app/BeautyCare/views/services.dart';
import 'package:salon_appointment_app/BeautyCare/views/signUp.dart';
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
  // final Platform platform = const LocalPlatform();

  // Function to handle login
  // Future<void> _login(BuildContext context) async {
  //   final username = usernameController.text;
  //   final password = passwordController.text;

  //   // Check if username or password is empty
  //   if (username.isEmpty || password.isEmpty) {
  //     _showErrorDialog(context, 'Please enter both username and password.');
  //     return;
  //   }

  //   try {
  //     // Send HTTP POST request to validate login
  //     final response = await http.post(
  //       Uri.parse('https://mobicloudpos.synnexcloudpos.com/'),
  //       body: {
  //         'u_name': username,
  //         'user_password': password,
  //       },
  //     );

  //     // If response is successful (HTTP status 200)
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);

  //       // Check if the response contains user data
  //       if (responseData is List && responseData.isNotEmpty) {
  //         final userId = responseData[0]['USID'].toString();
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('userId', userId);

  //         // Navigate to the dashboard page if login is successful
  //         //   Navigator.pushReplacement(
  //         //     context,
  //         //     MaterialPageRoute(builder: (context) => DashboardPage()),
  //         //   );
  //         // } else {
  //         _showErrorDialog(context, 'Invalid username or password.');
  //       }
  //     } else {
  //       _showErrorDialog(context, 'Error: Could not connect to the server.');
  //     }
  //   } catch (e) {
  //     _showErrorDialog(context, 'An error occurred: $e');
  //   }
  // }

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
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/img1.png', // Your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Transparent color overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
            ),
          ),
          // Login form content in a white container
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
                  Center(
                      // child: Image.asset(
                      //   'assets/images/logo.png', // Optional logo
                      //   width: 150,
                      //   height: 100,
                      // ),
                      ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 152, 11, 58)),
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
                                color: Color.fromARGB(255, 152, 11, 58)),
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
                                color: const Color.fromARGB(255, 152, 11, 58)),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 152, 11, 58)),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServicesPage()));
                          },
                          child: const Text('Login'),
                          color: Color.fromARGB(255, 152, 11, 58),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ServicesPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 152, 11, 58),
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
                              color: Color.fromARGB(255, 152, 11, 58),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to the SignUp page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
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
