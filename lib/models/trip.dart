import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final String destination;
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
   final List<String> itinerary;

  Trip({
    required this.id,
    required this.destination,
    required this.budget,
    required this.startDate,
    required this.endDate,
    this.itinerary = const [],
  });

  // ✅ Save DateTime as Firestore Timestamp
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination': destination,
      'budget': budget,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'itinerary': itinerary,
    };
  }

  // ✅ Convert Timestamp back to DateTime
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      destination: map['destination'],
      budget: (map['budget'] as num).toDouble(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
       itinerary: List<String>.from(map['itinerary'] ?? []),
    );
  }
}
