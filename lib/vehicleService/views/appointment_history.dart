import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentHistory extends StatefulWidget {
  const AppointmentHistory({super.key});

  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState();
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  // List of customers with names and phone numbers for demonstration
  final List<Map<String, String>> customers = [
    {
      'name': 'John Doe',
      'date': '20.09.2024',
      'time': '08.30 a.m.',
      'phone': '0773456789'
    },
    {
      'name': 'Jane Smith',
      'date': '20.09.2024',
      'time': '10.30 a.m.',
      'phone': '0783456678'
    },
    {
      'name': 'Alice Johnson',
      'date': '20.09.2024',
      'time': '02.00 a.m.',
      'phone': '0713423456'
    },
    {
      'name': 'Bob Williams',
      'date': '21.09.2024',
      'time': '01.30 a.m.',
      'phone': '0774567876'
    },
    {
      'name': 'John Doe',
      'date': '21.09.2024',
      'time': '02.00 a.m.',
      'phone': '0773456789'
    },
    {
      'name': 'Jane Smith',
      'date': '21.09.2024',
      'time': '04.15 a.m.',
      'phone': '0783456678'
    },
    {
      'name': 'Alice Johnson',
      'date': '22.09.2024',
      'time': '09.30 a.m.',
      'phone': '0713423456'
    },
    {
      'name': 'Bob Williams',
      'date': '22.09.2024',
      'time': '10.30 a.m.',
      'phone': '0774567876'
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
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
                            customer['date']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            customer['time']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
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
                        icon: const Icon(Icons.edit, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
