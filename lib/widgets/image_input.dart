import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {

  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera, // Use ImageSource.camera or ImageSource.gallery
      maxWidth: 600,
    );

    if (imageFile != null) {
      setState(() {
        _storedImage = File(imageFile.path); // Store the picked image file
      });

      // Get the application documents directory
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path); // Get the base name of the file

      // Copy the image file to the application documents directory
      await imageFile.saveTo('${appDir.path}/$fileName'); // Save the image
//internal storage/camera/logo.png
      // Pass the stored image file to the onSelectImage callback
      widget.onSelectImage(_storedImage); // Pass the correct File object
    } else {
      print('No image selected.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
            _storedImage!,
            fit: BoxFit.cover,
          )
              : Center(child: Text('No Image Taken')),
        ),
        SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: _takePicture,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera),
                SizedBox(width: 10),
                Text('Take Picture'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}