import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/models/trip.dart';
import 'package:flutter_application_1/screens/trip_detail_screen.dart';
import 'package:uuid/uuid.dart';


class PlanTripScreen extends StatefulWidget {
  @override
  _PlanTripScreenState createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  List<Trip> trips = [];
  bool isLoading = true;

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  @override
  void dispose() {
    destinationController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> fetchTrips() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final query = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('trips');

        QuerySnapshot snapshot = await query.get();
        setState(() {
          trips = snapshot.docs
              .map((doc) => Trip.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching trips: $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> createNewTrip() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    destinationController.clear();
    budgetController.clear();
    startDate = null;
    endDate = null;

    await showDialog(
  context: context,
  builder: (context) => Center( // 👈 Centers the dialog
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400), // 👈 Limits width
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setStateDialog) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create New Trip',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 8, 8, 8)),
                ),
                SizedBox(height: 20),
                _buildTextField(destinationController, 'Destination', icon: Icons.location_on),
                SizedBox(height: 10),
                _buildTextField(budgetController, 'Budget (USD)', inputType: TextInputType.number, icon: Icons.attach_money),
                SizedBox(height: 10),
                _buildDateButton('Pick Start Date', startDate, (pickedDate) {
                  setStateDialog(() => startDate = pickedDate);
                }),
                SizedBox(height: 10),
                _buildDateButton('Pick End Date', endDate, (pickedDate) {
                  setStateDialog(() => endDate = pickedDate);
                }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 200, 241, 241)),
                      onPressed: () => saveTrip(),
                      child: Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
  Future<void> saveTrip() async {
    if (destinationController.text.isNotEmpty &&
        budgetController.text.isNotEmpty &&
        startDate != null &&
        endDate != null) {
      try {
        double budget = double.parse(budgetController.text.replaceAll(RegExp(r'[^\d.]'), ''));
        String tripId = Uuid().v4();
        Trip newTrip = Trip(
          id: tripId,
          destination: destinationController.text.trim(),
          startDate: startDate!,
          endDate: endDate!,
          budget: budget,
          itinerary: [],
        );

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('trips')
              .doc(tripId)
              .set(newTrip.toMap());

          setState(() {
            trips.add(newTrip);
          });

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip created successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create trip.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields!')),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text, IconData? icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.teal) : null,
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: inputType,
    );
  }

  Widget _buildDateButton(String label, DateTime? date, Function(DateTime) onPicked) {
    return ElevatedButton.icon(
      onPressed: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      icon: Icon(Icons.calendar_today),
      label: Text(date == null ? label : DateFormat('MMM dd, yyyy').format(date)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 13, 14, 14),
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Trips"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, const Color.fromARGB(255, 82, 220, 238)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : trips.isEmpty
              ? Center(child: Text("No trips found. Create one!", style: TextStyle(fontSize: 18)))
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 10),
                  child: ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      Trip trip = trips[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 6,
                        margin: EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.teal.shade50, Colors.cyan.shade50],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ListTile(
                            title: Text(trip.destination, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            subtitle: Text(
                              "${DateFormat('MMM dd, yyyy').format(trip.startDate)} - ${DateFormat('MMM dd, yyyy').format(trip.endDate)}",
                            ),
                            trailing: Text(
                              "\$${trip.budget.toStringAsFixed(0)}",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewTrip,
        icon: Icon(Icons.add),
        label: Text('Add Trip',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 25, 26, 25),
      ),
    );
  }
}
