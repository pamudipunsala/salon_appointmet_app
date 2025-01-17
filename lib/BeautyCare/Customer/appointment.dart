import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentPage extends StatefulWidget {
  final int shopId;
  final int branchId;
  final int serviceId;
  final String? userId;

  const AppointmentPage({
    super.key,
    required this.branchId,
    required this.shopId,
    required this.serviceId,
    this.userId,
  });

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> selectedServices = [];
  List<String> selectedLocation = [];
  List<String> selectedCategory = [];

  final TextEditingController _dateController = TextEditingController();

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

  Future<void> _bookAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time.')),
      );
      return;
    }

    // Format the date and time
    String formattedDate =
        "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
    String formattedTime = "${selectedTime!.hour}:${selectedTime!.minute}:00";

    // Prepare the data to send
    Map<String, String> appointmentData = {
      'shop_id': widget.shopId.toString(),
      'branch_id': widget.branchId.toString(),
      'service_id': widget.serviceId.toString(),
      'user_id': widget.userId ?? '',
      'status': 'Pending',
      'date': formattedDate,
      'time': formattedTime,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/mobile_apps/appointmentApp/add_appointment.php'),
        body: appointmentData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment booked successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Adjust horizontal padding as needed
                child: Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 4, // Optional: Add elevation for shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Fit content vertically
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
                        SizedBox(height: 20),
                        // Submit button
                        Platform.isIOS
                            ? CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 22.0),
                                color: const Color.fromARGB(255, 7, 111, 57),
                                onPressed: () {
                                  _bookAppointment();
                                },
                                child: const Text(
                                  "Book Appointment",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 7, 111, 57),
                                  side: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                                onPressed: () {
                                  _bookAppointment();
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
          ),
        ],
      ),
    );
  }
}
