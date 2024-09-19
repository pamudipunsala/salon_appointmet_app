import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductsPage extends StatefulWidget {
  const AddProductsPage({super.key});

  @override
  _AddProductsPageState createState() => _AddProductsPageState();
}

class _AddProductsPageState extends State<AddProductsPage> {
  final List<Map<String, dynamic>> products = [
    {'name': 'Hair cream', 'image': 'assets/images/img21.jpg'},
    {'name': 'Hair Oil', 'image': 'assets/images/img22.jpg'},
    {'name': 'Whitening Cream', 'image': 'assets/images/img23.jpg'},
    {'name': 'Body Lotion', 'image': 'assets/images/img24.jpeg'},
    {'name': 'Foot Cream', 'image': 'assets/images/img25.png'},
    {'name': 'Hair cream', 'image': 'assets/images/img21.jpg'},
    {'name': 'Hair Oil', 'image': 'assets/images/img22.jpg'},
    {'name': 'Whitening Cream', 'image': 'assets/images/img23.jpg'},
    {'name': 'Body Lotion', 'image': 'assets/images/img24.jpeg'},
    {'name': 'Foot Cream', 'image': 'assets/images/img25.png'},
    {'name': 'Hair cream', 'image': 'assets/images/img21.jpg'},
    {'name': 'Hair Oil', 'image': 'assets/images/img22.jpg'},
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _imagePath;

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = products;
      } else {
        _filteredProducts = products
            .where((product) => product['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredProducts = products;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
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
        products.add({'name': name, 'image': imagePath});
        _filteredProducts = products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Add Products',
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
              title: const Text('Add Products',
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2, // Adjust to fit the images
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product =
                          _filteredProducts[index]; // Use filtered list
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
                                        product['name']!,
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 152, 11, 58),
                                      onPressed: () {},
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 152, 11, 58),
                                      side: const BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                    onPressed: () {
                                      // Handle product button press
                                    },
                                    child: Text(
                                      product['name']!,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
