import 'dart:io';

import 'package:cameramaplocation/providers/great_places.dart';
import 'package:cameramaplocation/widgets/image_input.dart';
import 'package:cameramaplocation/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';


class AddPlaceScreen extends StatefulWidget {

  static const routeName = '/add-place';
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  late File _pickedImage;

  late PlaceLocation _pickedLocation;

  void _selectedImage(File pickedImage){
      _pickedImage = pickedImage;
  }

  void _selectPlace(double lat,double lng){
   _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: '');
  }

  void _savePlace(){
    if (_titleController.text.isEmpty || _pickedImage == null || _pickedLocation == null ){
      return;
    }
    Provider.of<GreatPlaces>(context,listen: false).addPlace(_titleController.text, _pickedImage,_pickedLocation);
  Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Place'),
      ),
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Expanded(child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Title'
                  ),
                  controller: _titleController,
                ),
                SizedBox(height: 10,),
                ImageInput(_selectedImage),
                SizedBox(height: 10,),
                LocationInput(_selectPlace),
              ],
            ),
            ),
          )),


          TextButton(
            onPressed: () {
              _savePlace();
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).hintColor
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(Icons.add),
                SizedBox(width: 9),
                Text('Add Place'),

             ],
            ),
          ),
        ],
      ),
    );
  }
}
