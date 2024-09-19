import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/add_staff.dart';

class StaffDetailsPage extends StatefulWidget {
  const StaffDetailsPage({super.key});

  @override
  _StaffDetailsPageState createState() => _StaffDetailsPageState();
}

class _StaffDetailsPageState extends State<StaffDetailsPage> {
  // List of customers with names and phone numbers for demonstration
  final List<Map<String, String>> customers = [
    {'employeeNumber': 'E001', 'name': 'John Doe', 'phone': '0773456789'},
    {'employeeNumber': 'E002', 'name': 'Jane Smith', 'phone': '0783456678'},
    {'employeeNumber': 'E003', 'name': 'Alice Johnson', 'phone': '0713423456'},
    {'employeeNumber': 'E004', 'name': 'Bob Williams', 'phone': '0774567876'},
    {'employeeNumber': 'E005', 'name': 'John Doe', 'phone': '0773456789'},
    {'employeeNumber': 'E006', 'name': 'Jane Smith', 'phone': '0783456678'},
    {'employeeNumber': 'E007', 'name': 'Alice Johnson', 'phone': '0713423456'},
    {'employeeNumber': 'E008', 'name': 'Bob Williams', 'phone': '0774567876'},
  ];

  List<Map<String, dynamic>> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCustomers = customers; // Initially display all customers
    _searchController.addListener(_filtercustomers); // Filter as the user types
  }

  void _filtercustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = customers; // Show all customers if query is empty
      } else {
        _filteredCustomers = customers
            .where((service) =>
                service['name']!.toLowerCase().contains(query) ||
                service['employeeNumber']!.toLowerCase().contains(query) ||
                service['phone']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Staff Details',
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
              title: const Text('Staff Details',
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddStaffDetailsPage()));
                            },
                            child: const Icon(CupertinoIcons.add,
                                color: Colors.white),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddStaffDetailsPage()));
                            },
                            color: const Color.fromARGB(255, 152, 11, 58),
                          ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Staff details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer['employeeNumber']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  customer['name']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  customer['phone']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            // Edit button
                            IconButton(
                              onPressed: () {
                                // Handle edit action
                                print('Edit ${customer['name']}');
                              },
                              icon:
                                  const Icon(Icons.edit, color: Colors.black54),
                            ),
                          ],
                        ),
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
