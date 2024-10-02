import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({super.key});

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  List<Map<String, String>> _filteredCustomers = [];
  final TextEditingController _searchController = TextEditingController();
  String userId = "1";

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Show all customers when no search query
        fetchCustomerData();
      } else {
        _filteredCustomers = _filteredCustomers
            .where(
                (customer) => customer['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerData();
    _searchController.addListener(_filterCustomers);
  }

  Future<void> fetchCustomerData() async {
    try {
      var url = Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/fetch_customers.php');
      var response = await http.post(url, body: {'type_id': '1'});

      if (response.statusCode == 200) {
        // Decode the JSON response
        var data = json.decode(response.body);

        // Check if it's an error response
        if (data is List) {
          setState(() {
            _filteredCustomers =
                List<Map<String, String>>.from(data.map((item) => {
                      'name': item['name'] as String,
                      'phone': item['phone'] as String,
                      'email': item['email'] as String,
                    }));
          });
        } else if (data is Map && data.containsKey("error")) {
          print("Error: ${data['error']}");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
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
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
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
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
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
                          placeholder: 'Search customers...',
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 0.541),
                        )
                      : TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search customers...',
                            border: OutlineInputBorder(),
                            fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
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
                _filteredCustomers.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = _filteredCustomers[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Customer details
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 4),
                                      Text(
                                        customer['email']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
