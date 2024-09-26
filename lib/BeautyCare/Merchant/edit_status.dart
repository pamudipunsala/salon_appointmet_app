import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditStatusScreen extends StatefulWidget {
  const EditStatusScreen({super.key});

  @override
  _EditStatusScreenState createState() => _EditStatusScreenState();
}

class _EditStatusScreenState extends State<EditStatusScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Status options and progress tracking
  final List<String> _statusOptions = [
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled'
  ];
  String? _selectedStatus;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Edit Tracking Details',
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
              title: const Text('Edit Tracking',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tracking Details',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Current Status',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                Stepper(
                  physics: const NeverScrollableScrollPhysics(),
                  currentStep:
                      _statusOptions.indexOf(_selectedStatus ?? 'Pending'),
                  onStepTapped: (step) {
                    setState(() {
                      _selectedStatus = _statusOptions[step];
                    });
                  },
                  steps: _statusOptions.map((status) {
                    return Step(
                      title: Text(status),
                      content: const SizedBox.shrink(),
                      isActive: _selectedStatus == status,
                      state: _selectedStatus == status
                          ? StepState.complete
                          : StepState.indexed,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Platform.isIOS
                    ? CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 22.0),
                        color: const Color.fromARGB(255, 152, 11, 58),
                        child: const Text('Save Changes'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle form submission logic here
                            print(
                                "Appointment edited: Name: ${_nameController.text}, Status: $_selectedStatus");
                          }
                        })
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle form submission logic here
                            print(
                                "Appointment edited: Name: ${_nameController.text}, Status: $_selectedStatus");
                          }
                        },
                        child: const Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 152, 11, 58),
                          foregroundColor: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
