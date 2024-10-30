import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddClothingItem extends StatefulWidget {
  @override
  _AddClothingItemState createState() => _AddClothingItemState();
}

class _AddClothingItemState extends State<AddClothingItem> {
  final Color pinkColor = Color.fromARGB(255, 246, 144, 178);

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController =
      TextEditingController(text: 'Pantalon'); // Example fixed category
  final TextEditingController _imagePathController =
      TextEditingController(); // Hidden field for storing image URL

  File? _selectedImage; // To hold the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  bool _isUploading = false; // Track image upload status

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Upload to Firebase Storage and get the URL
        await _uploadImageToFirebase(_selectedImage!);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImageToFirebase(File image) async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Create a unique file name based on current timestamp
      String fileName = 'clothing_items/${DateTime.now().millisecondsSinceEpoch}.jpg';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(fileName);

      // Upload the file
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imagePathController.text = downloadUrl; // Set the image URL to the hidden field
        _isUploading = false;
      });

      print("Image uploaded successfully. URL: $downloadUrl");
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pinkColor,
        title: Text('Add Clothing Item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 16),

            // Size Field
            TextFormField(
              controller: _sizeController,
              decoration: InputDecoration(labelText: "Size"),
            ),
            const SizedBox(height: 16),

            // Brand Field
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: "Brand"),
            ),
            const SizedBox(height: 16),

            // Price Field (digits only)
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Category Field (read-only)
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: "Category"),
              readOnly: true,
            ),
            const SizedBox(height: 16),

            // Hidden ImagePath Field
            TextFormField(
              controller: _imagePathController,
              decoration: InputDecoration(labelText: "Image Path (Hidden)"),
              readOnly: true,
              enabled: false, // Disable the field to hide it from editing
            ),
            const SizedBox(height: 16),

            // Image Upload Section
            Text(
              "Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.upload_file),
              label: Text('Upload from Device'),
              style: ElevatedButton.styleFrom(
                backgroundColor: pinkColor,
              ),
            ),
            const SizedBox(height: 16),

            // Display selected image (if any)
            if (_selectedImage != null)
              Column(
                children: [
                  if (_isUploading)
                    CircularProgressIndicator()
                  else
                    Text(
                      "Selected Image:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Placeholder for the logic part
                  print("Submit new clothing item");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  "Add Clothing Item",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
