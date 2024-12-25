import 'dart:ffi';
import 'package:cameramaplocation/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../models/place.dart';
import '../screen/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl; // Changed to nullable type

  void _showPreview(double lat, double lng) {
    final staticMapUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapUrl;
    });
  }

  Future<void> getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    if (locData != null) { // Check if locData is not null
      _showPreview(locData.latitude!, locData.longitude!); // Use null assertion
      widget.onSelectPlace(locData.latitude!, locData.longitude!);
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation != null) {
      widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
      _showPreview(selectedLocation.latitude, selectedLocation.longitude); // Show preview for selected location
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? Text(
            'No Location Chosen',
            textAlign: TextAlign.center,
          )
              : Image.network(
            _previewImageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
          children: [
            FloatingActionButton.extended(
              onPressed: getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location', style: TextStyle(color: Colors.indigo)),
            ),
            SizedBox(width: 10),
            FloatingActionButton.extended(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select On Map', style: TextStyle(color: Colors.indigo)),
            ),
          ],
        ),
      ],
    );
  }
}