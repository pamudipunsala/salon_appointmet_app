import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReviewDetails extends StatefulWidget {
  const ReviewDetails({super.key});

  @override
  _ReviewDetailsState createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends State<ReviewDetails> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  String _name = "LoggedInUser";

  // Function to submit the review
  void _submitReview() async {
    String comment = _commentController.text;

    if (_rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and a comment")),
      );
      return;
    }

    String _name = 'John Doe';

    try {
      var response = await http.post(
        Uri.parse(
            'http://192.168.8.116/mobile_apps/appointmentApp/add_reviews.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _name,
          'rate': _rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);

        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Review submitted successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(data['message'] ?? "Server error. Try again later")),
          );
        }
      } else {
        print('Server returned an error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error. Try again later")),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to connect. Try again later")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle: const Text('Reviews & Comments',
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
              title: const Text('Reviews & Comments',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 7, 111, 57),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background/bg6.jpg'), // Path to your image
                fit: BoxFit.cover, // Make image cover the screen
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          // Main content on top of the background
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.8), // Slight transparency
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      const Text("Rate this service:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Row(
                        children: List.generate(5, (index) {
                          return Platform.isIOS
                              ? CupertinoButton(
                                  child: Icon(
                                    CupertinoIcons.star_fill,
                                    color: index < _rating
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _rating = index + 1.0;
                                    });
                                  })
                              : IconButton(
                                  icon: Icon(
                                    Icons.star,
                                    color: index < _rating
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _rating = index + 1.0;
                                    });
                                  },
                                );
                        }),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _commentController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Write your comment',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 46),
                      Center(
                        child: Platform.isIOS
                            ? CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 22.0),
                                color: const Color.fromARGB(255, 7, 111, 57),
                                onPressed: _submitReview,
                                child: const Text('Submit Review'),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 7, 111, 57),
                                  side: const BorderSide(
                                      color: Colors.white, width: 2),
                                ),
                                onPressed: _submitReview,
                                child: const Text('Submit Review'),
                              ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
