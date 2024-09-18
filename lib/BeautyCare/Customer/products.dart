import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Map<String, dynamic>> products = [
    {'name': 'Hair cream', 'image': 'assets/images/img21.jpg'},
    {'name': 'Hair Oil', 'image': 'assets/images/img22.jpg'},
    {'name': 'Whitening Cream', 'image': 'assets/images/img23.jpg'},
    {'name': 'Body Lotion', 'image': 'assets/images/img24.jpeg'},
    {'name': 'Foot Cream', 'image': 'assets/images/img25.png'},
    {'name': 'Hair cream', 'image': 'assets/images/img21.jpg'},
    {'name': 'Hair Oil', 'image': 'assets/images/img22.jpg'},
    {'name': 'Whitening Cream', 'image': 'assets/images/img23.jpg'},
    {'name': 'Body Lotion', 'image': 'assets/images/img24.jpeg'},
    {'name': 'Foot Cream', 'image': 'assets/images/img25.png'},
    {'name': 'Hair cream', 'image': 'assets/images/img21.jpg'},
    {'name': 'Hair Oil', 'image': 'assets/images/img22.jpg'},
  ];

  List<Map<String, dynamic>> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = products;
      } else {
        _filteredProducts = products
            .where((product) => product['name']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredProducts = products;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
              middle:
                  const Text('Products', style: TextStyle(color: Colors.white)),
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
                  const Text('Products', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 152, 11, 58),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img3.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Platform.isIOS
                    ? CupertinoSearchTextField(
                        controller: _searchController,
                        placeholder: 'Search products...',
                        backgroundColor:
                            const Color.fromRGBO(255, 255, 255, 0.541),
                      )
                    : TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search products...',
                          border: OutlineInputBorder(),
                          fillColor: Color.fromRGBO(255, 255, 255, 0.541),
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 items per row
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2, // Adjust to fit the images
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product =
                          _filteredProducts[index]; // Use filtered list
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          // Button with product name
                          Positioned(
                            bottom: 20,
                            child: Platform.isIOS
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 22.0),
                                      child: Text(
                                        product['name']!,
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      color: const Color.fromARGB(
                                          255, 152, 11, 58),
                                      onPressed: () {},
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 152, 11, 58),
                                      side: const BorderSide(
                                          color: Colors.white, width: 2),
                                    ),
                                    onPressed: () {
                                      // Handle product button press
                                    },
                                    child: Text(
                                      product['name']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
