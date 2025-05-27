import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:helpables/Modal/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:helpables/Providers/aidrequests_provider.dart';
import 'package:helpables/Providers/categories_providers.dart';

// ignore: must_be_immutable
class FilterScreen extends StatefulWidget {
  FilterScreen(
      {super.key,
      required this.selectedCategory,
      required this.selectedLocation});

  @override
  _FilterScreenState createState() => _FilterScreenState();
  String? selectedCategory;
  String? selectedLocation;
}

class _FilterScreenState extends State<FilterScreen> {
  bool showCategories = false;
  bool showLocations = false;
  List<String> _uniqueLocations = [];

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<String> getCityFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      return placemarks.isNotEmpty ? placemarks[0].locality ?? '' : '';
    } catch (e) {
      print("Error getting city: $e");
      return '';
    }
  }

  Future<void> fetchLocations() async {
    final aidRequests = Provider.of<AidRequestsProvider>(context, listen: false)
        .getRequestsList();

    Set<String> cityNames = {};
    for (var request in aidRequests) {
      double lat = request.location['latitude'];
      double lon = request.location['longitude'];

      String city = await getCityFromCoordinates(lat, lon);
      if (city.isNotEmpty) {
        cityNames.add(city);
      }
    }

    setState(() {
      _uniqueLocations = cityNames.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryItems =
        Provider.of<CategoriesProvider>(context).categoryitems;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("Filters",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.TextsColor)),
              SizedBox(height: 10),
              Divider(
                color: AppColors.BordersColor,
              ),
              SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white)),
                          onPressed: () => setState(() {
                            showCategories = !showCategories;
                            showLocations = false;
                          }),
                          child: Text("Category",
                              style: TextStyle(color: AppColors.TextsColor)),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white)),
                          onPressed: () => setState(() {
                            showLocations = !showLocations;
                            showCategories = false;
                          }),
                          child: Text("Location",
                              style: TextStyle(color: AppColors.TextsColor)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: VerticalDivider(
                        color: AppColors.BordersColor,
                        thickness: 1,
                        width: 1,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            right: showCategories
                                ? 0
                                : -MediaQuery.of(context).size.width * 0.6,
                            top: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.66,
                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              child: ListView(
                                controller: scrollController,
                                children: categoryItems.map((category) {
                                  return ListTile(
                                    title: Text(category.title,
                                        style: TextStyle(fontSize: 16)),
                                    onTap: () => setState(() => widget
                                        .selectedCategory = category.title),
                                    leading: widget.selectedCategory ==
                                            category.title
                                        ? Icon(Icons.check, color: AppColors.TextsColor)
                                        : null,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            right: showLocations
                                ? 0
                                : -MediaQuery.of(context).size.width * 0.6,
                            top: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.65,
                              color: Colors.white,
                              padding: EdgeInsets.all(10),
                              child: _uniqueLocations.isEmpty
                                  ? Center(child: Text("No locations found"))
                                  : ListView(
                                      controller: scrollController,
                                      children: _uniqueLocations.map((loc) {
                                        return ListTile(
                                          title: Text(loc,
                                              style: TextStyle(fontSize: 16)),
                                          onTap: () {
                                            setState(() =>
                                                widget.selectedLocation = loc);
                                          },
                                          leading: widget.selectedLocation ==
                                                  loc
                                              ? Icon(Icons.check,
                                                  color: AppColors.TextsColor)
                                              : null,
                                        );
                                      }).toList(),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      onPressed: () {
                        setState(() {
                          widget.selectedCategory = null;
                          widget.selectedLocation = null;
                        });
                        Navigator.pop(context, {
                          'category': widget.selectedCategory,
                          'location': widget.selectedLocation
                        });
                      },
                      child: Text(
                        "Clear Filters",
                        style: TextStyle(color: AppColors.TextsColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white)),
                      onPressed: () {
                        Navigator.pop(context, {
                          'category': widget.selectedCategory,
                          'location': widget.selectedLocation
                        });
                      },
                      child: Text("Show Results",
                          style: TextStyle(color: AppColors.TextsColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
