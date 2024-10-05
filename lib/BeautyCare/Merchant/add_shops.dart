import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class AddShopsPage extends StatefulWidget {
  const AddShopsPage({super.key});

  @override
  _AddShopsPageState createState() => _AddShopsPageState();
}

class _AddShopsPageState extends State<AddShopsPage> {
  final List<Map<String, dynamic>> services = [
    {'name': 'Salon CB', 'image': 'assets/images/img10.jpeg'},
    {'name': 'Salon Neesha Manahari', 'image': 'assets/images/img11.jpeg'},
    {'name': 'Brides by Udara Malshan', 'image': 'assets/images/img12.jpeg'},
    {'name': 'Salon Boneetha', 'image': 'assets/images/img13.jpeg'},
    {'name': 'The Blushing Nor', 'image': 'assets/images/img14.jpeg'},
  ];

  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addShops(String name, String? imagePath) async {
    if (name.isNotEmpty && imagePath != null) {
      try {
        var requestData = {
          'name': name,
          'image_path': imagePath,
        };

        // Log the data being sent for debugging
        print('Sending Data: $requestData');

        // Send the data using HTTP POST
        var response = await http.post(
          Uri.parse(
              'http://192.168.8.116/mobile_apps/appointmentApp/add_shops.php'),
          body: requestData,
        );

        // Log the response from the server
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            setState(() {
              services.add({'name': name, 'image': imagePath});
              _filteredServices = services;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shop added successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseData['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to add shop. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a shop name and select an image.')),
      );
    }
  }

  void _showAddShopDialog(BuildContext context) {
    final TextEditingController _shopNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Add New Shops'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoTextField(
                      controller: _shopNameController,
                      placeholder: 'Enter Shops name',
                    ),
                    const SizedBox(height: 10),
                    CupertinoButton(
                      color: const Color.fromARGB(255, 7, 111, 57),
                      child: const Text('Select Image'),
                      onPressed: _pickImage,
                    ),
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
                      String shopName = _shopNameController.text.trim();
                      _addShops(shopName, _image?.path);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Add New Shops'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _shopNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Shops name',
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
                      String shopName = _shopNameController.text.trim();
                      _addShops(shopName, _image?.path);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Add Shops',
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
              title: const Text('Add Shops',
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
                              placeholder: 'Search shops...',
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.541),
                            )
                          : TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search shops...',
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
                              _showAddShopDialog(context);
                            },
                            child: const Text('Add Shop'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _showAddShopDialog(context);
                            },
                            child: const Text('Add Shop'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 111, 57),
                            ),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = _filteredServices[index];
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                        leading: Image.asset(
                          service['image'],
                          width: 50,
                          height: 50,
                        ),
                        title: Text(service['name']),
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
