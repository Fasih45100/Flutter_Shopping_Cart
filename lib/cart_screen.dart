import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_cartf/product_list.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'database_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text(
          'My Cart',
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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/empty_cart.jpg',
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Your cart is empty',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Explore our products and add some items',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ProductList(title: 'Products'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                'Start Shopping',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder:
                            (context, index) => SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      snapshot.data![index].image.toString(),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot
                                                    .data![index]
                                                    .productName
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                dbHelper!.delete(
                                                  snapshot.data![index].id!,
                                                );
                                                cart.removeCounter();
                                                cart.removeTotalPrice(
                                                  double.parse(
                                                    snapshot
                                                        .data![index]
                                                        .productPrice
                                                        .toString(),
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.delete_outline),
                                              color: Colors.grey.shade600,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${snapshot.data![index].unitTag} • \$${snapshot.data![index].productPrice}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  int quantity =
                                                      snapshot
                                                          .data![index]
                                                          .quantity!;
                                                  int price =
                                                      snapshot
                                                          .data![index]
                                                          .initialPrice;
                                                  quantity--;
                                                  int? newPrice =
                                                      price * quantity;

                                                  if (quantity > 0) {
                                                    dbHelper!
                                                        .updateQuantity(
                                                          Cart(
                                                            id:
                                                                snapshot
                                                                    .data![index]
                                                                    .id!,
                                                            productId:
                                                                snapshot
                                                                    .data![index]
                                                                    .id
                                                                    .toString(),
                                                            productName:
                                                                snapshot
                                                                    .data![index]
                                                                    .productName,
                                                            initialPrice:
                                                                snapshot
                                                                    .data![index]
                                                                    .initialPrice,
                                                            productPrice:
                                                                newPrice,
                                                            quantity: quantity,
                                                            unitTag:
                                                                snapshot
                                                                    .data![index]
                                                                    .unitTag
                                                                    .toString(),
                                                            image:
                                                                snapshot
                                                                    .data![index]
                                                                    .image
                                                                    .toString(),
                                                          ),
                                                        )
                                                        .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(
                                                            double.parse(
                                                              snapshot
                                                                  .data![index]
                                                                  .initialPrice
                                                                  .toString(),
                                                            ),
                                                          );
                                                        })
                                                        .onError((
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          print(
                                                            error.toString(),
                                                          );
                                                        });
                                                  }
                                                },
                                              ),
                                              Text(
                                                snapshot.data![index].quantity
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add, size: 18),
                                                onPressed: () {
                                                  int quantity =
                                                      snapshot
                                                          .data![index]
                                                          .quantity!;
                                                  int price =
                                                      snapshot
                                                          .data![index]
                                                          .initialPrice;
                                                  quantity++;
                                                  int? newPrice =
                                                      price * quantity;

                                                  dbHelper!
                                                      .updateQuantity(
                                                        Cart(
                                                          id:
                                                              snapshot
                                                                  .data![index]
                                                                  .id!,
                                                          productId:
                                                              snapshot
                                                                  .data![index]
                                                                  .id
                                                                  .toString(),
                                                          productName:
                                                              snapshot
                                                                  .data![index]
                                                                  .productName,
                                                          initialPrice:
                                                              snapshot
                                                                  .data![index]
                                                                  .initialPrice,
                                                          productPrice:
                                                              newPrice,
                                                          quantity: quantity,
                                                          unitTag:
                                                              snapshot
                                                                  .data![index]
                                                                  .unitTag
                                                                  .toString(),
                                                          image:
                                                              snapshot
                                                                  .data![index]
                                                                  .image
                                                                  .toString(),
                                                        ),
                                                      )
                                                      .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(
                                                          double.parse(
                                                            snapshot
                                                                .data![index]
                                                                .initialPrice
                                                                .toString(),
                                                          ),
                                                        );
                                                      })
                                                      .onError((
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        print(error.toString());
                                                      });
                                                },
                                              ),
                                            ],
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
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) != '0.00',
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Subtotal',
                        value.getTotalPrice().toStringAsFixed(2),
                      ),
                      _buildSummaryRow('Discount (5%)', '20.00'),
                      Divider(height: 24, thickness: 1),
                      _buildSummaryRow(
                        'Total',
                        value.getTotalPrice().toStringAsFixed(2),
                        isTotal: true,
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Checkout logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Checkout (\$${value.getTotalPrice().toStringAsFixed(2)})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            '\$$value',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.deepPurple : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
