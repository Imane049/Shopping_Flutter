import 'package:flutter/material.dart';
import '../pages/ClothingDetailPage.dart';

class ClothingItemCard extends StatelessWidget {
  final Map<String, dynamic> clothingItem;

  ClothingItemCard({required this.clothingItem});

  @override
  Widget build(BuildContext context) {
    final Color pinkColor = Color.fromARGB(255, 246, 144, 178);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClothingDetailPage(clothingItem: clothingItem),
          ),
        );
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
                    image: NetworkImage(clothingItem['imagePath']),
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
  }
}
