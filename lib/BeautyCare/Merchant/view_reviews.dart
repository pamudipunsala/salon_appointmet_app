import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewReviews extends StatefulWidget {
  const ViewReviews({super.key});

  @override
  _ViewReviewsState createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  // Mock data: replace this with actual data fetching logic
  final List<Map<String, String>> reviews = [
    {
      'name': 'John Doe',
      'rating': '5',
      'comment': 'Great service!',
    },
    {
      'name': 'Jane Smith',
      'rating': '4',
      'comment': 'Very professional.',
    },
    {
      'name': 'Alex Johnson',
      'rating': '3',
      'comment': 'Satisfactory experience.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('View Reviews',
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
              title: const Text('View Reviews',
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
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.white
                    .withOpacity(0.8), // Slight transparency for the card
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      review['rating']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: const Color.fromARGB(255, 7, 111, 57),
                  ),
                  title: Text(
                    review['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(review['comment']!),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
