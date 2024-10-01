import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/categories.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/add_categories.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({super.key});

  @override
  _AddServicesPageState createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  final List<Map<String, dynamic>> services = [
    {'name': 'Colombo 05', 'image': 'assets/images/img10.jpeg'},
    {'name': 'Nugegoda', 'image': 'assets/images/img11.jpeg'},
    {'name': 'Maharagama', 'image': 'assets/images/img12.jpeg'},
    {'name': 'Gampaha', 'image': 'assets/images/img13.jpeg'},
    {'name': 'Kandy', 'image': 'assets/images/img14.jpeg'},
  ];

  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _filteredServices = services;
    _searchController.addListener(_filterServices);
  }

  void _filterServices() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredServices = services;
      } else {
        _filteredServices = services
            .where((service) => service['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _pickImage() async {
    PermissionStatus permissionStatus;

    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.request();
    } else if (Platform.isIOS) {
      permissionStatus = await Permission.photos.request();
    } else {
      return;
    }

    if (permissionStatus.isGranted) {
      // If permission granted, pick the image
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } else {
      print('Permission denied to access the gallery.');
      // Optionally show a message or redirect to app settings
      if (await Permission.storage.isPermanentlyDenied ||
          await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  void _showAddServiceDialog(BuildContext context) {
    final TextEditingController _serviceNameController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Add New Service'),
                content: Column(
                  children: [
                    CupertinoTextField(
                      controller: _serviceNameController,
                      placeholder: 'Enter Service name',
                    ),
                    const SizedBox(height: 10),
                    CupertinoButton(
                      color: const Color.fromARGB(255, 7, 111, 57),
                      child: const Text('Select Image'),
                      onPressed: _pickImage,
                    ),
                    if (_imagePath != null) Text('Image selected: $_imagePath'),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Add'),
                    onPressed: () {
                      _addService(_serviceNameController.text, _imagePath);
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Add New Service'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _serviceNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Service name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Select Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 111, 57),
                      ),
                    ),
                    if (_imagePath != null) Text('Image selected: $_imagePath'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addService(_serviceNameController.text, _imagePath);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
      },
    );
  }

  void _addService(String name, String? imagePath) async {
  if (name.isNotEmpty && imagePath != null) {
    // URL to your PHP script
    final url = Uri.parse('https://yourserver.com/path_to_php/add_service.php');

    // Create a request body
    final requestBody = {
      'name': name,
      'image': imagePath,
    };

    // Send POST request to the PHP script
    final response = await http.post(
      url,
      body: requestBody,
    );

    // Check response from the server
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          services.add({'name': name, 'image': imagePath});
          _filteredServices = services;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server.')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Add Services',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : AppBar(
              title: const Text('Add Services',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg8.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Platform.isIOS
                          ? CupertinoSearchTextField(
                              controller: _searchController,
                              placeholder: 'Search branches...',
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.541),
                            )
                          : TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search branches...',
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Platform.isIOS
                        ? CupertinoButton(
                            padding: const EdgeInsets.all(8.0),
                            color: const Color.fromARGB(255, 7, 111, 57),
                            onPressed: () {
                              _showAddServiceDialog(context);
                            },
                            child: const Icon(CupertinoIcons.add,
                                color: Colors.white),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              _showAddServiceDialog(context);
                            },
                            color: const Color.fromARGB(255, 7, 111, 57),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = _filteredServices[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                service['image']!,
                                fit: BoxFit.cover,
                                width: 270,
                                height: 150,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            child: Platform.isIOS
                                ? CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 22.0),
                                    color:
                                        const Color.fromARGB(255, 7, 111, 57),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCategoryPage()),
                                      );
                                    },
                                    child: Text(
                                      service['name']!,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 7, 111, 57),
                                      side: const BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                    onPressed: () {
                                      // Handle service button press
                                    },
                                    child: Text(
                                      service['name']!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
