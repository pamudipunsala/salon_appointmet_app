import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/status.dart';

class CustomerHistory extends StatefulWidget {
  const CustomerHistory({super.key});

  @override
  _CustomerHistoryState createState() => _CustomerHistoryState();
}

class _CustomerHistoryState extends State<CustomerHistory> {
  final List<Map<String, String>> customers = [
    {'date': '20.09.2024', 'branch': 'Colombo 06'},
    {'date': '20.09.2024', 'branch': 'Maharagama'},
    {'date': '20.09.2024', 'branch': 'Nugegoda'},
    {'date': '21.09.2024', 'branch': 'Kandy'},
    {'date': '20.09.2024', 'branch': 'Colombo 06'},
    {'date': '20.09.2024', 'branch': 'Maharagama'},
  ];

  String? selectedStatus;
  String? selectedBranch;
  String branchSearchText = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredCustomers = customers.where((customer) {
      final matchesBranch =
          selectedBranch == null || customer['branch'] == selectedBranch;
      return matchesBranch;
    }).toList();

    // Get unique branch names for the dropdown
    final branches =
        customers.map((customer) => customer['branch']).toSet().toList();

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Appointment History',
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
              title: const Text('Appointment History',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background/bg6.jpg',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = filteredCustomers[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentStatus(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date: ${customer['date']!}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Branch: ${customer['branch']!}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

class CustomerDetailPage extends StatelessWidget {
  final String date;
  final String branch;

  const CustomerDetailPage({Key? key, required this.date, required this.branch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        backgroundColor: const Color.fromARGB(255, 7, 111, 57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $date', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Branch: $branch', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
