import 'dart:async'; // For Timer
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddBranchesPage extends StatefulWidget {
  final String? userId;
  final String? businessTypeId;

  const AddBranchesPage(
      {Key? key, required this.userId, required this.businessTypeId})
      : super(key: key);

  @override
  _AddBranchesPageState createState() => _AddBranchesPageState();
}

class _AddBranchesPageState extends State<AddBranchesPage> {
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

  void _showAddServiceDialog(BuildContext context) {
    final TextEditingController _branchNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add New Branch'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _branchNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Branch name',
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    final serviceName = _branchNameController.text;

                    _addBranches(
                      serviceName,
                      widget.userId,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addBranches(String name, String? userId) async {
    if (userId == null || userId.isEmpty) {
      print('Error: userId is null or empty');
      return;
    }

    var url = Uri.parse(
        "http://localhost/mobile_apps/appointmentApp/add_branches.php");

    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = name;
    request.fields['user_id'] = userId;

    try {
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Server Response: $responseBody');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['status'] == 'success') {
          _fetchBranches();

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Branch added successfully!'),
                backgroundColor: Colors.black,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          print('Failed to add branch: ${jsonResponse['message']}');

          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${jsonResponse['message']}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        print('Failed to connect: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred: $e');

      // Show error message for unexpected issues
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _fetchBranches() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_branches.php?user_id=${widget.userId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _services = data.map((service) {
            return {'name': service['name']};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Add Branch',
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
              title: const Text('Add Branch',
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: const Color.fromARGB(255, 7, 111, 57),
                            onPressed: () => _showAddServiceDialog(context),
                            child: const Text('Add Branch'),
                          )
                        : ElevatedButton(
                            onPressed: () => _showAddServiceDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 111, 57),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            child: const Text('Add Branch'),
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
                    : const Center(child: Text('No services found')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
