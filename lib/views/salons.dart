import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SalonBranchesPage extends StatefulWidget {
  const SalonBranchesPage({super.key});

  @override
  _SalonBranchesPageState createState() => _SalonBranchesPageState();
}

class _SalonBranchesPageState extends State<SalonBranchesPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // List of services and image paths for demonstration
    final services = [
      {'name': 'Colombo 05', 'image': 'assets/images/img10.jpeg'},
      {'name': 'Nugegoda', 'image': 'assets/images/img11.jpeg'},
      {'name': 'Maharagama', 'image': 'assets/images/img12.jpeg'},
      {'name': 'Gampaha', 'image': 'assets/images/img13.jpeg'},
      {'name': 'Kandy', 'image': 'assets/images/img14.jpeg'},
      {'name': 'Colombo 05', 'image': 'assets/images/img10.jpeg'},
      {'name': 'Nugegoda', 'image': 'assets/images/img11.jpeg'},
      {'name': 'Maharagama', 'image': 'assets/images/img12.jpeg'},
      {'name': 'Gampaha', 'image': 'assets/images/img13.jpeg'},
      {'name': 'Kandy', 'image': 'assets/images/img14.jpeg'},
      {'name': 'Colombo 05', 'image': 'assets/images/img10.jpeg'},
      {'name': 'Nugegoda', 'image': 'assets/images/img11.jpeg'},
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
              middle:
                  const Text('Salons', style: TextStyle(color: Colors.white)),
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
                'Salons',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 2, // Adjust to fit the images
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
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
                    // Button with service name
                    Positioned(
                      bottom: 20,
                      child: Platform.isIOS
                          ? Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 22.0),
                                child: Text(
                                  service['name']!,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                color: const Color.fromARGB(255, 152, 11, 58),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
