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
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
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
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg6.jpg', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Appointment Details Card
                Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppointmentDetailItem(
                          title: "Appointment No.",
                          value: appointmentNo,
                        ),
                        const Divider(),
                        AppointmentDetailItem(
                          title: "Date",
                          value: appointmentDate,
                        ),
                        const Divider(),
                        AppointmentDetailItem(
                          title: "Time",
                          value: appointmentTime,
                        ),
                        const Divider(),
                        AppointmentDetailItem(
                          title: "Status",
                          value: appointmentStatus,
                          valueColor: appointmentStatus == "Confirmed"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Current Status Card
                Card(
                  color: Colors.white.withOpacity(0.8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          currentStep:
                              _statusOptions.indexOf(appointmentStatus),
                          controlsBuilder: (context, details) =>
                              const SizedBox.shrink(),
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
                ),
              ],
            ),
          ),
        ],
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
