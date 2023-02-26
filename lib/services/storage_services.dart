import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageServices {
  // This function allows the user to select an image from their device's photo gallery
  Future<File> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      throw Exception('No image selected');
    }
  }

// This function uploads the image file to Firebase Storage and returns the URL of the uploaded file
  Future<String> uploadImageToFirebase(File file) async {
    // Generate a unique filename for the uploaded image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profile_images').child(fileName);

    // Upload the image file to Firebase Storage
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

    // Return the download URL of the uploaded file
    return await storageSnapshot.ref.getDownloadURL();
  }

// Call this function to upload the user's profile photo to Firebase Storage and update the user's profile in Firestore
  Future<void> uploadProfilePhoto() async {
    // Select an image from the user's photo gallery
    File imageFile = await pickImage();

    // Upload the image to Firebase Storage and get the download URL
    String photoUrl = await uploadImageToFirebase(imageFile);

    // Update the user's profile in Firestore with the new photo URL
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilePhoto': photoUrl});
    }
  }
}
