import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favorites = [
    'Paris, France',
    'Kyoto, Japan',
    'Machu Picchu, Peru',
    'Santorini, Greece',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: const Color.fromARGB(255, 25, 104, 107),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text(
                'You have no favorite destinations yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text(favorites[index]),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // You can implement detailed navigation if needed
                  },
                );
              },
            ),
    );
  }
}
