import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/navigationBar.dart';
import '../handlers/UserProvider.dart';
import '../handlers/ClothingService.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Color primaryColor = Color.fromARGB(255, 148, 92, 229);
  List<Map<String, dynamic>> cartItems = [];
  double shippingCost = 8.00;
  double tax = 0.0;
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
        // Fetch the item by its ID using ClothingService
        Map<String, dynamic>? item = await clothingService.fetchClothingItemById(itemId);
        if (item != null) {
          fetchedItems.add({
            ...item,
            'quantity': 1, // Assuming a default quantity for now
          });

          // Debugging: Log the fetched item details
          print('Fetched item details: ${item.toString()}');
        } else {
          print("Item with ID $itemId not found in database.");
        }
      }

      setState(() {
        cartItems = fetchedItems;
        _isLoading = false;
      });

      // Debugging: Log the total number of items fetched
      print('Total cart items fetched: ${cartItems.length}');
    } catch (e) {
      print("Error fetching cart items: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      setState(() {
        cartItems[index]['quantity']--;
      });
    }
  }

  void _removeAllItems() {
    setState(() {
      cartItems.clear();
      // Update cart in user provider as well
      Provider.of<UserProvider>(context, listen: false).saveUserData({'cart': []});
    });
  }

  double _calculateSubtotal() {
    return cartItems.fold(0.0, (total, current) {
      return total + (current['price'] * current['quantity']);
    });
  }

  double _calculateTotal() {
    return _calculateSubtotal() + shippingCost + tax;
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
            onPressed: _removeAllItems,
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
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Product Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(item['imagePath']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Size: ${item['size']}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            '${item['price'].toString()} MAD',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Quantity Controls
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.add, color: primaryColor),
                                          onPressed: () => _incrementQuantity(index),
                                        ),
                                        Text(
                                          '${item['quantity']}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.remove, color: primaryColor),
                                          onPressed: () => _decrementQuantity(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),

                      // Summary Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSummaryRow('Subtotal', _calculateSubtotal()),
                          _buildSummaryRow('Shipping Cost', shippingCost),
                          _buildSummaryRow('Tax', tax),
                          Divider(),
                          _buildSummaryRow('Total', _calculateTotal(), isTotal: true),
                        ],
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set to 1 for Cart tab
        onTap: (index) {
          // Optional: Handle other logic if needed
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
