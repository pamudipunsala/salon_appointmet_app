import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddSalonBranchesPage extends StatefulWidget {
  const AddSalonBranchesPage({super.key});

  @override
  _AddSalonBranchesPageState createState() => _AddSalonBranchesPageState();
}

class _AddSalonBranchesPageState extends State<AddSalonBranchesPage> {
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

  void _showAddSalonDialog(BuildContext context) {
    final TextEditingController _salonNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Add New Branch'),
                content: Column(
                  children: [
                    CupertinoTextField(
                      controller: _salonNameController,
                      placeholder: 'Enter branch name',
                    ),
                    const SizedBox(height: 10),
                    CupertinoButton(
                      color: const Color.fromARGB(255, 152, 11, 58),
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
                      _addSalon(_salonNameController.text, _imagePath);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Add New Branch'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _salonNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter branch name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Select Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 152, 11, 58),
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
                      _addSalon(_salonNameController.text, _imagePath);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
      },
    );
  }

  void _addSalon(String name, String? imagePath) {
    if (name.isNotEmpty && imagePath != null) {
      setState(() {
        services.add({'name': name, 'image': imagePath});
        _filteredServices = services;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Add Branches',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : AppBar(
              title: const Text('Add Branches',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img3.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
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
                            color: const Color.fromARGB(255, 152, 11, 58),
                            onPressed: () {
                              _showAddSalonDialog(context);
                            },
                            child: const Icon(CupertinoIcons.add,
                                color: Colors.white),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              _showAddSalonDialog(context);
                            },
                            color: const Color.fromARGB(255, 152, 11, 58),
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
                                        const Color.fromARGB(255, 152, 11, 58),
                                    onPressed: () {},
                                    child: Text(
                                      service['name']!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 152, 11, 58),
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
