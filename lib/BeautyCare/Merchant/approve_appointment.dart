import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApproveAppointmentScreen extends StatefulWidget {
  final String? userId;

  const ApproveAppointmentScreen({Key? key, required this.userId, required businessTypeId}) : super(key: key);

  @override
  _ApproveAppointmentScreenState createState() =>
      _ApproveAppointmentScreenState();
}

class _ApproveAppointmentScreenState extends State<ApproveAppointmentScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
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
      'status': 'Hold',
    },
    {
      'name': 'Alex Johnson',
      'date': '2024-09-17',
      'time': '01:00 PM',
      'location': 'Office C',
      'status': 'Pending',
    },
  ];

  // Approve appointment function
  void _approveAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Approved';
    });
    print("Appointment approved: ${appointments[index]['name']}");
  }

  // Hold appointment function
  void _holdAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Hold';
    });
    print("Appointment on hold: ${appointments[index]['name']}");
  }

  // Cancel appointment function
  void _cancelAppointment(int index) {
    setState(() {
      appointments[index]['status'] = 'Cancelled';
    });
    print("Appointment cancelled: ${appointments[index]['name']}");
  }

  Future<void> _adjustTime(int index) async {
    if (Platform.isAndroid) {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
          // Save the adjusted time back into the appointment
          appointments[index]['time'] = picked.format(context);
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
                  // Save the adjusted time back into the appointment
                  appointments[index]['time'] = selectedTime!.format(context);
                });
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
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg6.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay for readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.white
                    .withOpacity(0.8), // Slight transparency for the card
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
                      const SizedBox(height: 15),
                      if (appointment['status'] == 'Pending' ||
                          appointment['status'] == 'Hold') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Platform.isIOS
                                ? CupertinoButton(
                                    color: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    onPressed: () => _adjustTime(index),
                                    child: const Text('Adjust Time'),
                                  )
                                : ElevatedButton(
                                    onPressed: () => _adjustTime(index),
                                    child: const Text('Adjust Time'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                    ),
                                  ),
                            const SizedBox(width: 10),
                            Platform.isIOS
                                ? CupertinoButton(
                                    color:
                                        const Color.fromARGB(255, 46, 130, 48),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    onPressed: () => _approveAppointment(index),
                                    child: const Text('Approve'),
                                  )
                                : ElevatedButton(
                                    onPressed: () => _approveAppointment(index),
                                    child: const Text('Approve'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 46, 130, 48),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                    ),
                                  ),
                            const SizedBox(width: 10),
                            if (appointment['status'] == 'Pending')
                              Platform.isIOS
                                  ? CupertinoButton(
                                      color: Colors.orange,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                      onPressed: () => _holdAppointment(index),
                                      child: const Text('Hold'),
                                    )
                                  : ElevatedButton(
                                      onPressed: () => _holdAppointment(index),
                                      child: const Text('Hold'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 10),
                                      ),
                                    ),
                            const SizedBox(width: 10),
                            Platform.isIOS
                                ? CupertinoButton(
                                    color: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    onPressed: () => _cancelAppointment(index),
                                    child: const Text('Cancel'),
                                  )
                                : ElevatedButton(
                                    onPressed: () => _cancelAppointment(index),
                                    child: const Text('Cancel'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                    ),
                                  ),
                          ],
                        ),
                      ] else ...[
                        Text(
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
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
