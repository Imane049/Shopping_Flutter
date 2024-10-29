import 'package:cloud_firestore/cloud_firestore.dart';

class ClothingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllClothingItems() async {
    List<Map<String, dynamic>> clothingItems = [];

    try {
      // Fetch all documents from the 'clothingItems' collection
      QuerySnapshot snapshot = await _firestore.collection('clothingItems').get();

      for (var doc in snapshot.docs) {
        // Convert each document into a map and add it to the list
        Map<String, dynamic> clothingItem = doc.data() as Map<String, dynamic>;
        clothingItems.add(clothingItem);
      }

      print('Fetched ${clothingItems.length} clothing items successfully.');
    } catch (e) {
      print('Error fetching clothing items: $e');
    }

    return clothingItems;
  }
}
