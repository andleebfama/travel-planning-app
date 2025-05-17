import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ExploreScreen()));

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedTag = "All";
  String searchQuery = "";

  List<String> tags = [
    "All",
    "Adventure",
    "Nature",
    "Historical",
    "Beaches",
    "Romantic",
    "Luxury",
  ];

 List<Destination> destinations = [
  Destination(
    name: "Paris",
    description: "A beautiful city full of romance and culture.",
    imageUrl: "images/paris.jpg",
    tags: ["Romantic", "Historical"],
    tripHighlights: "Eiffel Tower, Romantic Cruise, French Cuisine",
    price: 1200,
  ),
  Destination(
    name: "Bali",
    description: "A tropical paradise with stunning beaches.",
    imageUrl: "images/bali.jpg",
    tags: ["Beaches"],
    tripHighlights: "Beach Resorts, Surfing, Local Temples",
    price: 950,
  ),
  Destination(
    name: "Japan",
    description: "A perfect place for adventure and nature lovers.",
    imageUrl: "images/japan.jpg",
    tags: ["Adventure", "Nature"],
    tripHighlights: "Mount Fuji, Bullet Train Ride, Temples",
    price: 1500,
  ),
  Destination(
    name: "Tokyo",
    description: "A bustling metropolis with vibrant culture and technology.",
    imageUrl: "images/tokyo.jpg",
    tags: ["Luxury", "Historical"],
    tripHighlights: "Skytree, Shopping, Sushi Experience",
    price: 1800,
  ),
  Destination(
    name: "Istanbul",
    description: "Known for its rich culture and historical sites.",
    imageUrl: "images/istanbul.jpg",
    tags: ["Historical", "Nature"],
    tripHighlights: "Blue Mosque, Bosphorus Cruise, Turkish Food",
    price: 1000,
  ),
  Destination(
    name: "London",
    description: "Known for Big Ben and the London Eye.",
    imageUrl: "images/london.jpg",
    tags: ["Historical", "Luxury"],
    tripHighlights: "Big Ben, London Eye, River Thames",
    price: 1300,
  ),
  Destination(
    name: "New York",
    description: "Famous for Times Square and Central Park.",
    imageUrl: "images/new_york.jpg",
    tags: ["Luxury", "Historical"],
    tripHighlights: "Times Square, Statue of Liberty, Central Park",
    price: 1600,
  ),
  Destination(
    name: "Dubai",
    description: "Known for Burj Khalifa and luxury shopping.",
    imageUrl: "images/dubai.jpg",
    tags: ["Luxury", "Beaches"],
    tripHighlights: "Burj Khalifa, Shopping Malls, Desert Safari",
    price: 1700,
  ),
  Destination(
    name: "Cape Town",
    description: "Famous for Table Mountain and coastal views.",
    imageUrl: "images/cape_town.jpg",
    tags: ["Nature", "Adventure"],
    tripHighlights: "Table Mountain, Robben Island, Beaches",
    price: 1400,
  ),
  Destination(
    name: "Bangkok",
    description: "Known for street food and temples.",
    imageUrl: "images/bangkok.jpg",
    tags: ["Historical", "Adventure"],
    tripHighlights: "Grand Palace, Street Food, Floating Market",
    price: 1100,
  ),
];


  List<Destination> get filteredDestinations {
    List<Destination> filtered = destinations;

    if (selectedTag != "All") {
      filtered =
          filtered.where((dest) => dest.tags.contains(selectedTag)).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((dest) =>
              dest.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Destinations"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for a city or destination...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTag = tags[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedTag == tags[index]
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        tags[index],
                        style: TextStyle(
                          color: selectedTag == tags[index]
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredDestinations.isEmpty
                ? Center(child: Text("No destinations found."))
                : GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredDestinations.length,
                    itemBuilder: (context, index) {
                      final dest = filteredDestinations[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DestinationDetailScreen(destination: dest),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Image.network(
                                    dest.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dest.name,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text(
                                      dest.description,
                                      style: TextStyle(fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailScreen({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destination.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              destination.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Icon(Icons.star_half, color: Colors.amber, size: 20),
                      Icon(Icons.star_border, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text("3.5/5", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    destination.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Trip Highlights",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...destination.tripHighlights.split(',').map((highlight) {
                    return Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(child: Text(highlight.trim())),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  Text(
                    "Package Price",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${destination.price.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Booking functionality coming soon!"),
                          ),
                        );
                      },
                      icon: Icon(Icons.flight_takeoff),
                      label: Text("Join This Trip"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 14.0),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Destination {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String tripHighlights;
  final double price;

  Destination({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.tripHighlights,
    required this.price,
  });
}