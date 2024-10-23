import 'dart:convert';
import 'package:api_prg/newAPI/electroni.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ProductDetails.dart';

class ProductAPI extends StatefulWidget {
  const ProductAPI({super.key});

  @override
  State<ProductAPI> createState() => _ProductAPIState();
}

class _ProductAPIState extends State<ProductAPI> {
  List productList = [];
  var productId = '';
  List categoryList = [];
  String categoryName = '';

  Future<void> getProducts() async {
    var response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      setState(() {
        productList = jsonDecode(response.body);
      });
    } else {
      print("Error");
    }
  }

  Future<void> categoryResponce() async {
    var categorydata = await http
        .get(Uri.parse("https://fakestoreapi.com/products/categories"));
    if (categorydata.statusCode == 200) {
      setState(() {
        categoryList = jsonDecode(categorydata.body);
      });
    } else {
      print("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    categoryResponce();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Products"),
        centerTitle: true,
       backgroundColor: Colors.purple.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80, 
                                                               // Expanded
              child: Expanded(
                child: ListView.builder(
                  itemCount: categoryList.length,
                                                      //  scroll.horizontal
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        categoryName = categoryList[index].toString();
                        print(categoryName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Electronics(
                              categoryName: '${categoryList[index]}',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 120,
                        // width: 120,
                        margin: const EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 135, 238),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            categoryList[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
                                                    //  Expanded
            Expanded(
              child: GridView.builder(
                itemCount: productList.length,
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
                                productList[index]['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            productList[index]['title'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "\$${productList[index]['price'].toString()}",
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "⭐ ${productList[index]['rating']['rate']}",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "(${productList[index]['rating']['count']})",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            
                            style: ElevatedButton.styleFrom(
                              
                              // primary: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Productdetails(
                                      productId: productList[index]['id']),
                                ),
                              );
                            },
                            child: Center(child: Text("View")),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}