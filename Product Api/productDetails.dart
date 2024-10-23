import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Productdetails extends StatefulWidget {
  final int productId;
  const Productdetails({super.key, required this.productId});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  Map productList = {};

  Future<void> productResponce() async {
    var productdata = await 
    http.get(Uri.parse("https://fakestoreapi.com/products/${widget.productId}"));
       
   if (productdata.statusCode == 200) {
      setState(() {
        productList = jsonDecode(productdata.body);
      });
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    productResponce();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,

      ),
      body: productList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            productList['image'],
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        productList['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        productList['description'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "\$${productList['price'].toString()}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                           // primary: Colors.amber,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Add your functionality here
                          },
                          child: Text("Add to Cart"),
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