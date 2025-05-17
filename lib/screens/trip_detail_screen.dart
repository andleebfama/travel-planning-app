import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/trip.dart';
import 'package:intl/intl.dart';

class TripDetailScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailScreen({required this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  List<String> itinerary = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItinerary();
  }

  Future<void> fetchItinerary() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trips')
        .doc(widget.trip.id)
        .get();

    if (doc.exists && doc.data()!.containsKey('itinerary')) {
      List<String> loaded = List<String>.from(doc.data()!['itinerary']);
      setState(() {
        itinerary = loaded;
        isLoading = false;
      });
    } else {
      setState(() {
        itinerary = [];
        isLoading = false;
      });
    }
  }

  Future<void> addItineraryItem(String item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => itinerary.add(item));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trips')
        .doc(widget.trip.id)
        .update({
      'itinerary': itinerary,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.trip.destination} Itinerary",style: TextStyle(
    color: const Color.fromARGB(255, 255, 255, 255),
        ),
        ),
        backgroundColor: const Color.fromARGB(255, 59, 158, 204),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTripOverview(),
                  SizedBox(height: 20),
                  Expanded(child: _buildItineraryList()),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItineraryDialog(),
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 204, 201, 209),
      ),
    );
  }

  Widget _buildTripOverview() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trip Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          SizedBox(height: 10),
          Text("Destination: ${widget.trip.destination}", style: TextStyle(fontSize: 18)),
          Text("Start Date: ${DateFormat('MMM dd, yyyy').format(widget.trip.startDate)}", style: TextStyle(fontSize: 18)),
          Text("End Date: ${DateFormat('MMM dd, yyyy').format(widget.trip.endDate)}", style: TextStyle(fontSize: 18)),
          Text("Budget: \$${widget.trip.budget.toStringAsFixed(2)}", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildItineraryList() {
    if (itinerary.isEmpty) {
      return Center(
        child: Text("No itinerary added.", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
      );
    }

    return ListView.builder(
      itemCount: itinerary.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            leading: Icon(Icons.today, color: Colors.deepPurple),
            title: Text("Day ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(itinerary[index]),
          ),
        );
      },
    );
  }

  void _showAddItineraryDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Itinerary Item"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter activity (e.g. Visit Eiffel Tower)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                addItineraryItem(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}
