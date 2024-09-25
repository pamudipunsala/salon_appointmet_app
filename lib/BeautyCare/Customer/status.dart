import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentStatus extends StatefulWidget {
  const AppointmentStatus({super.key});

  @override
  _AppointmentStatusState createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus> {
  // Dummy data for demonstration purposes
  String appointmentNo = "A12345";
  String appointmentDate = "12th September 2024";
  String appointmentTime = "3:00 PM";
  String appointmentStatus = "Confirmed";

  final List<String> _statusOptions = [
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Appointment Status',
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
              title: const Text('Appointment Status',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Displaying Appointment Number
            AppointmentDetailItem(
              title: "Appointment No.",
              value: appointmentNo,
            ),
            const Divider(),

            // Displaying Appointment Date
            AppointmentDetailItem(
              title: "Date",
              value: appointmentDate,
            ),
            const Divider(),

            // Displaying Appointment Time
            AppointmentDetailItem(
              title: "Time",
              value: appointmentTime,
            ),
            const Divider(),

            // Displaying Appointment Status
            AppointmentDetailItem(
              title: "Status",
              value: appointmentStatus,
              valueColor: appointmentStatus == "Confirmed"
                  ? Colors.green
                  : Colors.red, // Different color for status
            ),
            const SizedBox(height: 60),
            const Text(
              'Current Status',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),

            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              currentStep: _statusOptions.indexOf(appointmentStatus),
              controlsBuilder: (context, details) => const SizedBox.shrink(),
              steps: _statusOptions.map((status) {
                return Step(
                  title: Text(status),
                  content: const SizedBox.shrink(),
                  isActive: appointmentStatus == status,
                  state: appointmentStatus == status
                      ? StepState.complete
                      : StepState.indexed,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to display appointment details
class AppointmentDetailItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const AppointmentDetailItem({
    Key? key,
    required this.title,
    required this.value,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
