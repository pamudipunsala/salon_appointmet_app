import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salon_appointment_app/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Function to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Sign Up Failed'),
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
            title: const Text('Sign Up Failed'),
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

  Future<void> signUp() async {
    var url = Uri.parse(Platform.isAndroid
        ? 'http://10.0.2.2/mobile_apps/appointmentApp/profile.php'
        : 'http://localhost/mobile_apps/appointmentApp/profile.php');

    try {
      var response = await http.post(url, body: {
        'name': nameController.text,
        'phone': phoneNumberController.text,
        'category': categoryController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'confirm_password': confirmPasswordController.text,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          Navigator.pushReplacementNamed(context, '/businessTypePage');
        } else {
          _showErrorDialog(context, data['message']);
        }
      } else {
        _showErrorDialog(context,
            "Failed to connect to the server. Response: ${response.body}");
        print("error: ${response.body}");
      }
    } catch (e) {
      _showErrorDialog(context, "Error: $e");
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
              'assets/images/background/bg7.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Transparent color overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
            ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 23, 92, 14)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),

                  //Name input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: nameController,
                          placeholder: 'Name',
                          padding: const EdgeInsets.all(16.0),
                          keyboardType: TextInputType.text,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                  const SizedBox(height: 16.0),

                  //Phone Number input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: phoneNumberController,
                          placeholder: 'Phone Number',
                          padding: const EdgeInsets.all(16.0),
                          keyboardType: TextInputType.text,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                  const SizedBox(height: 16.0),

                  //Category input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: categoryController,
                          placeholder: 'Category',
                          padding: const EdgeInsets.all(16.0),
                          keyboardType: TextInputType.text,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                  const SizedBox(height: 16.0),

                  // Username input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: emailController,
                          placeholder: 'Email',
                          padding: const EdgeInsets.all(16.0),
                          keyboardType: TextInputType.text,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                  const SizedBox(height: 16.0),

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
                  const SizedBox(height: 16.0),

                  // Confirm Password input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: confirmPasswordController,
                          placeholder: 'Confirm Password',
                          padding: const EdgeInsets.all(16.0),
                          obscureText: !_isConfirmPasswordVisible,
                          suffix: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            child: Icon(
                                _isConfirmPasswordVisible
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
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromRGBO(118, 118, 118, 1),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                        ),
                  const SizedBox(height: 30.0),

                  // Sign Up button
                  Platform.isIOS
                      ? CupertinoButton(
                          onPressed: () {
                            signUp();
                          },
                          child: const Text('Sign Up'),
                          color: Color.fromARGB(255, 23, 92, 14),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            signUp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 23, 92, 14),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          child: const Text('Sign Up',
                              style: TextStyle(color: Colors.white)),
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
