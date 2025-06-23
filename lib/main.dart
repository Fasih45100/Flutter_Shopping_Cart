import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoping_cartf/cart_provider.dart';
import 'package:shoping_cartf/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: 'flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const ProductList(title: ''),
          );
        },
      ),
    );
  }
}
