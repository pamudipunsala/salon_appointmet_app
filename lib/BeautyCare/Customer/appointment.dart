import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> selectedServices = [];
  List<String> selectedLocation = [];
  List<String> selectedCategory = [];

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
            // Submit button
            ElevatedButton(
              onPressed: () {},
              child: const Text("Book Appointment"),
            ),
          ],
        ),
      ),
    );
  }
}
