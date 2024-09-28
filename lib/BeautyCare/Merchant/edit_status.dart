import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditStatusScreen extends StatefulWidget {
  const EditStatusScreen({super.key});

  @override
  _EditStatusScreenState createState() => _EditStatusScreenState();
}

class _EditStatusScreenState extends State<EditStatusScreen> {
  // Dummy data for demonstration purposes
  String appointmentNo = "A12345";
  String appointmentDate = "12th September 2024";
  String appointmentTime = "3:00 PM";
  String appointmentStatus = "Confirmed"; // Editable status

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
              middle: const Text('Edit Appointment Status',
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
              title: const Text('Edit Appointment Status',
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
          SingleChildScrollView(
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
                        Row(
                          children: [
                            const Text(
                              "Status:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Dropdown for editing status
                            DropdownButton<String>(
                              value: appointmentStatus,
                              items: _statusOptions.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (newStatus) {
                                setState(() {
                                  appointmentStatus = newStatus!;
                                });
                              },
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.white,
                              underline: const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Editable Current Status Card
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
                          onStepTapped: (index) {
                            setState(() {
                              appointmentStatus = _statusOptions[index];
                            });
                          },
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
                        const SizedBox(height: 5),

                        // Save Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Logic to save status
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Status saved'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 7, 111, 57),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
