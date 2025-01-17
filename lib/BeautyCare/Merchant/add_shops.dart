import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddShopsPage extends StatefulWidget {
  final String? userId;
  final String? businessTypeId;

  const AddShopsPage({Key? key, this.userId, this.businessTypeId})
      : super(key: key);

  @override
  _AddShopsPageState createState() => _AddShopsPageState();
}

class _AddShopsPageState extends State<AddShopsPage> {
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchShops();
    _searchController.addListener(_filterServices);
  }

  Future<void> _fetchShops() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_shops.php?user_id=${widget.userId}&type_id=${widget.businessTypeId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _services = data.map((shop) {
            return {
              'name': shop['name'],
              'image': shop['image'],
            };
          }).toList();
          _filteredServices = _services;
        });
      } else {
        print('Failed to fetch shops.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterServices() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _services;
      } else {
        _filteredServices = _services
            .where((service) => service['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addShops(String name, File? imageFile, String? businessTypeId,
      String? userId) async {
    if (name.isNotEmpty &&
        imageFile != null &&
        userId != null &&
        businessTypeId != null) {
      try {
        var uri = Uri.parse(
            'http://localhost/mobile_apps/appointmentApp/add_shops.php');
        var request = http.MultipartRequest('POST', uri);

        request.fields['name'] = name;
        request.fields['type_id'] = businessTypeId;
        request.fields['user_id'] = userId;

        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));

        var response = await request.send();
        var responseData = await http.Response.fromStream(response);

        if (responseData.body.isNotEmpty && responseData.statusCode == 200) {
          var jsonData = jsonDecode(responseData.body);
          if (jsonData['success'] == true) {
            _fetchShops();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shop added successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${jsonData['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid response from the server')),
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
            content: Text(
                'Please enter a shop name, select an image, and ensure required details are provided.')),
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
                      _addShops(
                        shopName,
                        _image,
                        widget.businessTypeId, // Pass businessTypeId
                        widget.userId,
                      );
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
                      _addShops(
                        shopName,
                        _image,
                        widget.businessTypeId, // Pass businessTypeId
                        widget.userId,
                      );
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
                child: _filteredServices.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredServices.length,
                        itemBuilder: (context, index) {
                          final service = _filteredServices[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text(service['name']),
                              leading: Image.network(
                                'http://localhost/mobile_apps/appointmentApp/${service['image']}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Implement delete functionality if needed
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text('No shops found')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
