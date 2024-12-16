import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _filteredOffers = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
    _searchController.addListener(_filterOffers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterOffers);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchOffers() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/mobile_apps/appointmentApp/view_offers.php'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success']) {
          final List<dynamic> offers = jsonResponse['offers'];
          setState(() {
            _offers = offers.map((offer) {
              return {
                'image': offer['image'], // Only 'image' available
                'shop_id':
                    offer['shop_id'], // You might want to display 'shop_id'
              };
            }).toList();
            _filteredOffers = _offers;
          });
        } else {
          print('No offers found: ${jsonResponse['message']}');
        }
      } else {
        print('Failed to fetch offers.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterOffers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOffers = _offers;
      } else {
        _filteredOffers = _offers
            .where((offer) => offer['name']!.toLowerCase().contains(query))
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
                  const Text('Offers', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ))
          : AppBar(
              title: const Text(
                'Offers',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
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
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Platform.isIOS
                          ? CupertinoSearchTextField(
                              controller: _searchController,
                              placeholder: 'Search offers...',
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.541),
                            )
                          : TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search offers...',
                                border: OutlineInputBorder(),
                                fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              // Offers Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = _filteredOffers[index];
                      return Card(
                        clipBehavior: Clip
                            .antiAlias, // This ensures the image is clipped to the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                'http://localhost/mobile_apps/appointmentApp/${offer['image']}',
                                fit: BoxFit
                                    .cover, // Ensures the image covers the card entirely
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              left: 8.0,
                              child: Container(
                                color: Colors.black.withOpacity(0.6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
