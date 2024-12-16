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

class ServicesPage extends StatefulWidget {
  final String? shopId;

  const ServicesPage(
      {Key? key, required this.shopId})
      : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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

  Future<void> _fetchServices() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_services.php?user_id=${widget.shopId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _services = data.map((service) {
            return {'name': service['name'], 'time': service['time']};
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
              middle:
                  const Text('Services', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : AppBar(
              title:
                  const Text('Services', style: TextStyle(color: Colors.white)),
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
                              subtitle: Text('Time: ${service['time']}'),
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
                    : const Center(child: Text('No services found')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
