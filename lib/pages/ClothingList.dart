import 'package:flutter/material.dart';
import '../components/navigationBar.dart';
import '../components/clothingItem.dart'; // Import the ClothingItemCard component
import '../handlers/ClothingService.dart';

class ClothingList extends StatefulWidget {
  @override
  _ClothingListState createState() => _ClothingListState();
}

class _ClothingListState extends State<ClothingList> {
  final Color pinkColor = Color.fromARGB(255, 246, 144, 178);
  String selectedBrand = "All Brands"; // Default selection for the dropdown
  List<String> brands = ["All Brands", "Nike", "Adidas", "Puma", "Bata", "Wilson"]; // Example brands

  final List<Map<String, dynamic>> clothingItems = []; // List to store fetched items
  bool _isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _fetchClothingItems();
  }

  Future<void> _fetchClothingItems() async {
    try {
      ClothingService clothingService = ClothingService();
      List<Map<String, dynamic>> fetchedItems = await clothingService.fetchAllClothingItems();
      setState(() {
        clothingItems.addAll(fetchedItems);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching clothing items: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pinkColor,
        title: Text("Popular Products"),
        actions: [
          DropdownButton<String>(
            value: selectedBrand,
            items: brands.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedBrand = newValue!;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: clothingItems.length,
                itemBuilder: (context, index) {
                  final clothingItem = clothingItems[index];

                  // Filter items based on selected brand
                  if (selectedBrand != "All Brands" && clothingItem['brand'] != selectedBrand) {
                    return Container(); // Skip items not matching the selected brand
                  }

                  return ClothingItemCard(clothingItem: clothingItem);
                },
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
        },
      ),
    );
  }
}
