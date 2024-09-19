import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddOffersPage extends StatefulWidget {
  const AddOffersPage({super.key});

  @override
  _AddOffersPageState createState() => _AddOffersPageState();
}

class _AddOffersPageState extends State<AddOffersPage> {
  List<Map<String, dynamic>> _filteredOffers = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _imagePath;

  // List of offers and image paths for demonstration
  final offers = [
    {'name': 'Product 1', 'image': 'assets/images/img26.png'},
    {'name': 'Product 2', 'image': 'assets/images/img27.png'},
    {'name': 'Product 3', 'image': 'assets/images/img28.png'},
    {'name': 'Product 4', 'image': 'assets/images/img29.jpeg'},
    {'name': 'Product 5', 'image': 'assets/images/img30.png'},
    {'name': 'Product 6', 'image': 'assets/images/img26.png'},
    {'name': 'Product 7', 'image': 'assets/images/img27.png'},
    {'name': 'Product 8', 'image': 'assets/images/img28.png'},
    {'name': 'Product 9', 'image': 'assets/images/img29.jpeg'},
    {'name': 'Product 10', 'image': 'assets/images/img30.png'},
  ];

  void _filterOffers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOffers = offers;
      } else {
        _filteredOffers = offers
            .where((product) => product['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredOffers = offers;
    _searchController.addListener(_filterOffers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterOffers);
    _searchController.dispose();
    super.dispose();
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
                title: const Text('Add New Salon'),
                content: Column(
                  children: [
                    CupertinoTextField(
                      controller: _salonNameController,
                      placeholder: 'Enter salon name',
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
                title: const Text('Add New Salon'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _salonNameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter salon name',
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
        offers.add({'name': name, 'image': imagePath});
        _filteredOffers = offers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle:
                  const Text('Offers', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              leading: Builder(builder: (BuildContext context) {
                return CupertinoNavigationBarBackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
              }))
          : AppBar(
              title: const Text(
                'Offers',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
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
          Column(children: [
            // Search bar
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 2, // Adjust to fit the images
                  ),
                  itemCount: _filteredOffers.length,
                  itemBuilder: (context, index) {
                    final product = _filteredOffers[index];
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
                              product['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        // Button with product name
                        Positioned(
                          bottom: 20,
                          child: Platform.isIOS
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 22.0),
                                    child: Text(
                                      'Apply Now',
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    color:
                                        const Color.fromARGB(255, 152, 11, 58),
                                    onPressed: () {},
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 152, 11, 58),
                                    side: const BorderSide(
                                        color: Colors.white, width: 2),
                                  ),
                                  onPressed: () {
                                    // Handle product button press
                                  },
                                  child: Text(
                                    'Apply Now',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
