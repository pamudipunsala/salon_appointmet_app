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
            child: SizedBox(
              height: 150, // Set the desired height here
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0), // Adjust padding as needed
                leading: Icon(
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
                title: Text(appointment['name']!),
                subtitle: Text(
                    'Date: ${appointment['date']}, Time: ${appointment['time']}, Location: ${appointment['location']}'),
                trailing: appointment['status'] == 'Pending'
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _approveAppointment(index),
                            child: const Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 46, 130, 48),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              minimumSize: const Size(60, 30),
                            ),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () => _holdAppointment(index),
                            child: const Text('Hold'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              minimumSize: const Size(60, 30),
                            ),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () => _cancelAppointment(index),
                            child: const Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
