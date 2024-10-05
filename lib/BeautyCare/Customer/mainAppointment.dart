import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainAppointmentPage extends StatefulWidget {
  const MainAppointmentPage({super.key});

  @override
  _MainAppointmentPageState createState() => _MainAppointmentPageState();
}

class _MainAppointmentPageState extends State<MainAppointmentPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> selectedServices = [];
  List<String> selectedLocations = [];
  List<String> selectedCategories = [];

  final TextEditingController _dateController = TextEditingController();

  final List<String> services = [
    'Haircut',
    'Manicure',
    'Pedicure',
    'Massage',
    'Facial'
  ];

  final List<String> category = [
    'Gold Facial',
    'Clean Up',
    'Pimple Treatment',
    'Laser Treatment',
    'Whitening Treatment'
  ];

  final List<String> locations = [
    'Colombo 05',
    'Nugegoda',
    'Maharagama',
    'Gampaha',
    'Kandy',
  ];

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await (Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return Container(
                height: 250,
                color: Colors.white,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  onDateTimeChanged: (dateTime) {
                    setState(() {
                      selectedDate = dateTime;
                      _dateController.text =
                          "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
                    });
                  },
                ),
              );
            },
          )
        : showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
          ));

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text =
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

  // Function to pick a time
  Future<void> _selectTime(BuildContext context) async {
    if (Platform.isAndroid) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
        });
      }
    } else if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  selectedTime = TimeOfDay(
                    hour: newDateTime.hour,
                    minute: newDateTime.minute,
                  );
                });
              },
            ),
          );
        },
      );
    }
  }

  void _showServiceSelectionDialog() {
    List<String> tempSelectedServices = List.from(selectedServices);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Select Services'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: services.map((service) {
                          bool isSelected =
                              tempSelectedServices.contains(service);
                          return Row(
                            children: [
                              Expanded(child: Text(service)),
                              CupertinoSwitch(
                                value: isSelected,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      tempSelectedServices.add(service);
                                    } else {
                                      tempSelectedServices.remove(service);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Done'),
                    onPressed: () {
                      setState(() {
                        selectedServices = tempSelectedServices;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Select Services'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: services.map((service) {
                          return CheckboxListTile(
                            title: Text(service),
                            value: tempSelectedServices.contains(service),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  tempSelectedServices.add(service);
                                } else {
                                  tempSelectedServices.remove(service);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedServices = tempSelectedServices;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
      },
    );
  }

  void _showCategorySelectionDialog() {
    List<String> tempSelectedCategories = List.from(selectedCategories);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Select Category'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: category.map((category) {
                          bool isSelected =
                              tempSelectedCategories.contains(category);
                          return Row(
                            children: [
                              Expanded(child: Text(category)),
                              CupertinoSwitch(
                                value: isSelected,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      tempSelectedCategories.add(category);
                                    } else {
                                      tempSelectedCategories.remove(category);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Done'),
                    onPressed: () {
                      setState(() {
                        selectedCategories = tempSelectedCategories;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Select categorys'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: category.map((category) {
                          return CheckboxListTile(
                            title: Text(category),
                            value: tempSelectedCategories.contains(category),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  tempSelectedCategories.add(category);
                                } else {
                                  tempSelectedCategories.remove(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategories = tempSelectedCategories;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
      },
    );
  }

  void _showLocationSelectionDialog() {
    List<String> tempSelectedLocations = List.from(selectedLocations);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('Select Services'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: locations.map((locations) {
                          bool isSelected =
                              tempSelectedLocations.contains(locations);
                          return Row(
                            children: [
                              Expanded(child: Text(locations)),
                              CupertinoSwitch(
                                value: isSelected,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      tempSelectedLocations.add(locations);
                                    } else {
                                      tempSelectedLocations.remove(locations);
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Done'),
                    onPressed: () {
                      setState(() {
                        selectedLocations = tempSelectedLocations;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : AlertDialog(
                title: const Text('Select Location'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: locations.map((locations) {
                          return CheckboxListTile(
                            title: Text(locations),
                            value: tempSelectedLocations.contains(locations),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  tempSelectedLocations.add(locations);
                                } else {
                                  tempSelectedLocations.remove(locations);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedServices = tempSelectedLocations;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
      },
    );
  }

  Future<void> _bookAppointment() async {
    final String url =
        'http://192.168.8.116/mobile_apps/appointmentApp/add_appointment.php';

    // Prepare the data to send to the database
    final Map<String, String> appointmentData = {
      'number': '12345',
      'date':
          "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
      'time': "${selectedTime!.hour}:${selectedTime!.minute}",
      'service': selectedServices.join(','),
      'category': selectedCategories.join(','),
      'location': selectedLocations.join(','),
      'status': 'pending',
      'contact': '0123456789',
      'shop_id': '1',
      'user_id': '1'
    };

    try {
      // Send the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointmentData),
      );

      if (response.statusCode == 200) {
        // If the server returns a success response
        print('Appointment booked successfully: ${response.body}');
      } else {
        // If the server returns an error response
        print('Failed to book appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Appointment Booking',
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
              title: const Text('Appointment Booking',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg7.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Adjust horizontal padding as needed
              child: Card(
                color: Colors.white.withOpacity(0.8),
                elevation: 4, // Optional: Add elevation for shadow
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Optional: Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Adjust to fit content
                    children: [
                      SizedBox(height: 20),
                      ListTile(
                        title: const Text("Select Date"),
                        subtitle: Text(
                          selectedDate != null
                              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                              : "No date selected",
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),

                      // Time selection field
                      ListTile(
                        title: const Text("Select Time"),
                        subtitle: Text(
                          selectedTime != null
                              ? "${selectedTime!.hour}:${selectedTime!.minute}"
                              : "No time selected",
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => _selectTime(context),
                      ),

                      // Service selection field
                      ListTile(
                        title: const Text("Select Services"),
                        subtitle: Text(
                          selectedServices.isNotEmpty
                              ? selectedServices.join(', ')
                              : "No services selected",
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: _showServiceSelectionDialog,
                      ),

                      ListTile(
                        title: const Text("Select Category"),
                        subtitle: Text(
                          selectedCategories.isNotEmpty
                              ? selectedCategories.join(', ')
                              : "No categories selected",
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: _showCategorySelectionDialog,
                      ),

                      ListTile(
                        title: const Text("Select Location"),
                        subtitle: Text(
                          selectedLocations.isNotEmpty
                              ? selectedLocations.join(', ')
                              : "No location selected",
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: _showLocationSelectionDialog,
                      ),

                      SizedBox(height: 20), // Adjust spacing as needed
                      // Submit button
                      Platform.isIOS
                          ? CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 22.0),
                              color: const Color.fromARGB(255, 7, 111, 57),
                              onPressed: () {
                                if (selectedDate != null &&
                                    selectedTime != null &&
                                    selectedServices.isNotEmpty) {
                                  _bookAppointment();
                                } else {
                                  print('Please fill in all required fields');
                                }
                              },
                              child: const Text(
                                "Book Appointment",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (selectedDate != null &&
                                    selectedTime != null &&
                                    selectedServices.isNotEmpty) {
                                  _bookAppointment();
                                } else {
                                  print('Please fill in all required fields');
                                }
                              },
                              child: const Text("Book Appointment"),
                            ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
