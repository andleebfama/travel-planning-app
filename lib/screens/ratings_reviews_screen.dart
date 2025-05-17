import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/rating_review.dart';
import 'package:uuid/uuid.dart';

class RatingsReviewsScreen extends StatefulWidget {
  final String placeId; 

  const RatingsReviewsScreen({required this.placeId});

  @override
  _RatingsReviewsScreenState createState() => _RatingsReviewsScreenState();
}

class _RatingsReviewsScreenState extends State<RatingsReviewsScreen> {
  List<RatingReview> reviews = [];
  bool isLoading = true;
  double averageRating = 0;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  void fetchReviews() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('places')
          .doc(widget.placeId)
          .collection('reviews')
          .get();

      setState(() {
        reviews = snapshot.docs
            .map((doc) => RatingReview.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        // Calculate average rating
        averageRating = reviews.isEmpty
            ? 0
            : reviews.fold(0.0, (sum, review) => sum + review.rating) /
                reviews.length;
        isLoading = false;
      });
    }
  }

  void addReview() async {
    TextEditingController reviewController = TextEditingController();
    double rating = 3.0;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Review"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reviewController,
              decoration: InputDecoration(labelText: "Write a Review"),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.toString(),
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            Text("Rating: ${rating.toStringAsFixed(1)} stars"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reviewController.text.isNotEmpty) {
                String reviewId = Uuid().v4();
                RatingReview newReview = RatingReview(
                  id: reviewId,
                  title: widget.placeId, 
                  rating: rating,
                  review: reviewController.text,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  date: DateTime.now(),
                );

                
                await FirebaseFirestore.instance
                    .collection('places')
                    .doc(widget.placeId)
                    .collection('reviews')
                    .doc(reviewId)
                    .set(newReview.toMap());

                setState(() {
                  reviews.add(newReview);
                  averageRating = reviews.fold(0.0, (sum, review) => sum + review.rating) / reviews.length;
                });

                Navigator.pop(context);
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ratings & Reviews")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Average Rating: ${averageRating.toStringAsFixed(1)} ⭐", style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: addReview,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      RatingReview review = reviews[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(review.review),
                          subtitle: Text("Rating: ${review.rating.toStringAsFixed(1)} ⭐"),
                          trailing: Icon(Icons.comment),
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
