import '../Modal/PlaceLocation.dart';
import '../Providers/add_aid_requestprov.dart';
import '../Screens/Maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

class FormWidget extends StatefulWidget {
  FormWidget({super.key, required this.formKey});
  GlobalKey<FormState> formKey;
  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool check = false;
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddAidRequestProvider>(context, listen: true);
    Future<String> getAddressFromLatLng(double lat, double lng) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        return address;
      } catch (e) {
        return "Address not found";
      }
    }

    Future<void> selectOnMap() async {
      final selectedLocation =
          await Navigator.of(context).push<LatLng>(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
          initialLocation: const PlaceLocation(
              latitude: 37.422, longitude: -122.084, address: ''),
        ),
      ));
      if (selectedLocation == null) {
        setState(() {
          check = false;
        });
        return;
      }
      setState(() {
        check = true;
      });
      String address = await getAddressFromLatLng(
          selectedLocation.latitude, selectedLocation.longitude);
      PlaceLocation location = PlaceLocation(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
          address: address);
      _locationController.text = location.address;
      provider.getLocation(location);
    }

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  counterText: '${_titleController.text.length}/100'),
              onChanged: (value) {
                setState(() {});
                provider.getTitle(_titleController.text);
              },
              onFieldSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(_focusNode),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '*Title is required';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLength: 500,
              focusNode: _focusNode,
              decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  counterText: '${_descriptionController.text.length}/500'),
              onChanged: (value) {
                setState(() {});
                provider.getDescription(_descriptionController.text);
              },
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '*Description is required';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
                readOnly: true,
                controller: _locationController,
                autocorrect: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    labelText: 'Location',
                    hintText: 'Please pick a location from map',
                    labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    suffixIcon: IconButton(
                        onPressed: () => selectOnMap(),
                        icon: Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.primary,
                        )))),
          ],
        ),
      ),
    );
  }
}
