import 'dart:async'; // For Timer
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:salon_appointment_app/BeautyCare/Customer/services.dart';

class BranchesPage extends StatefulWidget {
  final int shopId;
  final String? userId;

  const BranchesPage({Key? key, required this.shopId, this.userId})
      : super(key: key);

  @override
  _BranchesPageState createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBranches);
    _startPolling();
  }

  void _startPolling() {
    _fetchBranches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBranches() {
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

  Future<void> _fetchBranches() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/customer_view_branches.php?shop_id=${widget.shopId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _services = data.map((service) {
            return {
              'id': service['id'],
              'name': service['name'],
            };
          }).toList();
          _filteredServices = _services;
        });
      } else {
        print('Failed to fetch branches.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateToServicesPage(int branchId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServicesPage(
          shopId: widget.shopId,
          branchId: branchId,
          userId: widget.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle:
                  const Text('Branch', style: TextStyle(color: Colors.white)),
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
                  const Text('Branch', style: TextStyle(color: Colors.white)),
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
                              onTap: () {
                                _navigateToServicesPage(service['id']);
                              },
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
