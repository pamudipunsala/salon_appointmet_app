import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/customerHistory.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/mainAppointment.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/offers.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/shops.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/reviews.dart';

class CustomerDashboardPage extends StatefulWidget {
  final String userId;
  const CustomerDashboardPage(
      {super.key, required this.userId, required businessTypeId});

  @override
  _CustomerDashboardPageState createState() => _CustomerDashboardPageState();
}

class _CustomerDashboardPageState extends State<CustomerDashboardPage> {
  late List<Map<String, dynamic>> dashboardItems;

  @override
  void initState() {
    super.initState();

    dashboardItems = [
      {
        'title': 'Book an Appointment',
        'icon': Icons.book,
        'page': MainAppointmentPage(),
      },
      {
        'title': 'Shops',
        'icon': Icons.store,
        'page': ShopsPage(userId: widget.userId),
      },
      {
        'title': 'Offers',
        'icon': Icons.local_offer,
        'page': OffersPage(),
      },
      {
        'title': 'Comments & Review',
        'icon': Icons.reviews,
        'page': ReviewDetails(),
      },
      {
        'title': 'History',
        'icon': Icons.history,
        'page': CustomerHistory(),
      },
    ];
  }

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
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (context) => item['page'],
                            )
                          : MaterialPageRoute(
                              builder: (context) => item['page'],
                            ),
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
