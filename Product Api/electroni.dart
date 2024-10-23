import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Electronics extends StatefulWidget {
  final String categoryName;
  Electronics({super.key, required this.categoryName});

  @override
  State<Electronics> createState() => _ElectronicsState();
}

class _ElectronicsState extends State<Electronics> {
  List productsByCategory = [];

  Future<void> categoryResponce() async {
    var categoryData = await http.get(Uri.parse(
        "https://fakestoreapi.com/products/category/${widget.categoryName}"));
    if (categoryData.statusCode == 200) {
      setState(() {
        productsByCategory = jsonDecode(categoryData.body);
      });
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    categoryResponce();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Products"),
      ),
      body: GridView.builder(
        itemCount: productsByCategory.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.network(
                        productsByCategory[index]['image'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    productsByCategory[index]['title'],
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\$${productsByCategory[index]['price'].toString()}",
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "⭐ ${productsByCategory[index]['rating']['rate']}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "(${productsByCategory[index]['rating']['count']})",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // Add navigation or view product details logic here
                    },
                    child: Center(child: Text("View")),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}