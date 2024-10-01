import 'dart:convert';
import 'dart:io' show Platform;
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

    // Check the platform and request the corresponding permission
    if (Platform.isAndroid) {
      permissionStatus = await Permission.storage.status;
    } else if (Platform.isIOS) {
      permissionStatus = await Permission.photos.status;
    } else {
      return;
    }

    // Check if permission is granted
    if (permissionStatus.isGranted) {
      print("Permission granted, opening gallery...");
      // If already granted, proceed to pick the image
      final XFile? image =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
          print("Image selected: $_imagePath");
        });
      } else {
        print("No image selected");
      }
    } else if (permissionStatus.isDenied) {
      print("Permission denied, requesting permission...");
      // If denied, request permission again
      if (Platform.isAndroid) {
        permissionStatus = await Permission.storage.request();
      } else if (Platform.isIOS) {
        permissionStatus = await Permission.photos.request();
      }

      if (permissionStatus.isGranted) {
        print("Permission granted after request, opening gallery...");
        // If permission is granted after the request, proceed to pick the image
        final XFile? image =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _imagePath = image.path;
            print("Image selected: $_imagePath");
          });
        } else {
          print("No image selected");
        }
      } else if (permissionStatus.isDenied) {
        print("Permission still denied");
        // If still denied, show a message or handle accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permission denied to access the gallery.')),
        );
      }
    } else if (permissionStatus.isPermanentlyDenied) {
      print("Permission permanently denied, redirecting to settings...");
      // If permanently denied, redirect to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Please enable gallery access from the settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
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
                      _addShops(_shopNameController.text, _imagePath);
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
                      _addShops(_shopNameController.text, _imagePath);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
      },
    );
  }

  void _addShops(String name, String? imagePath) async {
    if (name.isNotEmpty && imagePath != null) {
      var requestData = {
        'name': name,
        'image_path': imagePath,
      };

      var response = await http.post(
        Uri.parse('http://localhost/mobile_apps/appointmentApp/add_shops.php'),
        body: requestData,
      );

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
          const SnackBar(content: Text('Failed to add shop')),
        );
      }
    }
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
                            child: const Icon(CupertinoIcons.add,
                                color: Colors.white),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              _showAddShopDialog(context);
                            },
                            color: const Color.fromARGB(255, 7, 111, 57),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = _filteredServices[index];
                      return Stack(
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
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Platform.isIOS
                                ? CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 22.0),
                                    color:
                                        const Color.fromARGB(255, 7, 111, 57),
                                    onPressed: () {},
                                    child: Text(
                                      service['name']!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 7, 111, 57),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 22.0),
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      service['name']!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
