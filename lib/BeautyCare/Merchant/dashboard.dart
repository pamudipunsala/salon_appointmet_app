import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/reviews.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/add_branches.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/add_offers.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/add_services.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/add_shops.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/appointment_summary.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/approve_appointment.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/customers.dart';
import 'package:salon_appointment_app/BeautyCare/Merchant/view_reviews.dart';
import 'package:salon_appointment_app/menu.dart';

class BeauticianDashboardPage extends StatefulWidget {
  const BeauticianDashboardPage({super.key});

  @override
  _BeauticianDashboardPageState createState() =>
      _BeauticianDashboardPageState();
}

class _BeauticianDashboardPageState extends State<BeauticianDashboardPage> {
  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Add Shops', 'icon': Icons.shop, 'page': AddShopsPage()},
    {
      'title': 'Add Branches',
      'icon': Icons.store,
      'page': AddSalonBranchesPage()
    },
    {'title': 'Customers', 'icon': Icons.people, 'page': CustomerDetailsPage()},
    {
      'title': 'Add Services',
      'icon': Icons.room_service,
      'page': AddServicesPage()
    },
    {'title': 'Add Offers', 'icon': Icons.local_offer, 'page': AddOffersPage()},
    {
      'title': 'Appointment Summary',
      'icon': Icons.calendar_today,
      'page': AppointmentSummaryPage()
    },
    {
      'title': 'Approve Appointments',
      'icon': Icons.calendar_today,
      'page': ApproveAppointmentScreen()
    },
    {
      'title': 'Comments & Review',
      'icon': Icons.reviews,
      'page': ViewReviews()
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
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : AppBar(
              title: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg6.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Transparent color overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
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
                      color: Color.fromARGB(255, 7, 111, 57).withOpacity(0.7),
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
