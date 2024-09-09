import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/views/categories.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // List of services and image paths for demonstration
    final services = [
      {'name': 'Gold Facial', 'image': 'assets/images/img15.jpeg'},
      {'name': 'Clean Up', 'image': 'assets/images/img16.jpg'},
      {'name': 'Pimple treatment', 'image': 'assets/images/img17.png'},
      {'name': 'Laser Treatment', 'image': 'assets/images/img18.png'},
      {'name': 'Brightning Treatment', 'image': 'assets/images/img19.png'},
      {'name': 'Whitening Treatment', 'image': 'assets/images/img20.png'},
    ];

    List<Map<String, dynamic>> _filteredServices = [];
    final TextEditingController _searchController = TextEditingController();

    void _filterServices() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          // Show all orders when the search query is empty
          _filteredServices = services;
        } else {
          // Filter orders based on the search query
          _filteredServices = services
              .where((order) => order['name']!.toLowerCase().contains(query))
              .toList();
        }
      });
    }

    @override
    void initState() {
      super.initState();
      _filteredServices = services;
      _searchController.addListener(_filterServices);
    }

    @override
    void dispose() {
      _searchController.removeListener(_filterServices);
      _searchController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Categories',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              leading: Builder(builder: (BuildContext context) {
                return CupertinoNavigationBarBackButton(
                  color: Colors.white, // Set the desired color here
                  onPressed: () {
                    Navigator.of(context).pop(); // Define the back action
                  },
                );
              }))
          : AppBar(
              title: const Text(
                'Categories',
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
          ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
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
                    // Button with service name
                    Positioned(
                      bottom: 50,
                      child: Platform.isIOS
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white,
                                    width:
                                        2), // White border for CupertinoButton
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 22.0),
                                child: Text(
                                  service['name']!,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                color: Color.fromARGB(255, 152, 11, 58),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CategoryPage()),
                                  );
                                },
                              ))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 152, 11, 58),
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              onPressed: () {
                                // Handle service button press
                              },
                              child: Text(
                                service['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
