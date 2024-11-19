import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:salon_appointment_app/login.dart';
import 'package:uuid/uuid.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String selectedUserType = "Select a Type";
  List<dynamic> userTypes = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserTypes();
  }

  Future<void> fetchUserTypes() async {
    var url = Uri.parse(
        "http://localhost/mobile_apps/appointmentApp/getUserTypes.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> &&
            data.containsKey('types') &&
            data['types'] is List) {
          setState(() {
            userTypes = data['types'];
            selectedUserType =
                userTypes.isNotEmpty ? userTypes[0]['type'] : "Select a Type";
          });
          print('User Types loaded: $userTypes');
        } else {
          print('Unexpected JSON structure: $data');
        }
      } else {
        print('Failed to load user types. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

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
    String name = nameController.text;
    String shop = shopController.text;
    String email = emailController.text;
    String userName = usernameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      _showErrorDialog(context, "Passwords do not match.");
      return;
    }

    String? selectedTypeId = userTypes.firstWhere(
      (type) => type['type'] == selectedUserType,
      orElse: () => null,
    )?['id'];

    if (selectedTypeId == null || selectedTypeId.isEmpty) {
      _showErrorDialog(context, "Please select a valid user type.");
      return;
    }

    int typeId = int.tryParse(selectedTypeId) ?? 0;
    print("Selected UserType: $selectedUserType");

    int shopId = await generateShopId();
    print("Final ShopId assigned in signUp: $shopId");

    var url =
        Uri.parse("http://localhost/mobile_apps/appointmentApp/signUp.php");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'shop': shop,
        'shop_id': shopId,
        'type_id': typeId,
        'email': email,
        'userName': userName,
        'password': password,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Server Response: ${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Sign up successful!')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      _showErrorDialog(context, 'Failed to sign up. Please try again.');
    }
  }

  Future<int> generateShopId() async {
    try {
      var url = Uri.parse(
          "http://192.168.8.116/mobile_apps/appointmentApp/getHighestShopId.php");

      final response = await http.get(url);
      print("Response for Highest Shop ID: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int currentShopId =
            int.tryParse(data['highest_shop_id'].toString()) ?? 0;
        int newShopId = currentShopId + 1;
        print("Generated ShopId: $newShopId");
        return newShopId;
      } else {
        print("Failed to fetch highest shopId. Defaulting to 0.");
        return 0;
      }
    } catch (e) {
      print('Error occurred while fetching highest shopId: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg7.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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

                  // Name input field
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

                  DropdownButton<String>(
                    value: selectedUserType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUserType = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem<String>(
                        value: 'Select a Type',
                        child: Text('Select a user Type'),
                      ),
                      ...userTypes.map((dynamic type) {
                        return DropdownMenuItem<String>(
                          value: type['type'],
                          child: Text(type['type']),
                        );
                      }).toList(),
                    ],
                    style: TextStyle(
                      color: const Color.fromARGB(255, 71, 4, 4),
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Shop input field
                  Platform.isIOS
                      ? CupertinoTextField(
                          controller: shopController,
                          placeholder: 'Shop',
                          padding: const EdgeInsets.all(16.0),
                          keyboardType: TextInputType.text,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 23, 92, 14)),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        )
                      : TextFormField(
                          controller: shopController,
                          decoration: const InputDecoration(
                            labelText: 'Shop',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                  const SizedBox(height: 16.0),

                  // Email input field
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

                  // User Name input field
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
