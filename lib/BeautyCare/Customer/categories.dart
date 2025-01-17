import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/appointment.dart'; // For date formatting

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Sample prices for each service
  final Map<String, double> servicePrices = {
    'Gold Facial': 120.0,
    'Clean Up': 80.0,
    'Pimple treatment': 100.0,
    'Laser Treatment': 200.0,
    'Brightning Treatment': 150.0,
    'Whitening Treatment': 180.0,
  };

  // List of services
  final List<Map<String, dynamic>> categories = [
    {'name': 'Gold Facial', 'image': 'assets/images/img15.jpeg'},
    {'name': 'Clean Up', 'image': 'assets/images/img16.jpg'},
    {'name': 'Pimple treatment', 'image': 'assets/images/img17.png'},
    {'name': 'Laser Treatment', 'image': 'assets/images/img18.png'},
    {'name': 'Brightning Treatment', 'image': 'assets/images/img19.png'},
    {'name': 'Whitening Treatment', 'image': 'assets/images/img20.png'},
  ];

  // Controllers for date, time, and number of people
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Filtered list of categories
  List<Map<String, dynamic>> _filteredCategories = [];

  // Method to filter categories based on search query
  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = categories;
      } else {
        _filteredCategories = categories
            .where(
              (service) => service['name']!.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredCategories = categories;
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCategories);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Categories',
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
              title: const Text('Categories',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg7.jpg',
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
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Platform.isIOS
                    ? CupertinoSearchTextField(
                        controller: _searchController,
                        placeholder: 'Search service categories...',
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.541),
                      )
                    : TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search service categories...',
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                        ),
                      ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final service = _filteredCategories[index];
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
                                                  AppointmentPage(
                                                    shopId: 0,
                                                    branchId: 0,
                                                    serviceId: service['id'],
                                                  )));
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AppointmentPage(
                                                    branchId: 0,
                                                    shopId: 0,
                                                    serviceId: 0,
                                                  )));
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
