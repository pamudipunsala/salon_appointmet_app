import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/categories.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, dynamic>> services = [
    {'name': 'Facials', 'image': 'assets/images/img4.png'},
    {'name': 'Menicures', 'image': 'assets/images/img5.png'},
    {'name': 'Pedicures', 'image': 'assets/images/img6.png'},
    {'name': 'Dressings', 'image': 'assets/images/img7.png'},
    {'name': 'Waxing', 'image': 'assets/images/img8.png'},
  ];

  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredServices = services;
    _searchController.addListener(_filterServices);
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
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

  @override
  void dispose() {
    _searchController.removeListener(_filterServices);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle:
                  const Text('Services', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
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
                                        const Color.fromARGB(255, 152, 11, 58),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryPage()),
                                      );
                                    },
                                    child: Text(
                                      service['name']!,
                                      style: const TextStyle(fontSize: 16.0),
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
