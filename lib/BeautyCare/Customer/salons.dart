import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/services.dart';

class SalonBranchesPage extends StatefulWidget {
  const SalonBranchesPage({super.key});

  @override
  _SalonBranchesPageState createState() => _SalonBranchesPageState();
}

class _SalonBranchesPageState extends State<SalonBranchesPage> {
  final List<Map<String, dynamic>> services = [
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

  @override
  void initState() {
    super.initState();
    _filteredServices = services; // Initially display all services
    _searchController.addListener(_filterServices); // Filter as the user types
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredServices = services; // Show all services if query is empty
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
                  const Text('Salons', style: TextStyle(color: Colors.white)),
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
                  const Text('Salons', style: TextStyle(color: Colors.white)),
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
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ServicesPage()));
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
                                    onPressed: () {},
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
