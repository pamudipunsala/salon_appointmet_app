import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({super.key});

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  // List of customers with names and phone numbers for demonstration
  final List<Map<String, String>> customers = [
    {'name': 'John Doe', 'phone': '0773456789'},
    {'name': 'Jane Smith', 'phone': '0783456678'},
    {'name': 'Alice Johnson', 'phone': '0713423456'},
    {'name': 'Bob Williams', 'phone': '0774567876'},
    {'name': 'John Doe', 'phone': '0773456789'},
    {'name': 'Jane Smith', 'phone': '0783456678'},
    {'name': 'Alice Johnson', 'phone': '0713423456'},
    {'name': 'Bob Williams', 'phone': '0774567876'},
  ];

  List<Map<String, dynamic>> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = customers;
      } else {
        _filteredCustomers = customers
            .where(
                (customer) => customer['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredCustomers = customers;
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCustomers);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Customers',
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
              title: const Text('Customers',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Column(
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
                        onPressed: () {},
                        child:
                            const Icon(CupertinoIcons.add, color: Colors.white),
                      )
                    : IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {},
                        color: const Color.fromARGB(255, 152, 11, 58),
                      ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
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
                            // Customer details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                            // Edit button at the right bottom corner
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
