

import 'dart:core';
import 'dart:io';

import 'package:cameramaplocation/helpers/dp_helper.dart';
import 'package:cameramaplocation/helpers/location_helper.dart';
import 'package:cameramaplocation/models/place.dart';
import 'package:flutter/cupertino.dart';

class GreatPlaces with ChangeNotifier{

  List <Place> _items = [];
  List <Place> get items{
    return [..._items];
  }

  Future<void> addPlace(String pickedTitle, File pickedImage, PlaceLocation pickedLocation) async {
    // Get the address from the location helper
    final address = await LocationHelper.getPlaceAddress(pickedLocation.latitude, pickedLocation.longitude);

    // Create a new PlaceLocation object with correct parameters
    final updateLocation = PlaceLocation(
      latitude: pickedLocation.latitude,  // Use latitude value
      longitude: pickedLocation.longitude, // Use longitude value
      address: address,
    );

    // Create a new Place object
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      image: pickedImage,
      location: updateLocation,
    );

    // Add the new place to the items list
    _items.add(newPlace);

    // Notify listeners for state changes
    notifyListeners();

    // Insert the new place into the database
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat':newPlace.location!.latitude,
      'loc_lng':newPlace.location!.longitude,
      'address': newPlace.location!.address,
    });
  }
//PlaceLocation(latitude: 0.00, longitude: 0.00, address: ''),

  Future<void> fetchAndSetPlaces() async {
    try {
      final dataList = await DBHelper.getData('user_places'); // Await the database call
      _items = dataList.map((item) {
        return Place(
          id: item['id'], // Assuming 'id' is a field in your database
          title: item['title'], // Assuming 'title' is a field in your database
          image: File(item['image']), // Convert the image path string to a File object
          location: PlaceLocation(latitude: item['loc_lat'], longitude: item['loc_lng'], address: item['address']), // Set location appropriately if available
        );
      }).toList();
    } catch (error) {
      print('Error fetching places: $error');
      // Handle error (e.g., show a message to the user)
    }
  }
  }
