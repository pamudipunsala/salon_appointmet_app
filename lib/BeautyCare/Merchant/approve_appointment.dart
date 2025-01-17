import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApproveAppointmentScreen extends StatefulWidget {
  final String? userId;

  const ApproveAppointmentScreen(
      {Key? key, required this.userId, required businessTypeId})
      : super(key: key);

  @override
  _ApproveAppointmentScreenState createState() =>
      _ApproveAppointmentScreenState();
}

class _ApproveAppointmentScreenState extends State<ApproveAppointmentScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<Map<String, dynamic>> appointments = [];

  // Fetch appointments from the database
  Future<void> _fetchAppointments() async {
    final url = Uri.parse(
        'http://localhost/mobile_apps/appointmentApp/fetch_appointments.php');
    final response = await http.post(
      url,
      body: {'user_id': widget.userId},
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}'); // Log response for debugging
      setState(() {
        appointments =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to fetch appointments: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<bool> _updateAppointment({
    required String id,
    required String status,
    required String time,
  }) async {
    final url = Uri.parse(
        'http://localhost/mobile_apps/appointmentApp/update_appointment.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'status': status,
          'time': time,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('Update successful: ${data['message']}');
          return true;
        } else {
          print('Failed to update appointment: ${data['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

// Approve appointment function
  void _approveAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Approved';
    });
    _updateAppointment(
      id: appointments[index]['id'].toString(),
      status: 'Approved',
      time: appointments[index]['time'] ?? 'N/A',
    );
    print("Appointment approved: ${appointments[index]['name']}");
  }

// Hold appointment function
  void _holdAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Hold';
    });
    _updateAppointment(
      id: appointments[index]['id'].toString(),
      status: 'Hold',
      time: appointments[index]['time'] ?? 'N/A',
    );
    print("Appointment on hold: ${appointments[index]['name']}");
  }

// Adjust time function
  Future<void> _adjustTime(int index) async {
    if (Platform.isAndroid) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          selectedTime = picked;
          appointments[index]['time'] = picked.format(context);
        });
        _updateAppointment(
          id: appointments[index]['id'].toString(),
          status: appointments[index]['status'] ?? 'Pending',
          time: picked.format(context),
        );
      }
    } else if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  selectedTime = TimeOfDay(
                    hour: newDateTime.hour,
                    minute: newDateTime.minute,
                  );
                  appointments[index]['time'] = selectedTime!.format(context);
                });
                _updateAppointment(
                  id: appointments[index]['id'].toString(),
                  status: appointments[index]['status'] ?? 'Pending',
                  time: selectedTime!.format(context),
                );
              },
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Manage Appointments',
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
              title: const Text('Manage Appointments',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg6.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          appointments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      color: Colors.white.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  appointment['status'] == 'Approved'
                                      ? Icons.check_circle
                                      : appointment['status'] == 'Hold'
                                          ? Icons.pause_circle
                                          : appointment['status'] == 'Cancelled'
                                              ? Icons.cancel
                                              : Icons.hourglass_bottom,
                                  color: appointment['status'] == 'Approved'
                                      ? const Color.fromARGB(255, 46, 130, 48)
                                      : appointment['status'] == 'Hold'
                                          ? Colors.orange
                                          : appointment['status'] == 'Cancelled'
                                              ? Colors.red
                                              : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(appointment['user_id'] ?? 'No Name'),
                                    const SizedBox(height: 5),
                                    Text(
                                        'Date: ${appointment['date'] ?? 'N/A'}'),
                                    Text(
                                        'Time: ${appointment['time'] ?? 'N/A'}'),
                                    Text(
                                        'Location: ${appointment['branch_id'] ?? 'N/A'}'),
                                    Text(
                                        'Service: ${appointment['service_id'] ?? 'N/A'}'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            if (appointment['status'] == 'Pending' ||
                                appointment['status'] == 'Hold') ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _adjustTime(index),
                                    child: const Text('Adjust Time'),
                                  ),
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    onPressed: () => _approveAppointment(index),
                                    child: const Text('Approve'),
                                  ),
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    onPressed: () => _holdAppointment(index),
                                    child: const Text('Hold'),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
