import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpables/Providers/aidrequests_provider.dart';
import 'package:provider/provider.dart';

class AidRequestDetailScreen extends StatefulWidget {
  final int requestIndex;
  const AidRequestDetailScreen({super.key, required this.requestIndex});

  @override
  State<AidRequestDetailScreen> createState() => _AidRequestDetailScreenState();
}

class _AidRequestDetailScreenState extends State<AidRequestDetailScreen> {
  int _currentImageIndex = 0;
  String? address;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();

    final request = Provider.of<AidRequestsProvider>(
      context,
      listen: false,
    ).getRequestsList()[widget.requestIndex];

    final loc = request.location;
    latitude = (loc['latitude'] as num?)?.toDouble() ?? 0.0;
    longitude = (loc['longitude'] as num?)?.toDouble() ?? 0.0;

    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    if (latitude == null || longitude == null) return;

    try {
      final placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      final place = placemarks.first;
      setState(() {
        address = '${place.street}, ${place.locality}, ${place.postalCode}';
      });
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  String _cleanSubCategoryText(String input) {
    final cleaned = input.replaceAll(RegExp(r'[{}]'), '');
    if (cleaned.contains(':')) {
      return cleaned.split(':')[0].trim();
    }
    return cleaned.trim();
  }

  Color blue = Color(0xFF005481);
  Color buttonColor = Color(0xFF004164);

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<AidRequestsProvider>(context)
        .getRequestsList()[widget.requestIndex];

    return Scaffold(
      backgroundColor: blue,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text('Aid Request Details',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.5,
                        autoPlayAnimationDuration: Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: request.imgUrls.map((imgUrl) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            imgUrl,
                            width: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        request.imgUrls.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.blue[900]
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("Title",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                    const SizedBox(height: 4),
                    Text(request.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 8),
                    Divider(),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Chip(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: buttonColor)),
                              label: Text(
                                request.CategoryTitle,
                                style: TextStyle(color: buttonColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 32,
                          width: 1,
                          color: Colors.grey[400],
                          margin: const EdgeInsets.all(8),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: request.subCategories.map((subCat) {
                              return Chip(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: buttonColor)),
                                label: Text(
                                  _cleanSubCategoryText(subCat.toString()),
                                  style: TextStyle(color:buttonColor),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text("Description",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900])),
                    const SizedBox(height: 4),
                    Text(request.description,
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                    const SizedBox(height: 14),
                    Divider(),
                    const SizedBox(height: 14),
                    const Text("Location",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        address ?? "Loading address...",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude ?? 0.0, longitude ?? 0.0),
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("aid_location"),
                              position:
                                  LatLng(latitude ?? 0.0, longitude ?? 0.0),
                            ),
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(400, 40),
                          backgroundColor: buttonColor,
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(8),
                        ),
                        child: const Text('Donate Now',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
