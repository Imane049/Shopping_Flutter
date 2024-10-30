import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/navigationBar.dart';
import '../handlers/UserProvider.dart';
import '../handlers/ClothingService.dart';
import '../components/CartItem.dart'; 

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Color primaryColor = Color.fromARGB(255, 148, 92, 229);
  List<Map<String, dynamic>> cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<dynamic> cartIds = userProvider.userData?['cart'] ?? [];

    // Logging to debug whether we got cart IDs from the user data
    print("User Cart IDs: $cartIds");

    if (cartIds.isEmpty) {
      print("Cart is empty.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    ClothingService clothingService = ClothingService();
    try {
      List<Map<String, dynamic>> fetchedItems = [];
      for (String itemId in cartIds) {
        Map<String, dynamic>? item = await clothingService.fetchClothingItemById(itemId);
        if (item != null) {
          fetchedItems.add({
            ...item,
            'quantity': 1, // Assuming a default quantity for now
          });

          print('Fetched item details: ${item.toString()}');
        } else {
          print("Item with ID $itemId not found in database.");
        }
      }

      setState(() {
        cartItems = fetchedItems;
        _isLoading = false;
      });

      print('Total cart items fetched: ${cartItems.length}');
    } catch (e) {
      print("Error fetching cart items: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeItemFromCart(String itemId) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      cartItems.removeWhere((item) => item['id'] == itemId);
    });

    List<dynamic> updatedCart = userProvider.userData?['cart'] ?? [];
    updatedCart.remove(itemId);
    userProvider.saveUserData({'cart': updatedCart});
  }

  double _calculateSubtotal() {
    return cartItems.fold(0.0, (total, current) {
      return total + (current['price'] * current['quantity']);
    });
  }

  double _calculateTotal() {
    return _calculateSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
                Provider.of<UserProvider>(context, listen: false).saveUserData({'cart': []});
              });
            },
            child: Text(
              'Remove All',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Text(
                    "Your cart is empty.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Cart Items List
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return CartItemCard(
                              item: item,
                              onRemoved: () => _removeItemFromCart(item['id']),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),

                      // Summary Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSummaryRow('Total articles', _calculateSubtotal()),
                          Divider(),
                          _buildSummaryRow('Total', _calculateTotal(), isTotal: true),
                        ],
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle navigation between tabs here
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} MAD',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
