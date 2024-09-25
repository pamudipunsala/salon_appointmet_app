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
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
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
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(review['rating']!),
              ),
              title: Text(review['name']!),
              subtitle: Text(review['comment']!),
            ),
          );
        },
      ),
    );
  }
}
