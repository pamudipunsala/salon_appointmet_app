import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Sample prices for each service
  final Map<String, double> servicePrices = {
    'Gold Facial': 120.0,
    'Clean Up': 80.0,
    'Pimple treatment': 100.0,
    'Laser Treatment': 200.0,
    'Brightning Treatment': 150.0,
    'Whitening Treatment': 180.0,
  };

  // Controllers for date, time, and number of people
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final services = [
      {'name': 'Gold Facial', 'image': 'assets/images/img15.jpeg'},
      {'name': 'Clean Up', 'image': 'assets/images/img16.jpg'},
      {'name': 'Pimple treatment', 'image': 'assets/images/img17.png'},
      {'name': 'Laser Treatment', 'image': 'assets/images/img18.png'},
      {'name': 'Brightning Treatment', 'image': 'assets/images/img19.png'},
      {'name': 'Whitening Treatment', 'image': 'assets/images/img20.png'},
    ];

    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Categories',
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
              title: const Text('Categories',
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
          ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final serviceName = service['name']!;
              final servicePrice = servicePrices[serviceName] ?? 0.0;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          service['image']!,
                          fit: BoxFit.cover,
                          width: 270,
                          height: 150,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      child: Platform.isIOS
                          ? CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 22.0),
                              child: Text(serviceName,
                                  style: TextStyle(fontSize: 16.0)),
                              color: Color.fromARGB(255, 152, 11, 58),
                              onPressed: () {
                                _showServiceDialog(
                                    context, serviceName, servicePrice);
                              },
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 152, 11, 58),
                                side: const BorderSide(
                                    color: Colors.white, width: 2),
                              ),
                              onPressed: () {
                                _showServiceDialog(
                                    context, serviceName, servicePrice);
                              },
                              child: Text(
                                serviceName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showServiceDialog(
      BuildContext context, String serviceName, double price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isBooking = false;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(serviceName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: \$$price'),
                const SizedBox(height: 20),
                if (isBooking)
                  Column(
                    children: [
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(labelText: 'Select Date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                      ),
                      TextField(
                        controller: _timeController,
                        decoration: InputDecoration(labelText: 'Select Time'),
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _timeController.text = pickedTime.format(context);
                            });
                          }
                        },
                      ),
                      TextField(
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'No. of People'),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                if (!isBooking)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isBooking = true;
                      });
                    },
                    child: Text('Book Now'),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        });
      },
    );
  }
}
