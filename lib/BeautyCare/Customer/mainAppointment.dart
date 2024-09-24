import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainAppointmentPage extends StatefulWidget {
  const MainAppointmentPage({super.key});

  @override
  _MainAppointmentPageState createState() => _MainAppointmentPageState();
}

class _MainAppointmentPageState extends State<MainAppointmentPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> selectedServices = [];
  List<String> selectedLocation = [];
  List<String> selectedCategory = [];

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

  final List<String> location = [
    'Colombo 05',
    'Nugegoda',
    'Maharagama',
    'Gampaha',
    'Kandy',
  ];

  // Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to pick a time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _showServiceSelectionDialog() {
    List<String> tempSelectedServices =
        List.from(selectedServices); // Temporary list to store selections

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                Navigator.of(context)
                    .pop(); // Close the dialog without saving changes
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the selected services and close the dialog
                setState(() {
                  selectedServices = tempSelectedServices;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showCategorySelectionDialog() {
    List<String> tempSelectedCategory =
        List.from(selectedCategory); // Temporary list to store selections

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: category.map((category) {
                    return CheckboxListTile(
                      title: Text(category),
                      value: tempSelectedCategory.contains(category),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedCategory.add(category);
                          } else {
                            tempSelectedCategory.remove(category);
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
                  selectedCategory = tempSelectedCategory;
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
    String? tempSelectedLocation = selectedLocation.isNotEmpty
        ? selectedLocation.first
        : null; // Temporarily store the currently selected location

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Location'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: location.map((location) {
                    return RadioListTile<String>(
                      title: Text(location),
                      value: location,
                      groupValue: tempSelectedLocation,
                      onChanged: (String? value) {
                        setState(() {
                          tempSelectedLocation = value;
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
                  selectedLocation = tempSelectedLocation != null
                      ? [tempSelectedLocation!]
                      : [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Appointment Booking',
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
              title: const Text('Appointment Booking',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date selection field
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
            const SizedBox(height: 16),

            ListTile(
              title: const Text("Select Category"),
              subtitle: Text(
                selectedCategory.isNotEmpty
                    ? selectedCategory.join(', ')
                    : "No category selected",
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _showCategorySelectionDialog,
            ),
            const SizedBox(height: 16),

            ListTile(
              title: const Text("Select Location"),
              subtitle: Text(
                selectedLocation.isNotEmpty
                    ? selectedLocation.join(', ')
                    : "No Location Selected",
              ),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _showLocationSelectionDialog,
            ),
            const SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: () {
                // Handle booking submission
              },
              child: const Text("Book Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
