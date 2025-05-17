import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlightsScreen extends StatefulWidget {
  const FlightsScreen({Key? key}) : super(key: key); // Add the `key` parameter here.

  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}


class _FlightsScreenState extends State<FlightsScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  DateTime? selectedDate;
  bool showResults = false;

  List<Map<String, String>> mockFlights = [
    {
      "airline": "AirSky",
      "time": "10:00 AM - 1:00 PM",
      "price": "\$220",
    },
    {
      "airline": "JetGo",
      "time": "3:00 PM - 6:00 PM",
      "price": "\$180",
    },
    {
      "airline": "FlyHigh",
      "time": "7:00 PM - 10:00 PM",
      "price": "\$210",
    },
  ];

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _bookFlight(Map<String, String> flight) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to book flights.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'from': fromController.text,
        'to': toController.text,
        'date': selectedDate?.toIso8601String(),
        'airline': flight['airline'],
        'time': flight['time'],
        'price': flight['price'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Flight booked successfully!")),
      );
    } catch (e) {
      print("Booking error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book flight.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Flights', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 22, 76, 80),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image with transparency
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background.jpg'), // Add your background image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), // Opacity effect
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Search for the Available Flights",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: const Color.fromARGB(255, 13, 13, 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width < 600 ? double.infinity : 400,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // From Field
                          TextFormField(
                            controller: fromController,
                            decoration: InputDecoration(
                              labelText: "From",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 12),

                          // To Field
                          TextFormField(
                            controller: toController,
                            decoration: InputDecoration(
                              labelText: "To",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 12),

                          // Departure Date
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedDate == null
                                      ? "Select Departure Date"
                                      : "Departure: ${selectedDate!.toLocal()}".split(' ')[0],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              TextButton(
                                onPressed: _selectDate,
                                child: Text(
                                  "Choose Date",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Centered Search Button
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (fromController.text.isNotEmpty &&
                                    toController.text.isNotEmpty &&
                                    selectedDate != null) {
                                  setState(() {
                                    showResults = true;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Please fill all fields")),
                                  );
                                }
                              },
                              icon: Icon(Icons.search),
                              label: Text("Search Flights"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 186, 195, 212),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  if (showResults)
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // prevent conflict with outer scroll
                      shrinkWrap: true,
                      itemCount: mockFlights.length,
                      itemBuilder: (context, index) {
                        final flight = mockFlights[index];
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.flight, color: Colors.blueAccent),
                            title: Text("${flight['airline']}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${flight['time']}"),
                                Text("${flight['price']}"),
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () => _bookFlight(flight),
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
