import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/add_offers.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/add_products.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/add_salons.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/add_services.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/appointment_summary.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/customers.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/services.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/staff.dart';
import 'package:salon_appointment_app/menu.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // List of dashboard items with text and icons
  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Salons', 'icon': Icons.store, 'page': AddSalonBranchesPage()},
    {'title': 'Customers', 'icon': Icons.people, 'page': CustomerDetailsPage()},
    {
      'title': 'Services',
      'icon': Icons.room_service,
      'page': AddServicesPage()
    },
    {
      'title': 'Products',
      'icon': Icons.shopping_bag,
      'page': AddProductsPage()
    },
    {'title': 'Offers', 'icon': Icons.local_offer, 'page': AddOffersPage()},
    {
      'title': 'Appointment Summary',
      'icon': Icons.calendar_today,
      'page': AppointmentSummaryPage()
    },
    {'title': 'Staff', 'icon': Icons.group, 'page': StaffDetailsPage()},
    {'title': 'Marketing', 'icon': Icons.campaign, 'page': ServicesPage()},
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
