import 'dart:async'; // For Timer
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart'; // For getting file name
import 'package:mime/mime.dart'; // For detecting mime type
import 'package:http_parser/http_parser.dart'; // For sending the file with multipart

class AddServicesPage extends StatefulWidget {
  final String? userId;
  final String? businessTypeId;

  const AddServicesPage(
      {Key? key, required this.userId, required this.businessTypeId})
      : super(key: key);

  @override
  _AddServicesPageState createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _imagePath;
  Timer? _timer; // Timer for polling

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterServices);
    _startPolling(); // Start polling for updates
  }

  // Start polling the server every 10 seconds
  void _startPolling() {
    _fetchServices(); // Initial fetch
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _fetchServices();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredServices = query.isEmpty
          ? _services
          : _services
              .where(
                  (service) => service['name']!.toLowerCase().contains(query))
              .toList();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _showAddServiceDialog(BuildContext context) {
    final TextEditingController _serviceNameController =
        TextEditingController();
    final TextEditingController _timeController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    String timeUnit = "hours"; // Default to hours

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Time',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 2,
                      child: DropdownButton<String>(
                        value: timeUnit,
                        onChanged: (String? newValue) {
                          setState(() {
                            timeUnit = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "hours",
                            child: Text("Hours"),
                          ),
                          DropdownMenuItem(
                            value: "minutes",
                            child: Text("Minutes"),
                          ),
                          DropdownMenuItem(
                            value: "seconds",
                            child: Text("Seconds"),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Enter Price',
                ),
                keyboardType: TextInputType.number,
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
                final serviceName = _serviceNameController.text;
                final time = _formatTime(
                  int.tryParse(_timeController.text) ?? 0,
                  timeUnit,
                );
                final price = _priceController.text;

                _addService(serviceName, time, price);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int value, String unit) {
    if (value <= 0) {
      return '00:00:00'; 
    }

    switch (unit) {
      case "hours":
        return '${value.toString().padLeft(2, '0')}:00:00';
      case "minutes":
        return '00:${value.toString().padLeft(2, '0')}:00';
      case "seconds":
        return '00:00:${value.toString().padLeft(2, '0')}';
      default:
        return '00:00:00';
    }
  }

  Future<void> _addService(String name, String time, String price) async {
    var url = Uri.parse(
        "http://localhost/mobile_apps/appointmentApp/add_services.php");

    var request = http.MultipartRequest('POST', url);

    // Add text fields
    request.fields['name'] = name;
    request.fields['time'] = time;
    request.fields['price'] = price;
    request.fields['shop_id'] = '';
    request.fields['category_id'] = '1';

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Response: $responseBody'); // Log the response for debugging
        _fetchServices();
      } else {
        print('Failed to add service: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _fetchServices() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_services.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _services = data.map((shop) {
            return {
              'name': shop['name'],
            };
          }).toList();
          _filteredServices = _services;
        });
      } else {
        print('Failed to fetch services.');
      }
    } catch (e) {
      print('Error: $e');
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
                              placeholder: 'Search services...',
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.541),
                            )
                          : TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search services...',
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    Platform.isIOS
                        ? CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: const Color.fromARGB(255, 7, 111, 57),
                            onPressed: () => _showAddServiceDialog(context),
                            child: const Text('Add Service'),
                          )
                        : ElevatedButton(
                            onPressed: () => _showAddServiceDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 111, 57),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: const Text('Add Service'),
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
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // delete functionality
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
