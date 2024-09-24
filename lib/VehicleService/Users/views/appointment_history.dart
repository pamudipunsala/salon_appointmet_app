import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({super.key});

  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  // List of customers with names, phone numbers, statuses, and branches
  final List<Map<String, String>> customers = [
    {
      'name': 'John Doe',
      'date': '20.09.2024',
      'time': '08.30 a.m.',
      'phone': '0773456789',
      'branch': 'Colombo 06',
      'status': 'Approved'
    },
    {
      'name': 'Jane Smith',
      'date': '20.09.2024',
      'time': '10.30 a.m.',
      'phone': '0783456678',
      'branch': 'Maharagama',
      'status': 'Hold'
    },
    {
      'name': 'Alice Johnson',
      'date': '20.09.2024',
      'time': '02.00 a.m.',
      'phone': '0713423456',
      'branch': 'Nugegoda',
      'status': 'Cancelled'
    },
    {
      'name': 'Bob Williams',
      'date': '21.09.2024',
      'time': '01.30 a.m.',
      'phone': '0774567876',
      'branch': 'Kandy',
      'status': 'Approved'
    },
    {
      'name': 'John Doe',
      'date': '20.09.2024',
      'time': '08.30 a.m.',
      'phone': '0773456789',
      'branch': 'Colombo 06',
      'status': 'Approved'
    },
    {
      'name': 'Jane Smith',
      'date': '20.09.2024',
      'time': '10.30 a.m.',
      'phone': '0783456678',
      'branch': 'Maharagama',
      'status': 'Hold'
    },
  ];

  String? selectedStatus;
  String? selectedBranch;
  String branchSearchText = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredCustomers = customers.where((customer) {
      final matchesStatus =
          selectedStatus == null || customer['status'] == selectedStatus;
      final matchesBranch =
          selectedBranch == null || customer['branch'] == selectedBranch;
      return matchesStatus && matchesBranch;
    }).toList();

    // Get unique branch names for the dropdown
    final branches =
        customers.map((customer) => customer['branch']).toSet().toList();

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Appointment History',
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
              title: const Text('Appointment History',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/img3.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
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
                  child: DropdownButton<String?>(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    value: selectedStatus,
                    hint: const Text('Filter by Status'),
                    icon: const Icon(Icons.arrow_downward),
                    isExpanded: true,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 152, 11, 58),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    },
                    items: <String>['Approved', 'Hold', 'Cancelled', 'All']
                        .map<DropdownMenuItem<String?>>((String value) {
                      return DropdownMenuItem<String?>(
                        value: value == 'All' ? null : value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = filteredCustomers[index];
                    final status = customer['status'] ?? 'Unknown';

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
                                  'Name: ${customer['name']!}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${customer['date']!}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Time: ${customer['time']!}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Contact: ${customer['phone']!}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Branch: ${customer['branch']!}', 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            // Status instead of edit button
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: status == 'Approved'
                                    ? Colors.green
                                    : status == 'Hold'
                                        ? Colors.orange
                                        : Colors.red,
                              ),
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