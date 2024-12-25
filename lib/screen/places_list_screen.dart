import 'package:cameramaplocation/providers/great_places.dart';
import 'package:cameramaplocation/screen/add_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
          }, icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) {
          // Check if the future is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Now we can access the items from the provider
          final greatPlaces = Provider.of<GreatPlaces>(context); // Access the provider again

          // Check if there are no places
          if (greatPlaces.items.isEmpty) {
            return Center(
              child: const Text('Got No Places Yet, Start Adding Some!'),
            );
          } else {
            // If there are places, display them in a ListView
            return ListView.builder(
              itemCount: greatPlaces.items.length,
              itemBuilder: (ctx, i) {
                final place = greatPlaces.items[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(place.image), // Assuming place.image is a File
                  ),
                  title: Text(place.title),
                  subtitle: Text(greatPlaces.items[i].location!.address),

                  onTap: () {
                    // Handle tap event here
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
