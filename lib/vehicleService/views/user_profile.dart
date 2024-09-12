import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreenPage extends StatefulWidget {
  const ProfileScreenPage({super.key});

  @override
  _ProfileScreenPageState createState() => _ProfileScreenPageState();
}

class _ProfileScreenPageState extends State<ProfileScreenPage> {
  // Dummy data for demonstration purposes
  String userName = "John Doe";
  String appointmentDate = "12th September 2024";
  String appointmentTime = "3:00 PM";
  String service = "Haircut";
  String location = "Downtown Salon";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle:
                  const Text('Profile', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : AppBar(
              title:
                  const Text('Profile', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Placeholder (optional)
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/profile_placeholder.png'), // Add your asset image here
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 20),

            // User's Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Profile details section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileDetailItem(
                    icon: Icons.calendar_today,
                    title: 'Appointment Date',
                    value: appointmentDate,
                  ),
                  const Divider(),
                  ProfileDetailItem(
                    icon: Icons.access_time,
                    title: 'Appointment Time',
                    value: appointmentTime,
                  ),
                  const Divider(),
                  ProfileDetailItem(
                    icon: Icons.design_services,
                    title: 'Service',
                    value: service,
                  ),
                  const Divider(),
                  ProfileDetailItem(
                    icon: Icons.location_on,
                    title: 'Location',
                    value: location,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to display profile details neatly
class ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileDetailItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
