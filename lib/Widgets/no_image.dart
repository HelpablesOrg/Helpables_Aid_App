import '../Widgets/image_drawer.dart';
import 'package:flutter/material.dart';

class NoImage extends StatelessWidget {
  const NoImage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                elevation: 10,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                builder: (BuildContext context) {
                  return ImagesDrawer();
                });
          },
          child: Container(
            padding: const EdgeInsets.all(40),
            color: Colors.grey[400],
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.image,
                  color: Colors.black,
                  size: 36,
                ),
                const Text(
                  'No Image Chosen yet',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                const Text(
                  'You can add upto 5 images',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                IconButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            const Color.fromARGB(255, 255, 247, 247))),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          elevation: 10,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          builder: (BuildContext context) {
                            return ImagesDrawer();
                          });
                    },
                    icon: const Icon(Icons.add, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
