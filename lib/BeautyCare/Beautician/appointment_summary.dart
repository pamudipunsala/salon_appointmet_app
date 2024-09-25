import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_appointment_app/BeautyCare/Customer/categories.dart';
import 'package:salon_appointment_app/BeautyCare/Beautician/appointment_history.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentSummaryPage extends StatefulWidget {
  const AppointmentSummaryPage({super.key});

  @override
  _AppointmentSummaryPageState createState() => _AppointmentSummaryPageState();
}

class _AppointmentSummaryPageState extends State<AppointmentSummaryPage> {
  double _fontSize = 8.0;
  int _totalAppointments = 20;
  double _completedPercentage = 50;
  double _notCompletedPercentage = 30;
  double _cancelledPercentage = 20;

  // Example of events for the calendar
  Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 9, 15): ['Completed'],
    DateTime.utc(2024, 9, 16): ['Not Completed'],
    DateTime.utc(2024, 9, 17): ['Cancelled'],
  };

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text(
                'Appointment Summary',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppointmentHistory()));
                },
                child: const Icon(
                  Icons.summarize,
                  color: Colors.white,
                ),
              ),
            )
          : AppBar(
              title: const Text(
                'Appointment Summary',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.summarize,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppointmentHistory()));
                  },
                )
              ],
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Text(
                'Total Appointments: $_totalAppointments',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          // Completed
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Completed',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  '$_completedPercentage%',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          // Not Completed
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Not Completed',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  '$_notCompletedPercentage%',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          // Cancelled
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Cancelled',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  '$_cancelledPercentage%',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
          // Event-marked calendar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              calendarStyle: CalendarStyle(
                // Customize the event markers and the selected day
                markerDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 152, 11, 58),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 152, 11, 58),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
