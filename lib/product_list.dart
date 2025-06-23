import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';
import 'database_helper.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key, required String title});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBHelper? dbHelper = DBHelper();

  final List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mix Fruit Basket',
  ];

  final List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  final List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  final List<String> productImage = [
    'https://cdn.pixabay.com/photo/2016/03/05/22/18/food-1239241_640.jpg',
    'https://cdn.pixabay.com/photo/2017/01/20/15/06/oranges-1995056_640.jpg',
    'https://images.pexels.com/photos/708777/pexels-photo-708777.jpeg',
    'https://cdn.pixabay.com/photo/2017/06/27/22/21/banana-2449019_640.jpg',
    'https://images.pexels.com/photos/109274/pexels-photo-109274.jpeg',
    'https://images.pexels.com/photos/547263/pexels-photo-547263.jpeg',
    'https://images.unsplash.com/photo-1603569283847-aa295f0d016a',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text(
          'Fresh Fruits',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              child: badge.Badge(
                position: badge.BadgePosition.topEnd(top: -10, end: -5),
                badgeStyle: badge.BadgeStyle(
                  badgeColor: Colors.amber,
                  padding: EdgeInsets.all(6),
                ),
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                child: Icon(Icons.shopping_cart, size: 28, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68, // Adjusted to prevent overflow
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: productName.length,
          itemBuilder: (context, index) {
            return Material(
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        productImage[index],
                        height: 100, // Reduced height
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Product Details
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${productUnit[index]} • \$${productPrice[index]}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Add to Cart Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                dbHelper!
                                    .insert(
                                      Cart(
                                        id: index,
                                        productId: index.toString(),
                                        productName: productName[index],
                                        initialPrice: productPrice[index],
                                        productPrice: productPrice[index],
                                        quantity: 1,
                                        unitTag: productUnit[index],
                                        image: productImage[index],
                                      ),
                                    )
                                    .then((value) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${productName[index]} added to cart',
                                          ),
                                          duration: Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(10),
                                        ),
                                      );
                                      cart.addTotalPrice(
                                        productPrice[index].toDouble(),
                                      );
                                      cart.addCounter();
                                    })
                                    .onError((error, stackTrace) {
                                      print("Error: $error");
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
