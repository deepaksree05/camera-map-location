import 'package:cameramaplocation/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(latitude: 13.106745, longitude: 80.096954, address: ''),
    this.isSelecting = false,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation; // Changed to nullable type

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
        actions: [
          if (widget.isSelecting)
          IconButton(onPressed: _pickedLocation == null ? null:(){
            Navigator.of(context).pop(_pickedLocation);
          }, icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude),
          zoom: 20,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: _pickedLocation != null
            ? {
          Marker(
            markerId: MarkerId('m1'),
            position: _pickedLocation!, // Use ! to assert non-null
          ),
        }
            : {},
      ),
    );
  }
}

// Address
//https://maps.googleapis.com/maps/api/geocode/json?latlng=28.640964,77.235875&extra_computations=ADDRESS_DESCRIPTORS&key=YOUR_API_KEY