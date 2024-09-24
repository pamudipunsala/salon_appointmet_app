import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApproveAppointmentScreen extends StatefulWidget {
  const ApproveAppointmentScreen({super.key});

  @override
  _ApproveAppointmentScreenState createState() =>
      _ApproveAppointmentScreenState();
}

class _ApproveAppointmentScreenState extends State<ApproveAppointmentScreen> {
  // Mock data: Replace with actual data from your database or API
  final List<Map<String, String>> appointments = [
    {
      'name': 'John Doe',
      'date': '2024-09-15',
      'time': '10:00 AM',
      'location': 'Office A',
      'status': 'Pending',
    },
    {
      'name': 'Jane Smith',
      'date': '2024-09-16',
      'time': '11:30 AM',
      'location': 'Office B',
      'status': 'Pending',
    },
    {
      'name': 'Alex Johnson',
      'date': '2024-09-17',
      'time': '01:00 PM',
      'location': 'Office C',
      'status': 'Pending',
    },
  ];

  void _approveAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Approved';
    });
    print("Appointment approved: ${appointments[index]['name']}");
  }

  void _holdAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Hold';
    });
    print("Appointment on hold: ${appointments[index]['name']}");
  }

  void _cancelAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Cancelled';
    });
    print("Appointment cancelled: ${appointments[index]['name']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Manage Appointments',
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
              title: const Text('Manage Appointments',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          Text(appointment['name']!),
                          const SizedBox(height: 5),
                          Text('Date: ${appointment['date']}'),
                          Text('Time: ${appointment['time']}'),
                          Text('Location: ${appointment['location']}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 15), // Add some space before the buttons
                  appointment['status'] == 'Pending'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _approveAppointment(index),
                              child: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 46, 130, 48),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                minimumSize: const Size(60, 30),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _holdAppointment(index),
                              child: const Text('Hold'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                minimumSize: const Size(60, 30),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => _cancelAppointment(index),
                              child: const Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                minimumSize: const Size(60, 30),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          appointment['status']!,
                          style: TextStyle(
                            color: appointment['status'] == 'Approved'
                                ? const Color.fromARGB(255, 46, 130, 48)
                                : appointment['status'] == 'Hold'
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
