import 'dart:io';
import '../Providers/add_aid_requestprov.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagesDrawer extends StatefulWidget {
  const ImagesDrawer({super.key});
  @override
  State<ImagesDrawer> createState() => _ImagesDrawerState();
}

class _ImagesDrawerState extends State<ImagesDrawer> {
  final snackBar = const SnackBar(content: Text('You can Add Upto 5 Images'));
  List<File> imageFile = [];
  final ImagePicker imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final images = Provider.of<AddAidRequestProvider>(context, listen: true);
    void pickImageFromGallery(BuildContext ctx) async {
      List<File> selectedImages = [];
      int remainingSlots = 5 - images.imagesItems.length;
      if (remainingSlots <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can only select up to 5 images.")),
        );
        return;
      }
      try {
        final image = ImagePicker();

        final XFile? pickedFile = await image.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        if (pickedFile == null) {
          return;
        } else {
          selectedImages.add(File(pickedFile.path));
        }

        setState(
          () => images.addImage(selectedImages),
        );
        if (images.imagesItems.length >= 5) {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
        }
      } on PlatformException catch (_) {}
    }

    void pickImageFromCamera(BuildContext ctx) async {
      imageFile = [];
      bool isLoading = false;
      try {
        var image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image == null) {
          return;
        } else {
          imageFile.add(File(image.path));
          setState(
            () => images.addImage(imageFile),
          );
        }
        if (images.imagesItems.length >= 5) {
          ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
          Navigator.pop(ctx);
        }
      } on PlatformException catch (_) {}
    }

    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 14.0),
            child: Text(
              'Upload Media',
              style: TextStyle(color: Color.fromARGB(255, 115, 115, 115)),
            ),
          ),
          Container(height: 0.4, width: double.infinity, color: Colors.grey),
          TextButton(
            child: const Text(
              'Capture Image',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              pickImageFromCamera(context);
            },
          ),
          TextButton(
              onPressed: () {
                pickImageFromGallery(context);
              },
              child: const Text(
                'Gallery',
                style: TextStyle(fontSize: 18),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
