import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  final String? userId;
  final String? businessTypeId;

  const SettingsPage(
      {Key? key, this.userId, this.businessTypeId})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Map<String, dynamic>> _fetchService = [];
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _branches = [];
  List<Map<String, dynamic>> _branch = [];
  List<Map<String, dynamic>> _filteredServices = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedBranch;
  String? _selectedService;

  @override
  void initState() {
    super.initState();
    _fetchShops();
    _fetchBranches();
    _fetchServices();
    _fetchBranchServices();
    _searchController.addListener(_filterServices);
  }

  Future<void> _fetchShops() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_shops.php?user_id=${widget.userId}&type_id=${widget.businessTypeId}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _services = (data as List).map((shop) {
            return {'id': shop['id'], 'name': shop['name'], 'selected': false};
          }).toList();
          _filteredServices = _services;
        });
      } else {
        print('Failed to fetch shops.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchBranchServices() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_branches.php?user_id=${widget.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Branches Response: $data');
        setState(() {
          _branch = (data as List).map((branch) {
            return {
              'id': branch['id'],
              'name': branch['name'],
              'selected': false
            };
          }).toList();
        });
      } else {
        print('Failed to fetch branches. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching branches: $e');
    }
  }

  Future<void> _fetchBranches() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_branches.php?user_id=${widget.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Branches Response: $data');
        setState(() {
          _branches = (data as List).map((branch) {
            return {
              'id': branch['id'],
              'name': branch['name'],
              'selected': false
            };
          }).toList();
        });
      } else {
        print('Failed to fetch branches. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching branches: $e');
    }
  }

  Future<void> _fetchServices() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_services.php?user_id=${widget.userId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _fetchService = (data as List).map((service) {
            return {
              'id': service['id'],
              'name': service['name'],
              'selected': false
            };
          }).toList();
        });
      } else {
        print('Failed to fetch services.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _assignBranch() async {
    final selectedShop = _services.firstWhere(
      (shop) => shop['selected'] == true,
      orElse: () => <String, dynamic>{}, // Return an empty map
    );

    final selectedBranch = _branches.firstWhere(
      (branch) => branch['selected'] == true,
      orElse: () => <String, dynamic>{}, // Return an empty map
    );

    if (selectedShop.isEmpty || selectedBranch.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both a shop and a branch.'),
        ),
      );
      return;
    }

    print('Selected Branch ID: ${selectedBranch['id']}');
    print('Selected Shop ID: ${selectedShop['id']}');
    print('Request body: ${{
      'branch_id': selectedBranch['id'].toString(),
      'shop_id': selectedShop['id'].toString()
    }}');

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/mobile_apps/appointmentApp/assign_branches.php'),
        body: {
          'branch_id': selectedBranch['id'].toString(),
          'shop_id': selectedShop['id'].toString()
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Branch assigned successfully!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to assign branch: ${data['message']}'),
            ),
          );
        }
      } else {
        throw Exception(
            'Failed to assign branch. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> _assignService() async {
    final selectedBranch = _branch.firstWhere(
      (branch) => branch['selected'] == true,
      orElse: () => <String, dynamic>{},
    );

    final selectedService = _fetchService.firstWhere(
      (service) => service['selected'] == true,
      orElse: () => <String, dynamic>{},
    );

    // Debugging: Print selected values
    print('Selected Branch: $selectedBranch');
    print('Selected Service: $selectedService');

    if (selectedBranch.isEmpty || selectedService.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both a branch and a service.'),
        ),
      );
      return;
    }

    try {
      print('Sending Branch ID: ${selectedBranch['id']}');
      print('Sending Service ID: ${selectedService['id']}');

      final response = await http.post(
        Uri.parse(
            'http://localhost/mobile_apps/appointmentApp/assign_services.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'service_id': selectedService['id'].toString(),
          'branch_id': selectedBranch['id'].toString()
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service assigned successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${data['message']}')),
          );
        }
      } else {
        throw Exception(
            'Failed to assign service. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterServices() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _services;
      } else {
        _filteredServices = _services
            .where((service) => service['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle:
                  const Text('Settings', style: TextStyle(color: Colors.white)),
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
                  const Text('Settings', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 111, 57),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
                              placeholder: 'Search shops...',
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.541),
                            )
                          : TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search shops...',
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                // Use StatefulBuilder to allow state updates within the dialog
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                    title: const Text("Select Shop"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: _services.map((service) {
                                          return RadioListTile<bool>(
                                            title: Text(service['name'] ?? ''),
                                            value: true,
                                            groupValue:
                                                service['selected'] ?? false,
                                            onChanged: (value) {
                                              setDialogState(() {
                                                // Set all services to not selected
                                                for (var s in _services) {
                                                  s['selected'] = false;
                                                }
                                                // Set the current service to selected
                                                service['selected'] = value;
                                              });
                                              setState(
                                                  () {}); // Update the main state
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Done"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _services
                                    .where((service) =>
                                        service['selected'] ?? false)
                                    .isEmpty
                                ? 'Select Shop'
                                : _services.firstWhere((service) =>
                                    service['selected'] ?? false)['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Select Branches"),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: _branches.map((branch) {
                                      return CheckboxListTile(
                                        title: Text(branch['name'] ?? ''),
                                        value: branch['selected'] ?? false,
                                        onChanged: (value) {
                                          setState(() {
                                            branch['selected'] = value;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Done"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _branches
                                    .where(
                                        (branch) => branch['selected'] ?? false)
                                    .isEmpty
                                ? 'Select Branch'
                                : _branches
                                    .where(
                                        (branch) => branch['selected'] ?? false)
                                    .map((branch) => branch['name'])
                                    .join(', '),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0), // Add spacing before the button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        color: const Color.fromARGB(
                            255, 7, 111, 57), // Button color
                        onPressed: () {
                          _assignBranch();
                        },
                        child: const Text(
                          'Assign Branch',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _assignBranch();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 7, 111, 57), // Button color
                        ),
                        child: const Text(
                          'Assign Branch',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                    title: const Text("Select Branch"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: _branch.map((branch) {
                                          return RadioListTile<bool>(
                                            title: Text(branch['name'] ?? ''),
                                            value: true,
                                            groupValue:
                                                branch['selected'] ?? false,
                                            onChanged: (value) {
                                              setDialogState(() {
                                                // Set all branchs to not selected
                                                for (var s in _branch) {
                                                  s['selected'] = false;
                                                }
                                                // Set the current shop to selected
                                                branch['selected'] = value;
                                              });
                                              setState(() {
                                                branch['selected'] = value;
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Done"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _branch
                                    .where(
                                        (branch) => branch['selected'] ?? false)
                                    .isEmpty
                                ? 'Select Branch'
                                : _branch.firstWhere((branch) =>
                                    branch['selected'] ?? false)['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Select Service"),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: _fetchService.map((service) {
                                      return CheckboxListTile(
                                        title: Text(service['name'] ?? ''),
                                        value: service['selected'] ?? false,
                                        onChanged: (value) {
                                          setState(() {
                                            service['selected'] = value;
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Done"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _fetchService
                                    .where((service) =>
                                        service['selected'] ?? false)
                                    .isEmpty
                                ? 'Select Service'
                                : _fetchService
                                    .where((service) =>
                                        service['selected'] ?? false)
                                    .map((service) => service['name'])
                                    .join(', '),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        color: const Color.fromARGB(
                            255, 7, 111, 57), // Button color
                        onPressed: () {
                          _assignService();
                        },
                        child: const Text(
                          'Assign Service',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _assignService();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 7, 111, 57),
                        ),
                        child: const Text(
                          'Assign Service',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
