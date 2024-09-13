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
    // Add logic here to update the appointment status in your database or backend
    print("Appointment approved: ${appointments[index]['name']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Approve Appointments',
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
              title: const Text('Approve Appointments',
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
            child: ListTile(
              leading: Icon(
                appointment['status'] == 'Approved'
                    ? Icons.check_circle
                    : Icons.hourglass_bottom,
                color: appointment['status'] == 'Approved'
                    ? Color.fromARGB(255, 152, 11, 58)
                    : Colors.black,
              ),
              title: Text(appointment['name']!),
              subtitle: Text(
                  'Date: ${appointment['date']}, Time: ${appointment['time']}, Location: ${appointment['location']}'),
              trailing: appointment['status'] == 'Pending'
                  ? ElevatedButton(
                      onPressed: () => _approveAppointment(index),
                      child: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 152, 11, 58),
                        foregroundColor: Colors.white,
                      ),
                    )
                  : const Text('Approved',
                      style: TextStyle(
                        color: Color.fromARGB(255, 152, 11, 58),
                      )),
            ),
          );
        },
      ),
    );
  }
}
