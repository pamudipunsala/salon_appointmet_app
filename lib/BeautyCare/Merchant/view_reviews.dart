import 'dart:convert';
import 'dart:io' show HttpClient, Platform, X509Certificate;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewReviews extends StatefulWidget {
  const ViewReviews({super.key});

  @override
  _ViewReviewsState createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  List<Map<String, dynamic>> reviews = [];

  // Fetch data from the server
  Future<void> fetchReviews() async {
    final url = Uri.parse(
        'https://192.168.8.116/mobile_apps/appointmentApp/fetch_comments.php');

    // Bypassing certificate validation (only for development purposes)
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    try {
      final request = await client.getUrl(url);
      final response = await request.close();
      if (response.statusCode == 200) {
        final String jsonResponse =
            await response.transform(utf8.decoder).join();
        final List<dynamic> data = json.decode(jsonResponse);
        setState(() {
          reviews = data
              .map((review) => {
                    'name': review['name'],
                    'rating':
                        review['rate'].toString(), // Convert rate to string
                    'comment': review['comment']
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviews(); // Fetch the data when the screen loads
  }

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
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/bg6.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          reviews.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      color: Colors.white.withOpacity(0.8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 7, 111, 57),
                          child: Text(
                            review['rating']!,
                            style: const TextStyle(color: Colors.white),
                          ),
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
