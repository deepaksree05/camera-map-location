import 'package:cameramaplocation/providers/great_places.dart';
import 'package:cameramaplocation/screen/add_place_screen.dart';
import 'package:cameramaplocation/screen/places_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
      
         primarySwatch: Colors.indigo,
          hintColor: Colors.amber,

        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName:(ctx) => AddPlaceScreen(),
        },
      ),
    );
  }
}
