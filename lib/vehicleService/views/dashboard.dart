import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/views/appointment_summary.dart';
import 'package:salon_appointment_app/views/customers.dart';
import 'package:salon_appointment_app/views/menu.dart';
import 'package:salon_appointment_app/views/offers.dart';
import 'package:salon_appointment_app/views/products.dart';
import 'package:salon_appointment_app/views/salons.dart';
import 'package:salon_appointment_app/views/services.dart';
import 'package:salon_appointment_app/views/staff.dart';

class VehicleDashboardPage extends StatefulWidget {
  const VehicleDashboardPage({super.key});

  @override
  _VehicleDashboardPageState createState() => _VehicleDashboardPageState();
}

class _VehicleDashboardPageState extends State<VehicleDashboardPage> {
  // List of dashboard items with text and icons
  final List<Map<String, dynamic>> dashboardItems = [
    {
      'title': 'List of Providers',
      'icon': Icons.people,
      'page': SalonBranchesPage()
    },
    {
      'title': 'Book an appointment',
      'icon': Icons.note,
      'page': CustomerDetailsPage()
    },
    {
      'title': 'Cutomer Comments & Review',
      'icon': Icons.reviews,
      'page': ServicesPage()
    },
    {
      'title': 'Appointment Status',
      'icon': Icons.details,
      'page': ProductsPage()
    },
    {'title': 'History', 'icon': Icons.history, 'page': OffersPage()},
    {
      'title': 'User Profile',
      'icon': Icons.people_outline,
      'page': StaffDetailsPage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Dashboard',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              leading: Builder(
                builder: (BuildContext context) {
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(CupertinoIcons.bars, color: Colors.white),
                  );
                },
              ),
            )
          : AppBar(
              title: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
      drawer: Menu(),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/img9.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Transparent color overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Grid of pink square buttons
          Padding(
            padding: const EdgeInsets.all(26.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display two items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1, // Keep squares
              ),
              itemCount: dashboardItems.length,
              itemBuilder: (context, index) {
                final item = dashboardItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['page']),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 152, 11, 58).withOpacity(0.7),
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'],
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
