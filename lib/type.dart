import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/userRole.dart';
import 'package:salon_appointment_app/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusinessTypePage extends StatefulWidget {
  final String? userId;
  const BusinessTypePage({super.key, required this.userId});

  @override
  _BusinessTypePageState createState() => _BusinessTypePageState();
}

class _BusinessTypePageState extends State<BusinessTypePage> {
  late String? userId;
  List<Map<String, dynamic>> dashboardItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    if (userId == null || userId!.isEmpty) {
      _loadUserId();
    }
    _fetchDashboardItems();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? 'No user ID found';
    });
    print("Retrieved userId in BusinessTypePage: $userId");
  }

  Future<void> _fetchDashboardItems() async {
    try {
      const url = 'http://localhost/mobile_apps/appointmentApp/fetch_types.php';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          dashboardItems = data
              .map((item) => {
                    'id': item['id'],
                    'name': item['name'],
                    'icon': Icons.business,
                    'page': (String? userId, String id) =>
                        UserRolePage(userId: userId, businessTypeId: id),
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      print('Error fetching dashboard items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  IconData _getIconByName(String iconName) {
    switch (iconName) {
      case 'store':
        return Icons.store;
      case 'directions_car':
        return Icons.directions_car;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Business Type',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
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
                'Business Type',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
      drawer: Menu(),
      body: Stack(
        children: [
          // User ID Display
          Text(userId != null
              ? 'User ID: $userId'
              : 'Loading user information...'),

          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg5.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Transparent color overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Dashboard Items
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
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
                          MaterialPageRoute(
                            builder: (context) =>
                                item['page'](userId, item['id']),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 7, 111, 57)
                            .withOpacity(0.7),
                        borderRadius:
                            BorderRadius.circular(12), 
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
                            item['name'],
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
