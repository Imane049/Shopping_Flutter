import 'package:flutter/material.dart';
import '../components/navigationBar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/UserProvider.dart';
import '../pages/ClothingDetailPage.dart';
import 'package:flutter_application_2/pages/UserProfile.dart';

class ClothingList extends StatefulWidget {
  @override
  _ClothingListState createState() => _ClothingListState();
}

class _ClothingListState extends State<ClothingList> {
  final Color pinkColor = Color.fromARGB(255, 246, 144, 178);

  String selectedBrand = "All Brands"; // Default selection for the dropdown
  List<String> brands = ["All Brands", "Nike", "Adidas", "Puma", "Bata", "Wilson"]; // Example brands

  // Placeholder list of clothing items
  final List<Map<String, dynamic>> clothingItems = [
  // Original items
  {
    'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShSFVet4sw30SmaiafHP_7P1iYGBb6ygbq-g&s',
    'title': 'Casual Brown',
    'size': 'M',
    'price': 23.09,
    'brand': 'Bata',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Casual Blue',
    'size': 'L',
    'price': 12.09,
    'brand': 'Nike',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Sport Leather',
    'size': 'S',
    'price': 33.29,
    'brand': 'Adidas',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Sport Ride White',
    'size': 'XL',
    'price': 13.54,
    'brand': 'Puma',
  },
  // New items
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Classic Red',
    'size': 'M',
    'price': 19.99,
    'brand': 'Adidas',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Running Shoes Black',
    'size': 'L',
    'price': 49.99,
    'brand': 'Nike',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Hiking Boots',
    'size': 'XL',
    'price': 75.00,
    'brand': 'Wilson',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Sport Sneakers',
    'size': 'S',
    'price': 27.99,
    'brand': 'Puma',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'White Classic Shoes',
    'size': 'M',
    'price': 22.00,
    'brand': 'Bata',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Blue Skate Shoes',
    'size': 'L',
    'price': 31.49,
    'brand': 'Nike',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'High Top Sneakers',
    'size': 'M',
    'price': 40.99,
    'brand': 'Adidas',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Summer Sandals',
    'size': 'S',
    'price': 15.29,
    'brand': 'Wilson',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Comfort Running',
    'size': 'XL',
    'price': 18.75,
    'brand': 'Puma',
  },
  {
    'imageUrl': 'https://via.placeholder.com/150',
    'title': 'Leather Boots',
    'size': 'M',
    'price': 52.90,
    'brand': 'Bata',
  },
];


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
      body: Padding(
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

            return GestureDetector(
              onTap: () {
                // Placeholder for clothing detail page navigation
                print('Tapped on ${clothingItem['title']}');
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage(clothingItem['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clothingItem['title'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Size: ${clothingItem['size']}",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${clothingItem['price'].toString()} MAD",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: pinkColor),
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
        bottomNavigationBar: BottomNavBar(
        currentIndex: 0, 
        onTap: (index) {
        },
      ),
    );
  }
}

