import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingCartScreen(),
    );
  }
}

class ShoppingCartItem {
  final String name;
  final double price;
  final String color;
  final String size;
  int quantity;
  final String imageUrl; // Add image URL for each item

  ShoppingCartItem({
    required this.name,
    required this.price,
    required this.color,
    required this.size,
    required this.quantity,
    required this.imageUrl,
  });
}

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<ShoppingCartItem> shoppingCartItems = [
    ShoppingCartItem(
      name: 'Pullover',
      price: 25.0,
      color: 'Black',
      size: 'L',
      quantity: 1,
      imageUrl: 'https://cdn.fashionbizapps.nz/honeybee/products/management/data/talent/WP916M_Talent_FrenchBlue_00.jpg',
    ),
    ShoppingCartItem(
      name: 'T-Shirt',
      price: 15.0,
      color: 'Gray',
      size: 'L',
      quantity: 1,
      imageUrl: 'https://static-01.daraz.com.bd/p/51cacc41c2b27adc447d9ad558561e5b.jpg',
    ),
    ShoppingCartItem(
      name: 'Sport Dress',
      price: 40.0,
      color: 'Black',
      size: 'M',
      quantity: 1,
      imageUrl: 'https://chkokko.com/cdn/shop/files/1_f6fe5613-ed64-4b83-be46-879ddbe875e4.jpg?v=1696081444',
    ),
  ];

  void _addItem(int index) {
    setState(() {
      final item = shoppingCartItems[index];
      item.quantity = (item.quantity ?? 0) + 1;

      if (item.quantity == 5) {
        _showItemAddedDialog(item.name);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      final item = shoppingCartItems[index];
      if (item.quantity! > 1) {
        item.quantity = item.quantity! - 1;
      }
    });
  }

  void _showItemAddedDialog(String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have added 5 $itemName on your bag!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set the background color to red
                onPrimary: Colors.white, // Set the text color to white
              ),
              child: Text('OKAY'),
            ),
          ],
        );
      },
    );
  }

  void _showCongratulationsSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Congratulations! Check out successful.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  double _calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var item in shoppingCartItems) {
      totalAmount += item.quantity! * item.price;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 200, // Adjust the number of items per row based on screen width
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: shoppingCartItems.length,
                itemBuilder: (context, index) {
                  final item = shoppingCartItems[index];

                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(item.imageUrl, fit: BoxFit.cover),
                        ),
                        ListTile(
                          title: Text(item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Color: ${item.color}'),
                              Text('Size: ${item.size}'),
                              Text('\$${item.price.toString()}'),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeItem(index),
                            ),
                            Text(
                              item.quantity.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _addItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Amount: \$${_calculateTotalAmount()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showCongratulationsSnackbar,
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set the background color to red
                onPrimary: Colors.white, // Set the text color to white
              ),
              child: Text('CHECK OUT'),
            ),
          ],
        ),
      ),
    );
  }
}
